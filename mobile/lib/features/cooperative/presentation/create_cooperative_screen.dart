import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_text.dart';
import '../data/cooperative_repository.dart';

class CreateCooperativeScreen extends ConsumerStatefulWidget {
  const CreateCooperativeScreen({super.key});

  @override
  ConsumerState<CreateCooperativeScreen> createState() =>
      _CreateCooperativeScreenState();
}

class _CreateCooperativeScreenState
    extends ConsumerState<CreateCooperativeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scheduleController = TextEditingController();
  final _adminControllers = [TextEditingController()];
  int _step = 0;
  String _type = 'INFORMAL';
  bool _submitting = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _scheduleController.dispose();
    for (final controller in _adminControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _next() {
    if (_step == 0 && !(_formKey.currentState?.validate() ?? false)) return;
    if (_step == 2 &&
        !_adminControllers
            .any((controller) => controller.text.trim().isNotEmpty)) {
      setState(() => _error = AppText.adminsRequired);
      return;
    }
    if (_step < 3) {
      setState(() {
        _error = null;
        _step++;
      });
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    if (_type == 'REGISTERED' || _type == 'INFORMAL') {
      setState(() => _error = _type == 'REGISTERED'
          ? AppText.registeredUnavailable
          : AppText.informalUnavailable);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(cooperativeRepositoryProvider).create(
            name: _nameController.text.trim(),
            type: _type,
            description: _descriptionController.text.trim(),
            meetingSchedule: _scheduleController.text.trim(),
            adminPhones: _adminControllers
                .map((controller) => controller.text.trim())
                .where((phone) => phone.isNotEmpty)
                .toList(growable: false),
          );
      if (mounted) setState(() => _submitted = true);
    } on CooperativeRequestFailure catch (failure) {
      if (mounted) {
        setState(() {
          _error = switch (failure.code) {
            'authentication_required' => AppText.authMissing,
            'service_unavailable' => AppText.apiUnconfigured,
            _ => AppText.createError,
          };
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = AppText.createError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _success(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.createCooperative),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: AppText.back,
          onPressed: () => context.go('/coop'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: Stepper(
                currentStep: _step,
                onStepContinue: _submitting ? null : _next,
                onStepCancel: _step == 0
                    ? null
                    : () => setState(() {
                          _error = null;
                          _step--;
                        }),
                controlsBuilder: (context, details) => Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_error != null) ...[
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          FilledButton(
                            onPressed: details.onStepContinue,
                            child: Text(
                              _submitting
                                  ? AppText.submitting
                                  : _step == 3
                                      ? AppText.submit
                                      : AppText.continueLabel,
                            ),
                          ),
                          if (_step > 0) ...[
                            const SizedBox(width: 12),
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text(AppText.back),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                steps: [
                  Step(
                    title: const Text(AppText.cooperativeDetails),
                    isActive: _step >= 0,
                    content: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          decoration: const InputDecoration(
                            labelText: AppText.name,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final length = value?.trim().length ?? 0;
                            return length >= 3 && length <= 60
                                ? null
                                : AppText.nameRequired;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: AppText.descriptionLabel,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _scheduleController,
                          decoration: const InputDecoration(
                            labelText: AppText.meetingSchedule,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text(AppText.cooperativeType),
                    isActive: _step >= 1,
                    content: RadioGroup<String>(
                      groupValue: _type,
                      onChanged: (value) => setState(
                        () => _type = value ?? 'INFORMAL',
                      ),
                      child: Column(
                        children: [
                          const RadioListTile<String>(
                            value: 'INFORMAL',
                            title: Text(AppText.typeInformal),
                          ),
                          const RadioListTile<String>(
                            value: 'REGISTERED',
                            title: Text(AppText.typeRegistered),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _type == 'REGISTERED'
                                ? '${AppText.registeredInfo} ${AppText.registeredUnavailable}'
                                : '${AppText.informalInfo} ${AppText.informalUnavailable}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title: const Text(AppText.principalAdmins),
                    isActive: _step >= 2,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(AppText.adminsInfo),
                        const SizedBox(height: 12),
                        for (var index = 0;
                            index < _adminControllers.length;
                            index++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TextFormField(
                              controller: _adminControllers[index],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: AppText.adminPhone,
                                border: const OutlineInputBorder(),
                                suffixIcon: index > 0
                                    ? IconButton(
                                        tooltip: AppText.removeAdmin,
                                        icon: const Icon(Icons.close),
                                        onPressed: () => setState(
                                          () => _adminControllers
                                              .removeAt(index)
                                              .dispose(),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        if (_adminControllers.length < 2)
                          TextButton.icon(
                            onPressed: () => setState(
                              () => _adminControllers
                                  .add(TextEditingController()),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text(AppText.addAdmin),
                          ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text(AppText.review),
                    isActive: _step >= 3,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ReviewRow(
                            label: AppText.name, value: _nameController.text),
                        _ReviewRow(
                          label: AppText.cooperativeType,
                          value: _type == 'REGISTERED'
                              ? AppText.typeRegistered
                              : AppText.typeInformal,
                        ),
                        _ReviewRow(
                          label: AppText.descriptionLabel,
                          value: _descriptionController.text,
                        ),
                        _ReviewRow(
                          label: AppText.principalAdmins,
                          value: (1 +
                                  _adminControllers
                                      .where((c) => c.text.trim().isNotEmpty)
                                      .length)
                              .toString(),
                        ),
                        const SizedBox(height: 12),
                        const Text(AppText.verificationReviewInfo),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _success(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.createCooperative)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 56),
              const SizedBox(height: 16),
              Text(AppText.created,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(AppText.createdInfo, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/coop'),
                child: const Text(AppText.done),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 16),
            Expanded(child: Text(value.isEmpty ? '—' : value)),
          ],
        ),
      );
}
