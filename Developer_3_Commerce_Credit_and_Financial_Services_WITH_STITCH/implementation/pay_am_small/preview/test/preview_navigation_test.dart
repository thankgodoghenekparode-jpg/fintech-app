// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small_preview/main.dart';
import 'dart:ui' as ui;

void main() {
  testWidgets('Stitch preview assets are registered and decodable',
      (tester) async {
    final paths = [
      'assets/preview_only/marketplace-freezer.jpg',
      'assets/preview_only/marketplace-solar.jpg',
      'assets/preview_only/product-detail-freezer.jpg',
      'assets/preview_only/storefront-vendor-avatar.jpg',
      'assets/preview_only/storefront-freezer.jpg',
      'assets/preview_only/storefront-television.jpg',
      'assets/preview_only/storefront-cooker.jpg',
      'assets/preview_only/storefront-ac.jpg',
    ];
    await tester.runAsync(() async {
      for (final path in paths) {
        final data = await rootBundle.load(path);
        final codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        final frame = await codec.getNextFrame();
        expect(frame.image.width, greaterThan(0), reason: path);
        expect(frame.image.height, greaterThan(0), reason: path);
        frame.image.dispose();
        codec.dispose();
      }
      final interFont =
          await rootBundle.load('assets/fonts/Inter-Variable.ttf');
      expect(interFont.lengthInBytes, greaterThan(0));
    });
  });

  testWidgets(
      'all approved screens are registered, navigable, and theme switch works',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PayAmSmallPreviewApp());
    await tester.pumpAndSettle();
    expect(find.text('NON-PRODUCTION · Synthetic preview data · No payments'),
        findsOneWidget);
    expect(find.text('Pay Am Small'), findsOneWidget);
    for (final label in [
      'Home',
      'Payments',
      'Cards',
      'Save & Borrow',
      'More',
    ]) {
      expect(find.text(label), findsAtLeastNWidgets(1));
    }
    expect(
        find.byKey(const ValueKey('previewBottomNavigation')), findsOneWidget);
    expect(
      tester
          .widget<Semantics>(find.byKey(const ValueKey('previewTabSaveBorrow')))
          .properties
          .selected,
      isTrue,
    );
    final saveBorrowLabel = find.text('Save & Borrow');
    expect(tester.getSize(saveBorrowLabel).height, lessThan(14));
    tester.view.physicalSize = const Size(320, 720);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(saveBorrowLabel).height, lessThan(12));
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    final lightTheme = Theme.of(tester.element(find.text('Pay Am Small')));
    expect(lightTheme.colorScheme.primary, const Color(0xFF8E1B4A));
    expect(lightTheme.scaffoldBackgroundColor, const Color(0xFFFAF8F7));
    expect(lightTheme.textTheme.titleLarge?.fontFamily, 'Inter');
    final homeImages = tester
        .widgetList<Image>(find.byType(Image))
        .map((image) => image.image)
        .whereType<AssetImage>()
        .map((image) => image.assetName)
        .toSet();
    expect(
        homeImages,
        containsAll({
          'assets/preview_only/marketplace-freezer.jpg',
        }));

    final search = find.byType(TextField);
    await tester.enterText(search, 'solar');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Felicity 1kVA Complete Solar Inverter Kit'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
        find.text('Felicity 1kVA Complete Solar Inverter Kit'), findsOneWidget);
    expect(find.text('Haier Thermocool 200L Chest Freezer'), findsNothing);
    expect(
      tester
          .widgetList<Image>(find.byType(Image))
          .map((image) => image.image)
          .whereType<AssetImage>()
          .map((image) => image.assetName),
      contains('assets/preview_only/marketplace-solar.jpg'),
    );

    await tester.enterText(search, '');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Haier Thermocool 200L Chest Freezer'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Haier Thermocool 200L Chest Freezer'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Felicity 1kVA Complete Solar Inverter Kit'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
        find.text('Felicity 1kVA Complete Solar Inverter Kit'), findsOneWidget);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 1200));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Solar & Power'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Felicity 1kVA Complete Solar Inverter Kit'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
        find.text('Felicity 1kVA Complete Solar Inverter Kit'), findsOneWidget);
    expect(find.text('Haier Thermocool 200L Chest Freezer'), findsNothing);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 1200));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All').first);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Haier Thermocool 200L Chest Freezer'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Haier Thermocool 200L Chest Freezer'), findsOneWidget);
    await tester.ensureVisible(
      find.text('Haier Thermocool 200L Chest Freezer'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Haier Thermocool 200L Chest Freezer'));
    await tester.pumpAndSettle();
    expect(find.text('Product details'), findsOneWidget);
    expect(
      tester
          .widgetList<Image>(find.byType(Image))
          .map((image) => image.image)
          .whereType<AssetImage>()
          .map((image) => image.assetName),
      contains('assets/preview_only/product-detail-freezer.jpg'),
    );
    await tester.tap(find.text('MegaPlaza Electronics'));
    await tester.pumpAndSettle();
    expect(find.text('Vendor storefront'), findsOneWidget);
    expect(
      tester
          .widgetList<Image>(find.byType(Image))
          .map((image) => image.image)
          .whereType<AssetImage>()
          .map((image) => image.assetName),
      contains('assets/preview_only/storefront-vendor-avatar.jpg'),
    );
    await tester.tap(find.text('Haier Thermocool 200L Chest Freezer'));
    await tester.pumpAndSettle();
    expect(find.text('Product details'), findsOneWidget);

    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S-PAS-002 · Product detail'));
    await tester.pumpAndSettle();
    expect(find.text('Product details'), findsOneWidget);
    expect(find.text('NON-PRODUCTION · Synthetic preview data · No payments'),
        findsOneWidget);
    expect(find.textContaining('Credit'), findsNothing);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Configure Plan'), findsOneWidget);
    expect(find.text('NON-PRODUCTION · Synthetic preview data · No payments'),
        findsOneWidget);
    await tester.tap(find.text('Review Plan Summary & Terms'));
    await tester.pumpAndSettle();
    expect(find.text('Plan Summary & Terms'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byType(CheckboxListTile),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.tap(find.text('Accept & continue to PIN'));
    await tester.pumpAndSettle();
    expect(find.text('Preview acceptance complete'), findsOneWidget);
    expect(find.textContaining('did not create a real plan'), findsOneWidget);

    await tester.tap(find.byTooltip('Use dark mode'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Material>(find.byKey(const ValueKey('previewHeader')))
          .color,
      const Color(0xFF3A1F2A),
    );
    final darkTheme =
        Theme.of(tester.element(find.text('Plan Summary & Terms')));
    expect(darkTheme.brightness, Brightness.dark);
    expect(darkTheme.colorScheme.primary, const Color(0xFFE0709A));
    expect(darkTheme.scaffoldBackgroundColor, const Color(0xFF121011));
    expect(darkTheme.textTheme.titleLarge?.fontFamily, 'Inter');

    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S-PAS-003 · Plan setup'));
    await tester.pumpAndSettle();
    expect(find.text('Configure Plan'), findsOneWidget);
    final setupDarkTheme =
        Theme.of(tester.element(find.text('Configure Plan')));
    expect(setupDarkTheme.brightness, Brightness.dark);

    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S-PAS-004 · Plan summary & terms'));
    await tester.pumpAndSettle();
    expect(find.text('Plan Summary & Terms'), findsOneWidget);
    final reviewDarkTheme =
        Theme.of(tester.element(find.text('Plan Summary & Terms')));
    expect(reviewDarkTheme.brightness, Brightness.dark);

    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S-PAS-012 · Vendor storefront'));
    await tester.pumpAndSettle();
    expect(find.text('Vendor storefront'), findsOneWidget);
    expect(find.text('NON-PRODUCTION · Synthetic preview data · No payments'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
