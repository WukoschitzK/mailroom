import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:mailroom_tracker_flutter/screens/login_screen.dart';

void main() {
  group('LoginScreen', () {
    // LoginScreen.initState calls client.auth.seedUsers() which fails without
    // a server. The catchError handles it gracefully, but we need to pump
    // a few frames to let the future settle.
    Future<void> pumpLoginScreen(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
    }

    testWidgets('renders the login UI elements', (tester) async {
      await pumpLoginScreen(tester);

      spotText('Poststellen Scanner').existsOnce();
      spotText('Bitte PIN eingeben').existsOnce();
      spotIcon(Icons.lock_person).existsOnce();
      spot<TextField>().existsOnce();
    });

    testWidgets('PIN field is obscured and numeric', (tester) async {
      await pumpLoginScreen(tester);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
      expect(textField.keyboardType, TextInputType.number);
      expect(textField.maxLength, 4);
      expect(textField.textAlign, TextAlign.center);
    });

    testWidgets('PIN field accepts input', (tester) async {
      await pumpLoginScreen(tester);

      await act.enterText(spot<TextField>(), '12');
      await tester.pump();

      final controller = tester.widget<TextField>(find.byType(TextField)).controller!;
      expect(controller.text, '12');
    });

    testWidgets('does not show error message initially', (tester) async {
      await pumpLoginScreen(tester);

      final redTextFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.style?.color == Colors.red,
      );
      expect(redTextFinder, findsNothing);
    });
  });
}
