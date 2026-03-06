import 'package:flutter/material.dart';
import 'package:mailroom_tracker_client/mailroom_tracker_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';

// 1. CENTRAL SERVER CONNECTION
final client = Client(
  'http://localhost:8080/',
)..connectivityMonitor = FlutterConnectivityMonitor();

// 2. GLOBAL STATE SIGNALS
final ValueNotifier<MailroomUser?> currentUserSignal = ValueNotifier(null);
final shipmentsSignal = listSignal<Shipment>([]);
final isScanningSignal = signal<bool>(false);
final ValueNotifier<int?> selectedShipmentIdSignal = ValueNotifier(null);
final ValueNotifier<bool> isCreatingNewSignal = ValueNotifier(false);
final ValueNotifier<Shipment?> handoverShipmentSignal = ValueNotifier(null);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 3. CENTRAL WEBSOCKET LOGIC
bool _isWebSocketListening = false;

Future<void> initializeWebSocket() async {
  if (_isWebSocketListening) return;

  try {
    await client.openStreamingConnection();
    
    client.shipment.stream.listen((message) {
      if (message is ShipmentUpdateEvent) {
        debugPrint("🟢 WEBSOCKET: Aktion '${message.action}' für Paket ${message.shipment.id}");
        
        if (message.action == 'created') {
          shipmentsSignal.removeWhere((s) => s.id == message.shipment.id);
          shipmentsSignal.insert(0, message.shipment);
        } else if (message.action == 'updated') {
          final index = shipmentsSignal.indexWhere((s) => s.id == message.shipment.id);
          if (index != -1) {
            shipmentsSignal[index] = message.shipment;
          }
        }
      }
    }, 
    onError: (e) => debugPrint("🚨 WS Error: $e"), 
    onDone: () => _isWebSocketListening = false);

    _isWebSocketListening = true;
  } catch (e) {
    debugPrint("🚨 WebSocket Setup Fehler: $e");
  }
}

// ==========================================
// GLOBAL HELPER FUNCTIONS
// ==========================================
Map<String, String> parseRecipientDetails(String text) {
  String name = 'Unbekannt'; String abteilung = '-'; String ort = '-'; String email = '-';
  final lines = text.split('\n');
  for (String line in lines) {
    if (line.startsWith('🏢')) {
      final parts = line.replaceAll('🏢 ', '').split(' | ');
      if (abteilung == '-') {
        abteilung = parts[0];
      } else {
        abteilung += '\n${parts[0]}';
      }
      if (parts.length > 1) ort = parts[1];
    } else if (line.startsWith('✉️')) { email = line.replaceAll('✉️ ', '');
    } else if (line.startsWith('👉') || line.startsWith('❌')) { abteilung = line;
    } else if (line.startsWith('⚠️')) { name = line;
    } else { if (name == 'Unbekannt') name = line; }
  }
  return {'name': name, 'abteilung': abteilung, 'ort': ort, 'email': email};
}

// GENERATES AN INITIALS FROM A NAME (E.G. "Sarah Jenkins" -> "SJ")
String getInitials(String name) {
  if (name == 'Unbekannt' || name.isEmpty) return '?';
  final parts = name.split(' ');
  if (parts.length > 1) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  return parts[0][0].toUpperCase();
}