import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/features/home/presentation/legal_consent_screen.dart';

void main() {
  testWidgets('legal screen opens supplied draft and labels missing documents',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LegalConsentScreen()),
    );

    expect(find.text('Terms and Conditions'), findsOneWidget);
    expect(find.text('Privacy Notice'), findsOneWidget);
    expect(find.text('Fee schedule'), findsOneWidget);
    expect(find.text('Data use'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Preferences are not saved'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Preferences are not saved'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Terms and Conditions'),
      -400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Terms and Conditions'));
    await tester.pumpAndSettle();
    expect(find.textContaining('DRAFT PREVIEW ONLY'), findsOneWidget);
    expect(find.textContaining('not approved for customer acceptance'),
        findsOneWidget);
  });
}
