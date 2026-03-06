import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot/spot.dart';
import 'package:mailroom_tracker_flutter/widgets/ui_components.dart';

void main() {
  group('buildCard', () {
    testWidgets('renders child without title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCard(child: const Text('Card Content')),
          ),
        ),
      );

      spotText('Card Content').existsOnce();
    });

    testWidgets('renders title when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCard(
              title: 'SECTION TITLE',
              child: const Text('Content'),
            ),
          ),
        ),
      );

      spotText('SECTION TITLE').existsOnce();
      spotText('Content').existsOnce();
    });

    testWidgets('renders actionWidget when title and action provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCard(
              title: 'HEADER',
              actionWidget: const Icon(Icons.edit),
              child: const Text('Body'),
            ),
          ),
        ),
      );

      spotText('HEADER').existsOnce();
      spotIcon(Icons.edit).existsOnce();
      spotText('Body').existsOnce();
    });

    testWidgets('does not render actionWidget without title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCard(
              actionWidget: const Icon(Icons.edit),
              child: const Text('Body'),
            ),
          ),
        ),
      );

      // actionWidget is only rendered in the title row, which requires title != null
      spotIcon(Icons.edit).doesNotExist();
    });
  });

  group('buildTimelineItem', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildTimelineItem(
              title: 'Shipment logged',
              subtitle: '2024-01-01 · System',
              isLatest: false,
            ),
          ),
        ),
      );

      spotText('Shipment logged').existsOnce();
      spotText('2024-01-01 · System').existsOnce();
    });

    testWidgets('shows check icon when isLatest and not isPending', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildTimelineItem(
              title: 'Delivered',
              subtitle: 'Now',
              isLatest: true,
              isPending: false,
            ),
          ),
        ),
      );

      spotIcon(Icons.check).existsOnce();
    });

    testWidgets('does not show check icon when isPending', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildTimelineItem(
              title: 'Pending',
              subtitle: 'Waiting',
              isLatest: true,
              isPending: true,
            ),
          ),
        ),
      );

      spotIcon(Icons.check).doesNotExist();
    });

    testWidgets('does not show check icon when not isLatest', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildTimelineItem(
              title: 'Old event',
              subtitle: 'Yesterday',
              isLatest: false,
            ),
          ),
        ),
      );

      spotIcon(Icons.check).doesNotExist();
    });
  });
}
