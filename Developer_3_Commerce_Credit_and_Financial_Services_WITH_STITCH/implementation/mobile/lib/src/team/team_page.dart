import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';

/// UI roles that match the documented POST /business/team allowed values.
enum MerchantTeamRole { manager, cashier, accountant }

extension MerchantTeamRoleLabel on MerchantTeamRole {
  String label(TeamCopy copy) => switch (this) {
        MerchantTeamRole.manager => copy.manager,
        MerchantTeamRole.cashier => copy.cashier,
        MerchantTeamRole.accountant => copy.accountant,
      };

  String get requestValue => switch (this) {
        MerchantTeamRole.manager => 'MANAGER',
        MerchantTeamRole.cashier => 'CASHIER',
        MerchantTeamRole.accountant => 'ACCOUNTANT',
      };
}

/// UI presentation data supplied by the host; this is not an API response DTO.
class MerchantTeamMember {
  const MerchantTeamMember({required this.displayName, required this.role});

  final String displayName;
  final MerchantTeamRole role;
}

/// UI-facing directory data. The documented API has no team-list endpoint.
class MerchantTeamDirectory {
  const MerchantTeamDirectory({
    this.members = const [],
    required this.mayInvite,
    this.inviteBlockedReason,
  });

  final List<MerchantTeamMember> members;
  final bool mayInvite;
  final String? inviteBlockedReason;
}

/// Frontend command for the documented phone/role POST request.
class InviteTeamMemberRequest {
  const InviteTeamMemberRequest({required this.phone, required this.role});

  final String phone;
  final MerchantTeamRole role;
}

/// Host boundary for directory mapping and the documented add-member action.
abstract interface class MerchantTeamAdapter {
  Future<MerchantTeamDirectory?> loadTeam({required String tenantId});

  Future<void> inviteMember({
    required String tenantId,
    required InviteTeamMemberRequest request,
  });
}

final merchantTeamAdapterProvider = Provider<MerchantTeamAdapter>(
  (ref) =>
      throw StateError('MerchantTeamAdapter must be supplied by the host.'),
);

final merchantTeamDirectoryProvider = FutureProvider.autoDispose
    .family<MerchantTeamDirectory?, String>((ref, tenantId) {
  return ref.watch(merchantTeamAdapterProvider).loadTeam(tenantId: tenantId);
});

class MerchantTeamOfflineException implements Exception {
  const MerchantTeamOfflineException();
}

abstract interface class TeamCopy {
  String get title;
  String get subtitle;
  String get back;
  String get invite;
  String get members;
  String get allRoles;
  String get managers;
  String get cashiers;
  String get accountants;
  String get manager;
  String get cashier;
  String get accountant;
  String get emptyTitle;
  String get emptyBody;
  String get noRoleMembers;
  String get noRoleMembersBody;
  String get loading;
  String get loadingError;
  String get offline;
  String get retry;
  String get restricted;
  String get inviteTitle;
  String get phone;
  String get role;
  String get selectRole;
  String get cancel;
  String get sendInvite;
  String get phoneRequired;
  String get roleRequired;
  String get inviteFailed;
  String get inviteOffline;
  String get inviteSent;
}

