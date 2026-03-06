import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'package:mailroom_tracker_server/src/services/ollama_service.dart';
import 'dart:typed_data';
import 'package:mailroom_tracker_server/src/services/email_service.dart';
import 'package:mailroom_tracker_server/src/services/meili_service.dart';

class ShipmentEndpoint extends Endpoint {
  
  // ==========================================
  // WEBSOCKET BRÜCKE
  // ==========================================
  @override
  Future<void> streamOpened(StreamingSession session) async {
    session.messages.addListener('mailroom', (message) {
      sendStreamMessage(session, message); 
    });
  }

  Future<Shipment> createShipment(Session session, Shipment shipment) async {
    final savedShipment = await Shipment.db.insertRow(session, shipment);
    
    // Sicherstellen, dass auch hier ein Broadcast gesendet wird!
    session.messages.postMessage('mailroom', ShipmentUpdateEvent(
      shipment: savedShipment,
      action: 'created',
    ));
    
    return savedShipment;
  }

  Future<List<Shipment>> getAllShipments(Session session) async {
    return await Shipment.db.find(session);
  }

  // ==========================================
  // 1. NUR ANALYSIEREN (Nichts speichern)
  // ==========================================
  Future<Shipment> analyzePackage(Session session, String imageUrl,
      String createdBy, String scannedBarcode, String storageLocation) async {
    final aiResult = await OllamaService.analyzeImage(imageUrl);
    String extractedName = aiResult['recipient'] ?? 'Unbekannt';

    String finalRecipientText = extractedName;
    int? finalRecipientId;

    var employee = await Employee.db
        .findFirstRow(session, where: (t) => t.name.equals(extractedName));

    if (employee != null) {
      if (employee.isAbsent && employee.substituteId != null) {
        var substitute =
            await Employee.db.findById(session, employee.substituteId!);
        finalRecipientId = substitute?.id;
        finalRecipientText =
            '⚠️ $extractedName ist abwesend!\n👉 Vertretung: ${substitute?.name}\n🏢 ${substitute?.department} | ${substitute?.officeNumber}\n✉️ ${substitute?.email}';
      } else {
        finalRecipientId = employee.id;
        finalRecipientText =
            '${employee.name}\n🏢 ${employee.department} | ${employee.officeNumber}\n✉️ ${employee.email}';
      }
    } else {
      finalRecipientText =
          '$extractedName\n❌ Nicht im System gefunden (Bitte manuell prüfen)';
    }

    return Shipment(
      identifier: extractedName,
      direction: 'incoming',
      type: 'package',
      status: 'scanned',
      trackingNumber: scannedBarcode,
      recipientText: finalRecipientText,
      recipientId: finalRecipientId,
      isDamaged: false,
      imageUrl: imageUrl,
      scannedAt: DateTime.now(),
      createdBy: createdBy,
      storageLocation: storageLocation, 
    );
  }

  // ==========================================
  // 2. ENDGÜLTIG SPEICHERN
  // ==========================================
  Future<Shipment> saveAnalyzedShipment(Session session, Shipment shipment) async {
    // 1. DB Speichern
    final savedShipment = await Shipment.db.insertRow(session, shipment);

    // 2. Dashboard aktualisieren
    session.messages.postMessage(
        'mailroom',
        ShipmentUpdateEvent(
          shipment: savedShipment,
          action: 'created',
        ));

    // 3. Externe Services (Abgesichert mit try-catch!)
    try {
      await MeiliService.syncShipment(savedShipment);

      if (savedShipment.recipientId != null) {
        var employee = await Employee.db.findById(session, savedShipment.recipientId!);
        if (employee != null && employee.email != null) {
          EmailService.sendDeliveryNotification(
            recipientEmail: employee.email!,
            recipientName: employee.name,
            trackingNumber: savedShipment.trackingNumber ?? 'Unbekannt',
          );
        }
      }
    } catch (e) {
      print('⚠️ Fehler bei Meilisearch oder EmailService (saveAnalyzedShipment): $e');
    }
    
    return savedShipment;
  }

  // ==========================================
  // PAKET AKTUALISIEREN (Edit)
  // ==========================================
  Future<Shipment> updateShipmentDetails(Session session, Shipment updatedShipment) async {
    await Shipment.db.updateRow(session, updatedShipment);

    session.messages.postMessage(
        'mailroom',
        ShipmentUpdateEvent(
          shipment: updatedShipment,
          action: 'updated',
        ));

    try {
      await MeiliService.syncShipment(updatedShipment);
    } catch (e) {
      print('⚠️ Fehler bei Meilisearch Sync (updateShipmentDetails): $e');
    }

    return updatedShipment;
  }

