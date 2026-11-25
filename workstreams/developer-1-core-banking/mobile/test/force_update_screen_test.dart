import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/features/system/presentation/force_update_screen.dart';

void main() {
  test('version policy rejects non-store and non-HTTPS update links', () {
    expect(
      () => UpdatePolicy.fromJson(
          _policyJson(storeUrl: 'http://play.google.com/app')),
      throwsFormatException,
    );
    expect(
      () => UpdatePolicy.fromJson(
          _policyJson(storeUrl: 'https://example.test/app')),
      throwsFormatException,
    );
  });

  testWidgets('force update preview keeps store action disabled without policy',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
      home: ForceUpdateScreen(previewOnly: true),
    ));

    expect(find.text('Screen preview only'), findsOneWidget);
    expect(find.text('Official app-store link not configured'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Update link unavailable'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Update link unavailable'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('required update opens only the approved store URL',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Uri? opened;
    final policy = UpdatePolicy.fromJson(_policyJson());
    await tester.pumpWidget(MaterialApp(
      home: ForceUpdateScreen(
        policy: policy,
        openStore: (uri) async {
          opened = uri;
          return true;
        },
      ),
    ));

    await tester.scrollUntilVisible(
      find.text('Update app'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Update app'));
    await tester.pumpAndSettle();

    expect(opened?.host, 'play.google.com');
    expect(opened?.queryParameters['id'], 'com.example.app');
  });
}

Map<String, dynamic> _policyJson({
  String storeUrl =
      'https://play.google.com/store/apps/details?id=com.example.app',
}) =>
    {
      'required': true,
      'minimumSupportedVersion': '1.1.0',
      'latestVersion': '1.2.0',
      'storeUrl': storeUrl,
      'releaseNotesUrl': 'https://example.test/releases/1.2.0',
      'message': 'Update the app to continue.',
    };
