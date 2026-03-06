import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:mailroom_tracker_flutter/globals.dart';
import 'package:mailroom_tracker_flutter/widgets/navigation.dart';

void main() {
  setUp(() {
    isCreatingNewSignal.value = false;
    selectedShipmentIdSignal.value = null;
  });

  group('MailroomSidebar', () {
    Widget buildSidebar() {
      return MaterialApp(
        home: Scaffold(
          body: Row(
            children: const [
              MailroomSidebar(),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }

    testWidgets('renders all navigation items', (tester) async {
      await tester.pumpWidget(buildSidebar());

      spotText('Mailroom').existsOnce();
      spotText('Dashboard').existsOnce();
      spotText('Sendungen').existsOnce();
      spotText('Neue Sendung').existsOnce();
      spotText('Settings').existsOnce();
    });

    testWidgets('Sendungen is active by default', (tester) async {
      await tester.pumpWidget(buildSidebar());

      final sendungenText = tester.widget<Text>(find.text('Sendungen'));
      expect(sendungenText.style?.color, const Color(0xFFFDE047));
    });

    testWidgets('tapping Neue Sendung sets isCreatingNewSignal', (tester) async {
      await tester.pumpWidget(buildSidebar());

      await act.tap(spotText('Neue Sendung'));
      expect(isCreatingNewSignal.value, true);
    });

    testWidgets('tapping Sendungen resets signals', (tester) async {
      isCreatingNewSignal.value = true;
      selectedShipmentIdSignal.value = 42;

      await tester.pumpWidget(buildSidebar());

      await act.tap(spotText('Sendungen'));
      expect(isCreatingNewSignal.value, false);
      expect(selectedShipmentIdSignal.value, null);
    });

    testWidgets('Neue Sendung becomes active when signal is true', (tester) async {
      isCreatingNewSignal.value = true;

      await tester.pumpWidget(buildSidebar());

      final neuText = tester.widget<Text>(find.text('Neue Sendung'));
      expect(neuText.style?.color, const Color(0xFFFDE047));

      final sendungenText = tester.widget<Text>(find.text('Sendungen'));
      expect(sendungenText.style?.color, Colors.grey);
    });
  });

  group('MailroomBottomNav', () {
    testWidgets('renders all navigation items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MailroomBottomNav())),
      );

      spotText('Sendungen').existsOnce();
      spotText('Neu').existsOnce();
      spotText('Suche').existsOnce();
      spotText('Settings').existsOnce();
    });

    testWidgets('tapping Neu sets isCreatingNewSignal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MailroomBottomNav())),
      );

      await act.tap(spotText('Neu'));
      expect(isCreatingNewSignal.value, true);
    });

    testWidgets('tapping Sendungen resets signals', (tester) async {
      isCreatingNewSignal.value = true;
      selectedShipmentIdSignal.value = 5;

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MailroomBottomNav())),
      );

      await act.tap(spotText('Sendungen'));
      expect(isCreatingNewSignal.value, false);
      expect(selectedShipmentIdSignal.value, null);
    });
  });
}
