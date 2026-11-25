import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/app.dart';
import 'package:yourapp_mobile/features/system/presentation/session_locked_screen.dart';

void main() {
  testWidgets('session lock preview follows Stitch and never signs in',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
      home: SessionLockedScreen(previewOnly: true),
    ));

    expect(find.text('Session timed out'), findsOneWidget);
    expect(
        find.text(
            'Your session was locked for your security. Sign in to continue.'),
        findsOneWidget);
    expect(find.text('Phone number or email'), findsOneWidget);
    expect(find.text('Unlock with biometrics'), findsOneWidget);
    expect(find.text('ENTER 6-DIGIT PASSCODE'), findsOneWidget);
    await tester.tap(find.text('Unlock with biometrics'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(
        find.textContaining('Preview only. Sign-in requires'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Forgot passcode?'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Switch account / Log out'), findsOneWidget);
  });

  testWidgets('authenticated session locks after configured inactivity',
      (tester) async {
    var locked = false;
    await tester.pumpWidget(MaterialApp(
      home: SessionLockGate(
        inactivityTimeout: const Duration(milliseconds: 100),
        readAccessToken: () async => 'test-session-token',
        onLock: () => locked = true,
        child: const SizedBox(),
      ),
    ));

    await tester.pump(const Duration(milliseconds: 101));
    await tester.pump();

    expect(locked, isTrue);
  });

  testWidgets('authenticated session locks when app returns from background',
      (tester) async {
    var locked = false;
    await tester.pumpWidget(MaterialApp(
      home: SessionLockGate(
        readAccessToken: () async => 'test-session-token',
        onLock: () => locked = true,
        child: const SizedBox(),
      ),
    ));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(locked, isTrue);
  });
}
