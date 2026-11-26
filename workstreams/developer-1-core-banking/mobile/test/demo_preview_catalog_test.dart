import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/features/onboarding/presentation/demo_preview_catalog_screen.dart';

void main() {
  testWidgets('demo catalog lists previews and backend-dependent modules', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: DemoPreviewCatalogScreen()),
    );

    expect(find.text('Implemented screen previews'), findsOneWidget);
    expect(find.text('Home and cards'), findsOneWidget);
    expect(find.text('Payments hub'), findsOneWidget);
    expect(find.text('Personal profile'), findsOneWidget);
  });
}
