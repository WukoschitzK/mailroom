import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AuthEndpoint extends Endpoint {
  
  // 1. Die Login-Methode (Prüft, ob der PIN in der Datenbank existiert)
  Future<MailroomUser?> login(Session session, String pin) async {
    return await MailroomUser.db.findFirstRow(
      session,
      where: (t) => t.pin.equals(pin),
    );
  }

  // 2. Unser Seeder: Legt automatisch 2 Test-Accounts an!
  Future<void> seedUsers(Session session) async {
    var count = await MailroomUser.db.count(session);
    if (count == 0) {
      // Max ist am Empfang, Laura in der Poststelle
      await MailroomUser.db.insertRow(session, MailroomUser(name: 'Max Empfang', pin: '1234', role: 'Leitung', location: 'Empfang'));
      await MailroomUser.db.insertRow(session, MailroomUser(name: 'Laura Post', pin: '0000', role: 'Zusteller', location: 'Poststelle'));
      print("🔑 2 Poststellen-Mitarbeiter erfolgreich angelegt!");
    }
  }
}