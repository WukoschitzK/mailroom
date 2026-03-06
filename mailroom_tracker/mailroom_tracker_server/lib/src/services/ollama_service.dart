import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dotenv/dotenv.dart';

class OllamaService {
  static Future<Map<String, String>> analyzeImage(String imageUrl) async {
    try {
      print("🤖 Lade Bild herunter für KI-Analyse: $imageUrl");

      // 1. Bild vom Server laden
      final imageResponse = await http.get(Uri.parse(imageUrl));

      if (imageResponse.statusCode != 200) {
        throw Exception(
            "Bild konnte nicht geladen werden. Status: ${imageResponse.statusCode}");
      }

      // 2. In Base64 umwandeln (erforderlich für Vision-Modelle)
      final base64Image = base64Encode(imageResponse.bodyBytes);

      // 3. Umgebungsvariablen laden (.env)
      var env = DotEnv(includePlatformEnvironment: true)..load();

      // Fallback-Werte, falls die Variablen in der .env fehlen
      final ollamaBaseUrl = env['OLLAMA_BASE_URL'] ?? 'http://localhost:11434';
      final aiModel = env['OLLAMA_MODEL'] ?? 'llama3.2-vision';
      final apiUrl = '$ollamaBaseUrl/api/generate';

      // 4. Den Request für Ollama zusammenbauen
      final requestBody = jsonEncode({
        "model": aiModel,
        "prompt": "Finde auf diesem Post-Etikett den EMPFÄNGER. Achtung: Verwechsle ihn nicht mit dem Absender! Der Empfänger steht meistens größer, mittig oder unten rechts. Antworte AUSSCHLIESSLICH mit dem Vor- und Nachnamen des Empfängers, ohne Satzzeichen, ohne Erklärungen. Falls kein Name erkennbar ist, antworte mit 'Unbekannt'.",
        "images": [base64Image],
        "stream": false
      });

      print(
          "🤖 Sende Bild an externe Ollama API ($apiUrl) mit Modell '$aiModel'...");

      // 5. Request an Ollama senden
      final ollamaResponse = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      // 6. Antwort auswerten
      if (ollamaResponse.statusCode == 200) {
        final data = jsonDecode(ollamaResponse.body);

        // Den Namen aus dem JSON extrahieren und bereinigen
        final extractedName = data['response'].toString().trim();
        print("✅ Ollama hat geantwortet: $extractedName");

        return {
          'barcode':
              'SCAN_FEHLT', // Ersetzen wir im nächsten Schritt durch echten Barcode
          'recipient': extractedName,
          'department': 'Posteingang',
        };
      } else {
        // Falls Ollama z.B. wieder einen 404 (Modell nicht gefunden) wirft
        print(
            "❌ Ollama Fehler: ${ollamaResponse.statusCode} - ${ollamaResponse.body}");
        return _fallbackData();
      }
    } catch (e) {
      print("🚨 Schwerer Fehler bei Ollama-Verbindung: $e");
      return _fallbackData();
    }
  }

  // Fallback, damit die App nicht crasht, wenn der KI-Server down ist
  static Map<String, String> _fallbackData() {
    return {
      'barcode': 'FEHLER',
      'recipient': 'Manuelle Prüfung erforderlich',
      'department': 'Unbekannt',
    };
  }
}
