import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/src/business_creation/business_creation.dart';
import 'package:sixth_merchant_tools/src/business_home/business_home_tokens.dart';

void main() {
  group('S-MER-002 Create business', () {
    testWidgets(
      'validates required details and documented business-name length',
      (tester) async {
        await tester.pumpWidget(_harness(_FakeCreationAdapter()));
        await tester.tap(find.text(copy.next));
        await tester.pumpAndSettle();
        expect(find.text(copy.nameRequired), findsOneWidget);

        await tester.enterText(find.byKey(const Key('legal-name')), 'AB');
        await tester.enterText(
          find.byKey(const Key('business-type')),
          'Company',
        );
        await tester.tap(find.text(copy.next));
        await tester.pumpAndSettle();
        expect(find.text(copy.nameLength), findsOneWidget);
      },
    );

    testWidgets(
      'requires an injected owner document selector before continuing',
      (tester) async {
        await tester.pumpWidget(_harness(_FakeCreationAdapter()));
        await _fillDetails(tester);
        await tester.tap(find.text(copy.next));
        await tester.pumpAndSettle();
        expect(find.text(copy.documentsStep), findsOneWidget);
        await tester.tap(find.text(copy.next));
        await tester.pumpAndSettle();
        expect(find.text(copy.documentRequired), findsOneWidget);
      },
    );

    testWidgets('submits only documented fields and shows pending state', (
      tester,
    ) async {
      final adapter = _FakeCreationAdapter();
      await tester.pumpWidget(
        _harness(adapter, selectDocument: () async => 'opaque-file-key'),
      );
      await _fillDetails(tester);
      await tester.tap(find.text(copy.next));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.selectDocument));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.next));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.next));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.submit));
      await tester.pumpAndSettle();

      expect(adapter.request?.legalName, 'Test Grocer');
      expect(adapter.request?.type, 'Company');
      expect(adapter.request?.ownerIdFileKey, 'opaque-file-key');
      expect(adapter.request?.registrationNumber, isNull);
      expect(adapter.request?.settlementAccount, isNull);
      expect(find.text(copy.pendingTitle), findsOneWidget);
    });

    testWidgets('shows a recoverable submission error', (tester) async {
      final adapter = _FakeCreationAdapter(fail: true);
      await tester.pumpWidget(
        _harness(adapter, selectDocument: () async => 'file-key'),
      );
      await _fillDetails(tester);
      await tester.tap(find.text(copy.next));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.selectDocument));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.next));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.next));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.submit));
      await tester.pumpAndSettle();
      expect(find.text(copy.submitError), findsOneWidget);
      expect(find.text(copy.submit), findsOneWidget);
    });
  });
}

Future<void> _fillDetails(WidgetTester tester) async {
  await tester.enterText(find.byKey(const Key('legal-name')), 'Test Grocer');
  await tester.enterText(find.byKey(const Key('business-type')), 'Company');
}

Widget _harness(
  BusinessCreationAdapter adapter, {
  OwnerIdDocumentSelector? selectDocument,
}) => ProviderScope(
  overrides: [businessCreationAdapterProvider.overrideWithValue(adapter)],
  child: MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8E1B4A)),
    ),
    home: BusinessCreationPage(
      copy: copy,
      tokens: const MerchantHomeTokens(
        pageGutter: 16,
        sectionGap: 24,
        cardPadding: 16,
        elementGap: 12,
        smallGap: 8,
        cardRadius: 16,
        controlRadius: 12,
      ),
      selectOwnerIdDocument: selectDocument,
    ),
  ),
);

class _FakeCreationAdapter implements BusinessCreationAdapter {
  _FakeCreationAdapter({this.fail = false});
  final bool fail;
  BusinessCreationRequest? request;

  @override
  Future<void> createBusiness(BusinessCreationRequest request) async {
    this.request = request;
    if (fail) throw Exception('test-only failure');
  }
}

const copy = _TestCopy();

class _TestCopy implements BusinessCreationCopy {
  const _TestCopy();
  @override
  String get title => 'Create business';
  @override
  String get subtitle => 'Set up your business account.';
  @override
  String get back => 'Go back';
  @override
  String get help => 'Help';
  @override
  String get next => 'Continue';
  @override
  String get backStep => 'Back';
  @override
  String get submit => 'Submit for verification';
  @override
  String get submitting => 'Submitting';
  @override
  String get detailsStep => 'Details';
  @override
  String get documentsStep => 'Documents';
  @override
  String get settlementStep => 'Settlement';
  @override
  String get reviewStep => 'Review';
  @override
  String get legalName => 'Business legal name';
  @override
  String get businessType => 'Business type';
  @override
  String get registrationNumber => 'Registration number';
  @override
  String get optional => 'Optional';
  @override
  String get ownerId => 'Owner identity document';
  @override
  String get selectDocument => 'Select document';
  @override
  String get documentNotConfigured => 'Document selection is not available.';
  @override
  String get settlementAccount => 'Settlement account';
  @override
  String get accountEntered => 'Account entered';
  @override
  String get settlementOptionalHelp => 'Optional';
  @override
  String get reviewHeading => 'Review your details';
  @override
  String get pendingTitle => 'Submitted for verification';
  @override
  String get pendingBody =>
      'Your business account is restricted while verification is in progress.';
  @override
  String get nameRequired => 'Enter a business name.';
  @override
  String get nameLength => 'Business name must be 3 to 80 characters.';
  @override
  String get requiredField => 'This field is required.';
  @override
  String get documentRequired =>
      'Select an owner identity document to continue.';
  @override
  String get submitError =>
      'We could not submit your business details. Try again.';
  @override
  String get retry => 'Try again';
}
