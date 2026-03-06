import 'package:flutter_test/flutter_test.dart';
import 'package:mailroom_tracker_flutter/globals.dart';

void main() {
  group('parseRecipientDetails', () {
    test('parses a standard recipient text correctly', () {
      final text = 'Max Mustermann\n🏢 IT Abteilung | Raum 302\n✉️ max@firma.de';
      final result = parseRecipientDetails(text);

      expect(result['name'], 'Max Mustermann');
      expect(result['abteilung'], 'IT Abteilung');
      expect(result['ort'], 'Raum 302');
      expect(result['email'], 'max@firma.de');
    });

    test('returns empty name for empty string', () {
      final result = parseRecipientDetails('');
      // Empty string splits to [''], the else branch sets name = ''
      expect(result['name'], '');
      expect(result['abteilung'], '-');
      expect(result['ort'], '-');
      expect(result['email'], '-');
    });

    test('handles name-only text', () {
      final result = parseRecipientDetails('Sarah Jenkins');
      expect(result['name'], 'Sarah Jenkins');
      expect(result['abteilung'], '-');
      expect(result['ort'], '-');
      expect(result['email'], '-');
    });

    test('handles department without location', () {
      final text = 'Lisa Schmidt\n🏢 Marketing';
      final result = parseRecipientDetails(text);

      expect(result['name'], 'Lisa Schmidt');
      expect(result['abteilung'], 'Marketing');
      expect(result['ort'], '-');
    });

    test('handles redirect line (substitute)', () {
      final text = '👉 Weiterleitung an Vertretung\n🏢 HR | Büro 101\n✉️ vertretung@firma.de';
      final result = parseRecipientDetails(text);

      // 👉 line sets abteilung, then 🏢 line appends '\nHR'
      expect(result['abteilung'], '👉 Weiterleitung an Vertretung\nHR');
      expect(result['ort'], 'Büro 101');
      expect(result['email'], 'vertretung@firma.de');
    });

    test('handles warning line as name', () {
      final text = '⚠️ Name nicht erkannt';
      final result = parseRecipientDetails(text);
      expect(result['name'], '⚠️ Name nicht erkannt');
    });

    test('handles multiple department lines', () {
      final text = 'Test User\n🏢 Dept A | Room 1\n🏢 Dept B | Room 2';
      final result = parseRecipientDetails(text);

      expect(result['name'], 'Test User');
      expect(result['abteilung'], 'Dept A\nDept B');
      expect(result['ort'], 'Room 2');
    });
  });

  group('getInitials', () {
    test('generates initials from full name', () {
      expect(getInitials('Sarah Jenkins'), 'SJ');
    });

    test('generates single initial from first name only', () {
      expect(getInitials('Sarah'), 'S');
    });

    test('returns ? for empty string', () {
      expect(getInitials(''), '?');
    });

    test('returns ? for Unbekannt', () {
      expect(getInitials('Unbekannt'), '?');
    });

    test('uppercases initials', () {
      expect(getInitials('max mustermann'), 'MM');
    });

    test('handles names with more than two parts', () {
      expect(getInitials('Anna Maria Schmidt'), 'AM');
    });
  });
}
