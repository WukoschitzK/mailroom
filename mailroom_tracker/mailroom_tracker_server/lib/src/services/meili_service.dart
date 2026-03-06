import 'package:meilisearch/meilisearch.dart';
import '../generated/protocol.dart';

class MeiliService {
  // Verbindung zu unserem lokalen Meilisearch Docker-Container
  static final client = MeiliSearchClient('http://localhost:7700', 'meilisearch_geheim_123');

  static Future<void> syncShipment(Shipment shipment) async {
    try {
      final index = client.index('shipments');
      
      // Das Paket-Objekt in ein suchbares JSON-Format umwandeln
      await index.addDocuments([{
        'id': shipment.id,
        'identifier': shipment.identifier,
        'trackingNumber': shipment.trackingNumber ?? '',
        'recipientText': shipment.recipientText ?? '',
        'status': shipment.status,
        'note': shipment.note ?? '',
      }]);
      print("🔍 Paket ${shipment.id} an Meilisearch gesendet.");
    } catch (e) {
      print("❌ Meilisearch Sync Fehler: $e");
    }
  }

  // Ein Helfer, um initial alle bestehenden Pakete zu indizieren
  static Future<void> syncAll(List<Shipment> shipments) async {
    final index = client.index('shipments');
    final docs = shipments.map((s) => {
      'id': s.id,
      'identifier': s.identifier,
      'trackingNumber': s.trackingNumber ?? '',
      'recipientText': s.recipientText ?? '',
      'status': s.status,
      'note': s.note ?? '',
    }).toList();
    
    if (docs.isNotEmpty) {
      await index.addDocuments(docs);
      // Wir sagen Meilisearch, welche Felder besonders wichtig sind!
      await index.updateSearchableAttributes(['identifier', 'recipientText', 'trackingNumber', 'note']);
      print("✅ ${docs.length} Pakete erfolgreich in Meilisearch indiziert!");
    }
  }
}