import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/features/system/data/device_connectivity_provider.dart';
import 'package:yourapp_mobile/features/system/presentation/offline_screen.dart';

void main() {
  testWidgets('no-network guard hides banking actions and financial details',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        deviceNetworkAvailableProvider.overrideWith(
          (ref) => Stream<bool>.value(false),
        ),
      ],
      child: const MaterialApp(
        home: DeviceOfflineGuard(child: Text('Transfer money')),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('No network connection'), findsOneWidget);
    expect(find.text('Money actions are unavailable'), findsOneWidget);
    expect(find.text('Transfer money'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Retry connection'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Retry connection'), findsOneWidget);
  });

  testWidgets('offline preview says it is a preview and can close',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: OfflineScreen(previewOnly: true),
    ));

    expect(find.text('Offline preview'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Close preview'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Close preview'), findsOneWidget);
  });
}