  // ==========================================
  // PAKET ÜBERGEBEN
  // ==========================================
  Future<Shipment> deliverPackage(Session session, int shipmentId,
      String signatureUrl, String deliveredBy) async {
    var shipment = await Shipment.db.findById(session, shipmentId);

    if (shipment == null) {
      throw Exception('Sendung nicht gefunden!');
    }

    shipment.status = 'delivered';
    shipment.deliveredAt = DateTime.now();
    shipment.signatureImageUrl = signatureUrl;
    shipment.deliveredBy = deliveredBy;

    await Shipment.db.updateRow(session, shipment);

    session.messages.postMessage(
        'mailroom',
        ShipmentUpdateEvent(
          shipment: shipment,
          action: 'updated',
        ));

    return shipment;
  }

  // ==========================================
  // BILD UPLOAD
  // ==========================================
  Future<String?> uploadImage(Session session, ByteData byteData, String fileName) async {
    await session.storage.storeFile(
      storageId: 'public',
      path: fileName,
      byteData: byteData,
    );

    final url = await session.storage.getPublicUrl(
      storageId: 'public',
      path: fileName,
    );

    return url?.toString();
  }

  // ==========================================
  // SEEDER
  // ==========================================
  Future<void> seedDatabase(Session session) async {
    var count = await Employee.db.count(session);

    if (count > 0 && count < 50) {
      var allEmployees = await Employee.db.find(session);
      for (var emp in allEmployees) {
        await Employee.db.deleteRow(session, emp);
      }
      count = 0;
    }

    if (count == 0) {
      print("🌱 Generiere 50 Test-Mitarbeiter...");

      var thomas = await Employee.db.insertRow(
          session,
          Employee(
              name: 'Thomas Müller',
              department: 'IT-Abteilung',
              isAbsent: false,
              email: 'thomas.mueller@firma.de',
              officeNumber: 'Stock 4, Büro 402'));

      await Employee.db.insertRow(
          session,
          Employee(
              name: 'Anna Schmidt',
              department: 'HR-Abteilung',
              isAbsent: true,
              substituteId: thomas.id,
              email: 'anna.schmidt@firma.de',
              officeNumber: 'Stock 1, Büro 105'));

      await Employee.db.insertRow(
          session,
          Employee(
              name: 'Max Mustermann',
              department: 'Marketing',
              isAbsent: false,
              email: 'max@firma.de',
              officeNumber: 'Stock 2, Büro 220'));

      final firstNames = ['Julia', 'Lukas', 'Sarah', 'Michael', 'Laura', 'Stefan', 'Lisa', 'Felix', 'Marie', 'David', 'Elena', 'Tobias'];
      final lastNames = ['Weber', 'Wagner', 'Becker', 'Hoffmann', 'Schäfer', 'Koch', 'Bauer', 'Richter', 'Klein', 'Wolf'];
      final departments = ['IT-Abteilung', 'HR-Abteilung', 'Marketing', 'Buchhaltung', 'Vertrieb', 'Logistik', 'Recht'];

      int employeeCounter = 4;

      for (var f in firstNames) {
        for (var l in lastNames) {
          if (employeeCounter > 50) break;

          String name = '$f $l';
          String dept = departments[employeeCounter % departments.length];
          String email = '${f.toLowerCase()}.${l.toLowerCase()}@firma.de';
          String office = 'Stock ${(employeeCounter % 5) + 1}, Büro ${(employeeCounter % 5) + 1}0${employeeCounter % 9}';
          bool isAbsent = (employeeCounter % 8 == 0);
          int? subId = isAbsent ? thomas.id : null;

          await Employee.db.insertRow(
              session,
              Employee(
                name: name,
                department: dept,
                isAbsent: isAbsent,
                email: email,
                officeNumber: office,
                substituteId: subId,
              ));

          employeeCounter++;
        }
        if (employeeCounter > 50) break;
      }
      print("✅ 50 Mitarbeiter erfolgreich in die Datenbank importiert!");
    }

    // Bereinigt: Nur noch EINMAL synchronisieren (und abgesichert!)
    try {
      var allShipments = await Shipment.db.find(session);
      await MeiliService.syncAll(allShipments);
      print("✅ Meilisearch erfolgreich synchronisiert!");
    } catch (e) {
      print("⚠️ Konnte nicht mit Meilisearch synchronisieren: $e");
    }
  }

  Future<String?> resolveEmployeeDetails(Session session, String name) async {
    // 1. Suche nach exaktem (oder sehr ähnlichem) Namen in der Datenbank
    var employee = await Employee.db.findFirstRow(session, where: (t) => t.name.equals(name));
    
    if (employee == null) return null; // Frontend bekommt Null = "Nicht gefunden"

    // 2. Erzeuge exakt den gleichen String wie bei der KI-Analyse (inklusive Vertretung)
    if (employee.isAbsent && employee.substituteId != null) {
      var substitute = await Employee.db.findById(session, employee.substituteId!);
      return '⚠️ ${employee.name} ist abwesend!\n👉 Vertretung: ${substitute?.name}\n🏢 ${substitute?.department} | ${substitute?.officeNumber}\n✉️ ${substitute?.email}';
    } else {
      return '${employee.name}\n🏢 ${employee.department} | ${employee.officeNumber}\n✉️ ${employee.email}';
    }
  }
}