/// S-MER-010 Team. The host supplies directory data and permission state;
/// network, auth, route registration, and API response mapping stay in the host.
class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({
    required this.tenantId,
    required this.copy,
    required this.tokens,
    this.onBack,
    super.key,
  });

  final String tenantId;
  final TeamCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback? onBack;

  @override
  ConsumerState<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  MerchantTeamRole? _roleFilter;

  TeamCopy get copy => widget.copy;
  MerchantHomeTokens get tokens => widget.tokens;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(merchantTeamDirectoryProvider(widget.tenantId));
    final directory = state.asData?.value;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(context, canInvite: directory?.mayInvite ?? false),
            Expanded(
              child: state.when(
                loading: () => _loading(context),
                error: (error, _) => _error(
                  context,
                  offline: error is MerchantTeamOfflineException,
                ),
                data: (team) => team == null
                    ? _error(context, offline: false)
                    : _teamContent(context, team),
              ),
            ),
            if (directory != null) _inviteAction(context, directory),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, {required bool canInvite}) => Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.pageGutter,
          tokens.smallGap,
          tokens.pageGutter,
          tokens.smallGap,
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: copy.back,
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(copy.subtitle,
                      style: Theme.of(context).textTheme.labelSmall),
                  Text(copy.title,
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            IconButton(
              tooltip: copy.invite,
              onPressed: canInvite ? _openInvite : null,
              icon: const Icon(Icons.person_add_alt_1_outlined),
            ),
          ],
        ),
      );

  Widget _teamContent(BuildContext context, MerchantTeamDirectory directory) {
    final visibleMembers = directory.members
        .where((member) => _roleFilter == null || member.role == _roleFilter)
        .toList(growable: false);
    return CustomScrollView(
      key: const ValueKey('merchant-team-content'),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            tokens.pageGutter,
            tokens.smallGap,
            tokens.pageGutter,
            0,
          ),
          sliver: SliverToBoxAdapter(child: _overview(context, directory)),
        ),
        SliverToBoxAdapter(child: _roleFilters(context, directory)),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            tokens.pageGutter,
            tokens.sectionGap,
            tokens.pageGutter,
            tokens.sectionGap,
          ),
          sliver: SliverList.list(
            children: [
              Text(copy.members, style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: tokens.elementGap),
              if (visibleMembers.isEmpty)
                _emptyState(context, hasMembers: directory.members.isEmpty)
              else
                for (final member in visibleMembers) ...[
                  _memberCard(context, member),
                  SizedBox(height: tokens.elementGap),
                ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _overview(BuildContext context, MerchantTeamDirectory directory) {
    final colors = Theme.of(context).colorScheme;
    final roleCounts = MerchantTeamRole.values
        .map(
          (role) => (
            role,
            directory.members.where((member) => member.role == role).length,
          ),
        )
        .toList(growable: false);
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(tokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storefront_outlined, color: colors.primary),
                SizedBox(width: tokens.smallGap),
                Expanded(
                  child: Text(
                    copy.subtitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: tokens.elementGap),
            Row(
              children: [
                for (var index = 0; index < roleCounts.length; index++) ...[
                  if (index > 0) SizedBox(width: tokens.smallGap),
                  Expanded(
                    child: _roleCount(
                      context,
                      roleCounts[index].$1.label(copy),
                      roleCounts[index].$2,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCount(BuildContext context, String role, int count) =>
      DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(tokens.controlRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.smallGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style: Theme.of(context).textTheme.labelSmall),
              Text('$count', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      );

  Widget _roleFilters(BuildContext context, MerchantTeamDirectory directory) =>
      SizedBox(
        height: 52,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: tokens.pageGutter),
          children: [
            _filterChip(context, null, copy.allRoles, directory),
            for (final role in MerchantTeamRole.values)
              _filterChip(context, role, _pluralRole(role), directory),
          ],
        ),
      );

  String _pluralRole(MerchantTeamRole role) => switch (role) {
        MerchantTeamRole.manager => copy.managers,
        MerchantTeamRole.cashier => copy.cashiers,
        MerchantTeamRole.accountant => copy.accountants,
      };

  Widget _filterChip(
    BuildContext context,
    MerchantTeamRole? role,
    String label,
    MerchantTeamDirectory directory,
  ) {
    final count = role == null
        ? directory.members.length
        : directory.members.where((member) => member.role == role).length;
    return Padding(
      padding: EdgeInsets.only(right: tokens.smallGap),
      child: ChoiceChip(
        label: Text('$label ($count)'),
        selected: _roleFilter == role,
        onSelected: (_) => setState(() => _roleFilter = role),
      ),
    );
  }

  Widget _memberCard(BuildContext context, MerchantTeamMember member) {
    final colors = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(tokens.cardPadding),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              child: Text(_initials(member.displayName)),
            ),
            SizedBox(width: tokens.elementGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: tokens.smallGap / 2),
                  Text(
                    member.role.label(copy),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, {required bool hasMembers}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: tokens.sectionGap),
        child: Column(
          children: [
            Icon(
              Icons.groups_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: tokens.smallGap),
            Text(
              hasMembers ? copy.noRoleMembers : copy.emptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: tokens.smallGap),
            Text(
              hasMembers ? copy.noRoleMembersBody : copy.emptyBody,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _inviteAction(BuildContext context, MerchantTeamDirectory directory) =>
      SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            tokens.pageGutter,
            tokens.smallGap,
            tokens.pageGutter,
            tokens.smallGap,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: directory.mayInvite ? _openInvite : null,
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: Text(copy.invite),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tokens.controlRadius),
                  ),
                ),
              ),
              if (!directory.mayInvite)
                Padding(
                  padding: EdgeInsets.only(top: tokens.smallGap),
                  child: Text(
                    directory.inviteBlockedReason ?? copy.restricted,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      );

  Future<void> _openInvite() async {
    final invited = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _InviteTeamMemberSheet(
        copy: copy,
        tokens: tokens,
        onInvite: (request) => ref
            .read(merchantTeamAdapterProvider)
            .inviteMember(tenantId: widget.tenantId, request: request),
      ),
    );
    if (!mounted || invited != true) return;
    ref.invalidate(merchantTeamDirectoryProvider(widget.tenantId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(copy.inviteSent)),
    );
  }

  Widget _loading(BuildContext context) => Center(
        child: Semantics(
          label: copy.loading,
          liveRegion: true,
          child: const CircularProgressIndicator(),
        ),
      );

  Widget _error(BuildContext context, {required bool offline}) => Center(
        child: Padding(
          padding: EdgeInsets.all(tokens.pageGutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                offline ? Icons.wifi_off_outlined : Icons.error_outline,
                color: offline
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: tokens.elementGap),
              Text(offline ? copy.offline : copy.loadingError),
              SizedBox(height: tokens.elementGap),
              OutlinedButton(
                onPressed: () => ref.invalidate(
                  merchantTeamDirectoryProvider(widget.tenantId),
                ),
                child: Text(copy.retry),
              ),
            ],
          ),
        ),
      );
}

class _InviteTeamMemberSheet extends StatefulWidget {
  const _InviteTeamMemberSheet({
    required this.copy,
    required this.tokens,
    required this.onInvite,
  });

  final TeamCopy copy;
  final MerchantHomeTokens tokens;
  final Future<void> Function(InviteTeamMemberRequest request) onInvite;

  @override
  State<_InviteTeamMemberSheet> createState() => _InviteTeamMemberSheetState();
}

class _InviteTeamMemberSheetState extends State<_InviteTeamMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  MerchantTeamRole? _role;
  String? _error;
  bool _sending = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          widget.tokens.pageGutter,
          widget.tokens.cardPadding,
          widget.tokens.pageGutter,
          MediaQuery.viewInsetsOf(context).bottom + widget.tokens.cardPadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.copy.inviteTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: widget.tokens.elementGap),
              TextFormField(
                key: const ValueKey('team-invite-phone'),
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: widget.copy.phone),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? widget.copy.phoneRequired
                    : null,
              ),
              SizedBox(height: widget.tokens.elementGap),
              DropdownButtonFormField<MerchantTeamRole>(
                key: const ValueKey('team-invite-role'),
                initialValue: _role,
                decoration: InputDecoration(labelText: widget.copy.role),
                hint: Text(widget.copy.selectRole),
                items: MerchantTeamRole.values
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.label(widget.copy)),
                      ),
                    )
                    .toList(growable: false),
                onChanged:
                    _sending ? null : (role) => setState(() => _role = role),
              ),
              if (_error != null) ...[
                SizedBox(height: widget.tokens.elementGap),
                Semantics(liveRegion: true, child: Text(_error!)),
              ],
              SizedBox(height: widget.tokens.sectionGap),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _sending ? null : () => Navigator.pop(context),
                      child: Text(widget.copy.cancel),
                    ),
                  ),
                  SizedBox(width: widget.tokens.smallGap),
                  Expanded(
                    child: FilledButton(
                      key: const ValueKey('team-send-invite'),
                      onPressed: _sending ? null : _submit,
                      child: _sending
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.copy.sendInvite),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final role = _role;
    if (role == null) {
      setState(() => _error = widget.copy.roleRequired);
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await widget.onInvite(
        InviteTeamMemberRequest(phone: _phone.text.trim(), role: role),
      );
      if (mounted) Navigator.pop(context, true);
    } on MerchantTeamOfflineException {
      if (mounted) setState(() => _error = widget.copy.inviteOffline);
    } catch (_) {
      if (mounted) setState(() => _error = widget.copy.inviteFailed);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2);
  return parts
      .map((part) => String.fromCharCode(part.runes.first).toUpperCase())
      .join();
}
