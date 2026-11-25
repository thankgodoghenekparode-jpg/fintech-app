import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/features/system/presentation/maintenance_screen.dart';

void main() {
  testWidgets('maintenance preview avoids invented outage time or status URL',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MaintenanceScreen(previewOnly: true),
    ));

    expect(find.text('Screen preview only'), findsOneWidget);
    expect(find.text('This is not a report of a live service outage.'),
        findsOneWidget);
    expect(find.text('Expected return time'), findsOneWidget);
    expect(find.text('Not provided'), findsOneWidget);
    expect(find.text('A live status page is not configured for this app.'),
        findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Check again'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Check again'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Close preview'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Close preview'), findsOneWidget);
  });
}
