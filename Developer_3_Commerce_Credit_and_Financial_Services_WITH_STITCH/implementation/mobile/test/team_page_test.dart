import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/sixth_merchant_tools.dart';

void main() {
  testWidgets('shows the injected directory and filters by role',
      (tester) async {
    await tester.pumpWidget(_harness(_TeamAdapter()));
    await tester.pumpAndSettle();

    expect(find.text('Amina Manager'), findsOneWidget);
    expect(find.text('Bola Cashier'), findsOneWidget);
    await tester.tap(find.text('Cashiers (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Bola Cashier'), findsOneWidget);
    expect(find.text('Amina Manager'), findsNothing);
  });

  testWidgets('shows loading and recoverable error states', (tester) async {
    final pending = Completer<MerchantTeamDirectory?>();
    await tester.pumpWidget(_harness(_TeamAdapter(load: () => pending.future)));
    expect(find.bySemanticsLabel('Loading team'), findsOneWidget);
    pending.completeError(const MerchantTeamOfflineException());
    await tester.pumpAndSettle();

    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('valid invite submits the documented phone and role values', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final adapter = _TeamAdapter();
    await tester.pumpWidget(_harness(adapter));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Invite member').last);
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const ValueKey('team-invite-phone')), '+2348000000000');
    await tester.tap(find.byKey(const ValueKey('team-invite-role')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accountant').last);
    final submit = tester.widget<FilledButton>(
      find.byKey(const ValueKey('team-send-invite')),
    );
    submit.onPressed!();
    await tester.pumpAndSettle();

    expect(adapter.invites, hasLength(1));
    expect(adapter.invites.single.phone, '+2348000000000');
    expect(adapter.invites.single.role, MerchantTeamRole.accountant);
    expect(find.text('Invite submitted'), findsOneWidget);
  });
}

Widget _harness(_TeamAdapter adapter) => ProviderScope(
      overrides: [merchantTeamAdapterProvider.overrideWithValue(adapter)],
      child: const MaterialApp(
        home: TeamPage(
          tenantId: 'test-tenant',
          copy: _TeamCopy(),
          tokens: MerchantHomeTokens(
            pageGutter: 16,
            sectionGap: 24,
            cardPadding: 16,
            elementGap: 12,
            smallGap: 8,
            cardRadius: 16,
            controlRadius: 12,
          ),
        ),
      ),
    );

class _TeamAdapter implements MerchantTeamAdapter {
  _TeamAdapter({Future<MerchantTeamDirectory?> Function()? load})
      : _load = load;

  final Future<MerchantTeamDirectory?> Function()? _load;
  final invites = <InviteTeamMemberRequest>[];

  @override
  Future<MerchantTeamDirectory?> loadTeam({required String tenantId}) =>
      _load?.call() ??
      Future.value(
        const MerchantTeamDirectory(
          members: [
            MerchantTeamMember(
              displayName: 'Amina Manager',
              role: MerchantTeamRole.manager,
            ),
            MerchantTeamMember(
              displayName: 'Bola Cashier',
              role: MerchantTeamRole.cashier,
            ),
          ],
          mayInvite: true,
        ),
      );

  @override
  Future<void> inviteMember({
    required String tenantId,
    required InviteTeamMemberRequest request,
  }) async {
    invites.add(request);
  }
}

class _TeamCopy implements TeamCopy {
  const _TeamCopy();

  @override
  String get title => 'Team';
  @override
  String get subtitle => 'Sample business';
  @override
  String get back => 'Back';
  @override
  String get invite => 'Invite member';
  @override
  String get members => 'Members';
  @override
  String get allRoles => 'All';
  @override
  String get managers => 'Managers';
  @override
  String get cashiers => 'Cashiers';
  @override
  String get accountants => 'Accountants';
  @override
  String get manager => 'Manager';
  @override
  String get cashier => 'Cashier';
  @override
  String get accountant => 'Accountant';
  @override
  String get emptyTitle => 'Empty team';
  @override
  String get emptyBody => 'Invite someone';
  @override
  String get noRoleMembers => 'No role members';
  @override
  String get noRoleMembersBody => 'Choose another role';
  @override
  String get loading => 'Loading team';
  @override
  String get loadingError => 'Could not load team';
  @override
  String get offline => 'Offline';
  @override
  String get retry => 'Retry';
  @override
  String get restricted => 'Invites unavailable';
  @override
  String get inviteTitle => 'Invite member';
  @override
  String get phone => 'Phone number';
  @override
  String get role => 'Role';
  @override
  String get selectRole => 'Select role';
  @override
  String get cancel => 'Cancel';
  @override
  String get sendInvite => 'Send invite';
  @override
  String get phoneRequired => 'Phone required';
  @override
  String get roleRequired => 'Role required';
  @override
  String get inviteFailed => 'Invite failed';
  @override
  String get inviteOffline => 'Invite offline';
  @override
  String get inviteSent => 'Invite submitted';
}
