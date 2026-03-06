import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:dotenv/dotenv.dart';

class EmailService {
  static Future<void> sendDeliveryNotification({
    required String recipientEmail,
    required String recipientName,
    required String trackingNumber,
  }) async {
    // 1. Umgebungsvariablen laden
    var env = DotEnv(includePlatformEnvironment: true)..load();
    final smtpHost = env['SMTP_HOST'] ?? 'sandbox.smtp.mailtrap.io';
    final smtpPort = int.tryParse(env['SMTP_PORT'] ?? '2525') ?? 2525;
    final smtpUser = env['SMTP_USER'] ?? '';
    final smtpPass = env['SMTP_PASS'] ?? '';

    // E-Mail Text vorbereiten
    final subject = '📦 Neue Sendung für Sie eingetroffen!';
    final textBody = 'Hallo $recipientName,\n\nes ist eine neue Sendung (Tracking: $trackingNumber) für Sie in der Poststelle eingetroffen. Sie können diese ab sofort abholen oder sie wird Ihnen beim nächsten Rundgang zugestellt.\n\nViele Grüße,\nIhre Poststelle';

    // 2. Wenn keine Zugangsdaten da sind, simulieren wir den Versand nur im Terminal
    if (smtpUser.isEmpty || smtpPass.isEmpty) {
      print("\n=========================================");
      print("📧 MOCK EMAIL VERSAND (SMTP-Daten fehlen)");
      print("AN: $recipientEmail");
      print("BETREFF: $subject");
      print("TEXT:\n$textBody");
      print("=========================================\n");
      return;
    }

    // 3. Echter SMTP-Versand
    final smtpServer = SmtpServer(smtpHost, port: smtpPort, username: smtpUser, password: smtpPass);

    final message = Message()
      ..from = const Address('poststelle@firma.de', 'Interne Poststelle')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = textBody;

    try {
      await send(message, smtpServer);
      print('✅ E-Mail erfolgreich gesendet an: $recipientEmail');
    } catch (e) {
      print('❌ Fehler beim Senden der E-Mail: $e');
    }
  }
}