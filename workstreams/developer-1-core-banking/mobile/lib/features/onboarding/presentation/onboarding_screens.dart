import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/security/biometric_service.dart';
import '../../system/presentation/account_locked_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../data/onboarding_repository.dart';

const draftLegalPreviewEnabled = bool.fromEnvironment(
  'ENABLE_DRAFT_LEGAL_PREVIEW',
  defaultValue: false,
);

const cardUiPreviewEnabled = bool.fromEnvironment(
  'ENABLE_CARD_UI_PREVIEW',
  defaultValue: false,
);
const demoLoginEnabled = bool.fromEnvironment(
  'ENABLE_DEMO_LOGIN',
  defaultValue: false,
);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final pages = [
      (
        text.welcomeSlideSafeTitle,
        text.welcomeSlideSafeBody,
        Icons.shield_outlined,
      ),
      (
        text.welcomeSlideSimpleTitle,
        text.welcomeSlideSimpleBody,
        Icons.bolt_outlined,
      ),
      (
        text.welcomeSlideYoursTitle,
        text.welcomeSlideYoursBody,
        Icons.favorite_border,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const _Wordmark(),
              const Spacer(),
              SizedBox(
                height: 330,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) => setState(() => _page = index),
                  itemBuilder: (context, index) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 148,
                        height: 148,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(42),
                        ),
                        child: Icon(
                          pages[index].$3,
                          size: 68,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        pages[index].$1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pages[index].$2,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == _page ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == _page
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () => context.push('/signup/phone'),
                  child: Text(text.welcomeCreateAccount),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.push('/login'),
                  child: Text(text.welcomeLogin),
                ),
              ),
              if (draftLegalPreviewEnabled) ...[
                const SizedBox(height: 4),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => context.push('/signup/consent'),
                      child: Text(text.welcomePreviewLegal),
                    ),
                    TextButton(
                      onPressed: () => context.push('/signup/selfie'),
                      child: Text(text.welcomePreviewSelfie),
                    ),
                    TextButton(
                      onPressed: () => context.push('/signup/biometrics'),
                      child: Text(text.welcomePreviewBiometrics),
                    ),
                  ],
                ),
              ],
              if (cardUiPreviewEnabled)
                TextButton(
                  onPressed: () => context.push('/preview/cards'),
                  child: Text(text.welcomePreviewCards),
                ),
              if (demoLoginEnabled)
                TextButton.icon(
                  onPressed: () => context.push('/demo'),
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Demo login'),
                ),
              const SizedBox(height: 16),
              Text(
                text.welcomeLegalFooter,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberScreen extends ConsumerStatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  ConsumerState<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  final _controller = TextEditingController();
  String? _errorKey;
  bool _loading = false;

  bool get _phoneIsValid {
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
    final national = digits.startsWith('234')
        ? digits.substring(3)
        : digits.startsWith('0')
            ? digits.substring(1)
            : digits;
    return national.length == 10;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _normalisedPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final national = digits.startsWith('234')
        ? digits.substring(3)
        : digits.startsWith('0')
            ? digits.substring(1)
            : digits;
    return '+234$national';
  }

  Future<void> _continue() async {
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
    final national = digits.startsWith('234')
        ? digits.substring(3)
        : digits.startsWith('0')
            ? digits.substring(1)
            : digits;
    if (national.length != 10) {
      setState(() => _errorKey = 'validation.phone.invalid');
      return;
    }
    final phone = _normalisedPhone(_controller.text);
    setState(() {
      _errorKey = null;
      _loading = true;
    });
    try {
      await ref.read(onboardingRepositoryProvider).requestSignupOtp(phone);
      ref.read(signupPhoneProvider.notifier).state = phone;
      if (mounted) context.push('/signup/otp');
    } catch (error) {
      if (mounted) setState(() => _errorKey = onboardingErrorKey(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return _OnboardingFrame(
      step: text.onboardingStepOne,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.phoneTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(text.phoneHelper, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 28),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumberNational],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9 +()-]')),
            ],
            onChanged: (_) => setState(() => _errorKey = null),
            decoration: InputDecoration(
              labelText: text.phoneFieldLabel,
              prefixText: '+234  ',
              errorText:
                  _errorKey == null ? null : _errorCopy(text, _errorKey!),
              border: const OutlineInputBorder(),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _loading || !_phoneIsValid ? null : _continue,
              child: _loading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(text.commonContinue),
            ),
          ),
        ],
      ),
    );
  }
}

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _timer;
  int _seconds = 60;
  bool _loading = false;
  String? _errorKey;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        timer.cancel();
        if (mounted) setState(() => _seconds = 0);
      } else if (mounted) {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _resend() async {
    final phone = ref.read(signupPhoneProvider);
    if (phone == null || _loading) return;
    setState(() {
      _loading = true;
      _errorKey = null;
    });
    try {
      await ref.read(onboardingRepositoryProvider).requestSignupOtp(phone);
      _controller.clear();
      _startTimer();
    } catch (error) {
      if (mounted) setState(() => _errorKey = onboardingErrorKey(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verify() async {
    final phone = ref.read(signupPhoneProvider);
    final code = _controller.text;
    if (phone == null || code.length != 6 || _loading) return;
    setState(() {
      _loading = true;
      _errorKey = null;
    });
    try {
      final nextStep = await ref
          .read(onboardingRepositoryProvider)
          .verifySignupOtp(phone: phone, code: code);
      final route = onboardingRouteForNextStep(nextStep);
      if (route == null) throw const UnsupportedOnboardingStepException();
      if (mounted) context.go(route);
    } catch (error) {
      if (mounted) setState(() => _errorKey = onboardingErrorKey(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final phone = ref.watch(signupPhoneProvider);
    if (phone == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/signup/phone');
      });
    }
    final masked = phone == null
        ? ''
        : '${phone.substring(0, 6)}••••${phone.substring(phone.length - 2)}';
    return _OnboardingFrame(
      step: text.onboardingStepTwo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text.otpTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            text.otpSentTo(masked),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          Semantics(
            label: text.otpFieldLabel,
            child: GestureDetector(
              onTap: _focusNode.requestFocus,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final value = index < _controller.text.length
                          ? _controller.text[index]
                          : '';
                      return Container(
                        width: 46,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          value,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      );
                    }),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        maxLength: 6,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (_) {
                          setState(() => _errorKey = null);
                          if (_controller.text.length == 6) _verify();
                        },
                        decoration: const InputDecoration(counterText: ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_errorKey != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorCopy(text, _errorKey!),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: _seconds == 0 && !_loading ? _resend : null,
              child: Text(
                _seconds == 0
                    ? text.otpResend
                    : text.otpResendCountdown(_seconds),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => context.go('/signup/phone'),
            icon: const Icon(Icons.arrow_back),
            label: Text(text.otpChangeNumber),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed:
                  _loading || _controller.text.length != 6 ? null : _verify,
              child: _loading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(text.commonVerify),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _email = TextEditingController();
  final _referralCode = TextEditingController();
  String? _dateError;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _dateOfBirth.dispose();
    _email.dispose();
    _referralCode.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (selected == null) return;
    _dateOfBirth.text =
        '${selected.year.toString().padLeft(4, '0')}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
    setState(() => _dateError = null);
  }

  void _continue() {
    final formValid = _formKey.currentState?.validate() ?? false;
    final dateValid = _dateOfBirth.text.isNotEmpty;
    setState(() => _dateError = dateValid ? null : 'validation.dob.invalid');
    if (!formValid || !dateValid) return;
    ref.read(onboardingProfileDraftProvider.notifier).state =
        OnboardingProfileDraft(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      dateOfBirth: _dateOfBirth.text,
      email: _email.text.trim(),
      referralCode:
          _referralCode.text.trim().isEmpty ? null : _referralCode.text.trim(),
    );
    context.push('/signup/consent');
  }

  String? _validateName(String? value, AppLocalizations text) {
    final name = value?.trim() ?? '';
    if (name.length < 2 ||
        name.length > 50 ||
        !RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?:[ '-][A-Za-zÀ-ÖØ-öø-ÿ]+)*$")
            .hasMatch(name)) {
      return text.nameInvalid;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return _OnboardingFrame(
      step: text.onboardingStepThree,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text.detailsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(text.detailsHelper),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                children: [
                  TextFormField(
                    controller: _firstName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) => _validateName(value, text),
                    decoration: InputDecoration(
                      labelText: text.detailsFirstName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _lastName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) => _validateName(value, text),
                    decoration: InputDecoration(
                      labelText: text.detailsLastName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _dateOfBirth,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: InputDecoration(
                      labelText: text.detailsDateOfBirth,
                      errorText:
                          _dateError == null ? null : text.dateOfBirthInvalid,
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                              .hasMatch(email)
                          ? null
                          : text.emailInvalid;
                    },
                    decoration: InputDecoration(
                      labelText: text.detailsEmail,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _referralCode,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: text.detailsReferralOptional,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    text.detailsNameMatchNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _continue,
                child: Text(text.commonContinue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsentPendingScreen extends StatefulWidget {
  const ConsentPendingScreen({super.key});

  @override
  State<ConsentPendingScreen> createState() => _ConsentPendingScreenState();
}

class _ConsentPendingScreenState extends State<ConsentPendingScreen> {
  bool _termsAccepted = false;
  bool _privacyAcknowledged = false;
  bool _optionalDataUse = false;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return _OnboardingFrame(
      step: text.onboardingStepFour,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.consentTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(text.consentDraftBanner),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                ExpansionTile(
                  title: Text(text.consentTerms),
                  subtitle: Text(text.consentDraftVersion),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Text(text.termsDraftBody),
                    CheckboxListTile(
                      value: _termsAccepted,
                      onChanged: draftLegalPreviewEnabled
                          ? (value) => setState(
                                () => _termsAccepted = value ?? false,
                              )
                          : null,
                      contentPadding: EdgeInsets.zero,
                      title: Text(text.consentTerms),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(text.consentPrivacy),
                  subtitle: Text(text.consentDraftVersion),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    Text(text.privacyDraftBody),
                    CheckboxListTile(
                      value: _privacyAcknowledged,
                      onChanged: draftLegalPreviewEnabled
                          ? (value) => setState(
                                () => _privacyAcknowledged = value ?? false,
                              )
                          : null,
                      contentPadding: EdgeInsets.zero,
                      title: Text(text.consentPrivacy),
                    ),
                  ],
                ),
                CheckboxListTile(
                  value: _optionalDataUse,
                  onChanged: draftLegalPreviewEnabled
                      ? (value) => setState(
                            () => _optionalDataUse = value ?? false,
                          )
                      : null,
                  contentPadding: EdgeInsets.zero,
                  title: Text(text.consentOptionalDataUse),
                  subtitle: Text(text.consentOptionalDataUseHint),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: draftLegalPreviewEnabled &&
                      _termsAccepted &&
                      _privacyAcknowledged
                  ? () => context.go('/signup/bvn')
                  : null,
              child: Text(
                draftLegalPreviewEnabled
                    ? text.consentContinuePreview
                    : text.consentContinue,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text.consentDraftNotRecorded,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class IdentityNumberScreen extends ConsumerStatefulWidget {
  const IdentityNumberScreen({super.key, required this.isBvn});

  final bool isBvn;

  @override
  ConsumerState<IdentityNumberScreen> createState() =>
      _IdentityNumberScreenState();
}

class _IdentityNumberScreenState extends ConsumerState<IdentityNumberScreen> {
  final _controller = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final number = _controller.text.trim();
    if (!RegExp(r'^\d{11}$').hasMatch(number)) {
      setState(() => _error = 'onboarding.error.identityNumber');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final repository = ref.read(onboardingRepositoryProvider);
      if (widget.isBvn) {
        await repository.verifyBvn(number);
      } else {
        await repository.verifyNin(number);
      }
      if (mounted) context.go(widget.isBvn ? '/signup/nin' : '/signup/selfie');
    } catch (error) {
      if (mounted) setState(() => _error = onboardingErrorKey(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final bvn = widget.isBvn;
    final errorMessage = switch (_error) {
      'onboarding.error.identityNumber' => text.identityNumberInvalid,
      'onboarding.error.kycMismatch' => text.kycMismatch,
      'onboarding.error.kycUnavailable' => text.kycUnavailable,
      'onboarding.error.kycRejected' => text.kycRejected,
      'onboarding.error.rateLimited' => text.errorRateLimited,
      'onboarding.error.offline' => text.errorOffline,
      'onboarding.error.configuration' => text.errorConfiguration,
      null => null,
      _ => text.errorUnexpected,
    };
    return _OnboardingFrame(
      step: bvn ? text.onboardingStepFive : text.onboardingStepSix,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bvn ? text.bvnTitle : text.ninTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(bvn ? text.bvnHelper : text.ninHelper),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            maxLength: 11,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            onChanged: (_) => setState(() => _error = null),
            decoration: InputDecoration(
              labelText: bvn ? text.bvnFieldLabel : text.ninFieldLabel,
              helperText: text.identityNumberHint,
              errorText: errorMessage,
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _loading ? null : _verify,
              child: _loading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(bvn ? text.bvnVerify : text.ninVerify),
            ),
          ),
        ],
      ),
    );
  }
}

class CredentialSetupScreen extends ConsumerStatefulWidget {
  const CredentialSetupScreen({super.key, required this.isPin});

  final bool isPin;

  @override
  ConsumerState<CredentialSetupScreen> createState() =>
      _CredentialSetupScreenState();
}

class _CredentialSetupScreenState extends ConsumerState<CredentialSetupScreen> {
  final _firstController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _errorKey;
  bool _loading = false;

  @override
  void dispose() {
    _firstController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _isWeakPasscode(String passcode) {
    if (RegExp(r'^(\d)\1{5}$').hasMatch(passcode)) return true;
    final digits = passcode.codeUnits.map((digit) => digit - 48).toList();
    final difference = digits[1] - digits[0];
    if (difference.abs() != 1) return false;
    return List.generate(4, (index) => digits[index + 1] - digits[index])
        .every((step) => step == difference);
  }

  Future<void> _continue() async {
    final first = _firstController.text;
    final confirmation = _confirmController.text;
    final expectedLength = widget.isPin ? 4 : 6;
    if (first.length != expectedLength || !RegExp(r'^\d+$').hasMatch(first)) {
      setState(() => _errorKey = 'validation.credential.length');
      return;
    }
    if (first != confirmation) {
      setState(() => _errorKey = 'validation.credential.mismatch');
      return;
    }
    if (!widget.isPin) {
      if (_isWeakPasscode(first)) {
        setState(() => _errorKey = 'validation.passcode.weak');
        return;
      }
      ref.read(signupPasscodeProvider.notifier).state = first;
      context.go('/signup/pin');
      return;
    }

    final passcode = ref.read(signupPasscodeProvider);
    if (passcode == null) {
      context.go('/signup/passcode');
      return;
    }
    setState(() {
      _errorKey = null;
      _loading = true;
    });
    try {
      await ref.read(onboardingRepositoryProvider).setCredentials(
            passcode: passcode,
            pin: first,
          );
      ref.read(signupPasscodeProvider.notifier).state = null;
      if (mounted) context.go('/signup/biometrics');
    } catch (error) {
      if (mounted) setState(() => _errorKey = onboardingErrorKey(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final isPin = widget.isPin;
    final errorMessage = switch (_errorKey) {
      'validation.credential.length' => text.credentialLengthInvalid,
      'validation.credential.mismatch' => text.credentialMismatch,
      'validation.passcode.weak' => text.passcodeWeak,
      'onboarding.error.rateLimited' => text.errorRateLimited,
      'onboarding.error.offline' => text.errorOffline,
      'onboarding.error.configuration' => text.errorConfiguration,
      null => null,
      _ => text.errorUnexpected,
    };
    return _OnboardingFrame(
      step: text.onboardingStepEight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPin ? text.transactionPinTitle : text.passcodeCreateTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(isPin ? text.transactionPinHelper : text.passcodeCreateHelper),
          const SizedBox(height: 24),
          _CredentialField(
            controller: _firstController,
            label: isPin ? text.transactionPinField : text.passcodeCreateField,
            length: isPin ? 4 : 6,
          ),
          const SizedBox(height: 16),
          _CredentialField(
            controller: _confirmController,
            label: isPin ? text.transactionPinConfirm : text.passcodeConfirm,
            length: isPin ? 4 : 6,
          ),
          if (isPin) ...[
            const SizedBox(height: 12),
            Text(text.transactionPinDifferentNote),
          ],
          if (errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              errorMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _loading ? null : _continue,
              child: _loading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(text.commonContinue),
            ),
          ),
        ],
      ),
    );
  }
}

class _CredentialField extends StatelessWidget {
  const _CredentialField({
    required this.controller,
    required this.label,
    required this.length,
  });

  final TextEditingController controller;
  final String label;
  final int length;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: length,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(length),
        ],
        decoration: InputDecoration(
          labelText: label,
          counterText: '',
          border: const OutlineInputBorder(),
        ),
      );
}

class OnboardingStatusScreen extends ConsumerWidget {
  const OnboardingStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final status = ref.watch(onboardingStatusProvider);
    return _OnboardingFrame(
      step: text.onboardingStepEight,
      child: status.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _statusMessage(
          context,
          text.onboardingStatusUnavailable,
          text,
          onRetry: () => ref.invalidate(onboardingStatusProvider),
        ),
        data: (snapshot) => switch (snapshot.state) {
          OnboardingAccountState.onboarding => _continueOnboarding(
              context,
              snapshot,
              text,
            ),
          OnboardingAccountState.pendingAccount => _statusMessage(
              context,
              text.onboardingAccountPending,
              text,
              onRetry: () => ref.invalidate(onboardingStatusProvider),
            ),
          OnboardingAccountState.manualReview => _statusMessage(
              context,
              text.onboardingManualReview,
              text,
              onRetry: () => ref.invalidate(onboardingStatusProvider),
            ),
          OnboardingAccountState.rejected => _statusMessage(
              context,
              text.onboardingRejected,
              text,
              onRetry: () => ref.invalidate(onboardingStatusProvider),
            ),
          OnboardingAccountState.active => _accountReady(
              context,
              snapshot,
              text,
            ),
        },
      ),
    );
  }

  Widget _continueOnboarding(
    BuildContext context,
    OnboardingStatusSnapshot status,
    AppLocalizations text,
  ) {
    final route = onboardingRouteForResumeStep(status.step);
    if (route == null) {
      return _statusMessage(
        context,
        text.onboardingStepUnsupported,
        text,
        onRetry: () => context.go('/welcome'),
      );
    }
    return _statusMessage(
      context,
      text.onboardingContinueSetup,
      text,
      onRetry: () => context.go(route),
      retryLabel: text.commonContinue,
    );
  }

  Widget _accountReady(
    BuildContext context,
    OnboardingStatusSnapshot status,
    AppLocalizations text,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text.onboardingAccountReady,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          if (status.accountNumber != null && status.accountNumber!.isNotEmpty)
            SelectableText(
                '${text.accountNumberLabel}: ${status.accountNumber}'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => context.go('/login'),
              child: Text(text.loginTitle),
            ),
          ),
        ],
      );

  Widget _statusMessage(
    BuildContext context,
    String message,
    AppLocalizations text, {
    required VoidCallback onRetry,
    String? retryLabel,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onRetry,
              child: Text(retryLabel ?? text.onboardingCheckStatus),
            ),
          ),
        ],
      );
}

class FlowPendingScreen extends StatelessWidget {
  const FlowPendingScreen({
    super.key,
    this.isPasscodeReset = false,
  });

  final bool isPasscodeReset;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.go(isPasscodeReset ? '/login' : '/welcome'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPasscodeReset ? text.resetPasscodeTitle : text.newDeviceTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(text.flowNotReady),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.go(
                    isPasscodeReset ? '/login' : '/welcome',
                  ),
                  child: Text(text.commonBack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifierController = TextEditingController();
  String _passcode = '';
  String? _errorKey;
  bool _loading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _append(String digit) {
    if (_passcode.length == 6 || _loading) return;
    setState(() {
      _passcode += digit;
      _errorKey = null;
    });
  }

  Future<void> _submit() async {
    final identifier = _identifierController.text.trim();
    if (identifier.isEmpty || _passcode.length != 6 || _loading) return;
    setState(() {
      _loading = true;
      _errorKey = null;
    });
    try {
      await ref
          .read(onboardingRepositoryProvider)
          .login(identifier: identifier, passcode: _passcode);
      if (mounted) context.go('/home');
    } catch (error) {
      if (AccountRestrictionContext.isLockoutError(error)) {
        if (mounted) {
          context.go(
            '/account-locked',
            extra: AccountRestrictionContext.fromApiError(error),
          );
        }
        return;
      }
      if (mounted) {
        setState(() {
          _errorKey = loginErrorKey(error);
          _passcode = '';
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _biometricLogin() async {
    if (_loading) return;
    final text = AppLocalizations.of(context)!;
    setState(() {
      _loading = true;
      _errorKey = null;
    });
    try {
      final result = await ref
          .read(biometricEnrollmentServiceProvider)
          .authenticateForLogin(localizedReason: text.biometricLoginReason);
      if (!mounted) return;
      if (result == BiometricUnlockResult.authenticated) {
        await ref.read(onboardingRepositoryProvider).refreshSession();
        if (mounted) context.go('/home');
      } else if (result == BiometricUnlockResult.cancelled) {
        setState(() => _errorKey = 'login.error.biometricCancelled');
      } else {
        ref.invalidate(biometricLoginAvailableProvider);
      }
    } catch (error) {
      if (mounted) setState(() => _errorKey = loginErrorKey(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _errorCopy(AppLocalizations text) => switch (_errorKey) {
        'login.error.locked' => text.loginLocked,
        'login.error.device' => text.loginNewDevice,
        'login.error.credentials' => text.loginInvalid,
        'login.error.biometricCancelled' => text.biometricLoginCancelled,
        'login.error.sessionExpired' => text.biometricLoginSessionExpired,
        'onboarding.error.configuration' => text.errorConfiguration,
        'onboarding.error.rateLimited' => text.errorRateLimited,
        'onboarding.error.offline' => text.errorOffline,
        _ => text.errorUnexpected,
      };

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final canUseBiometrics = ref
        .watch(biometricLoginAvailableProvider)
        .maybeWhen(data: (available) => available, orElse: () => false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.go('/welcome'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text.loginTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(text.loginHelper),
              const SizedBox(height: 24),
              TextField(
                controller: _identifierController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.username],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: text.loginIdentifier,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  text.loginPasscodeLabel,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Icon(
                      index < _passcode.length
                          ? Icons.circle
                          : Icons.circle_outlined,
                      size: 13,
                    ),
                  ),
                ),
              ),
              if (_errorKey != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorCopy(text),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var row = 0; row < 3; row++)
                          Expanded(
                            child: Row(
                              children: [
                                for (var col = 1; col <= 3; col++)
                                  Expanded(
                                    child: _KeypadButton(
                                      label: '${row * 3 + col}',
                                      onPressed: () =>
                                          _append('${row * 3 + col}'),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Expanded(
                                child: _KeypadButton(
                                  label: '0',
                                  onPressed: () => _append('0'),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  tooltip: text.loginDeleteDigit,
                                  onPressed: _passcode.isEmpty || _loading
                                      ? null
                                      : () => setState(() {
                                            _passcode = _passcode.substring(
                                              0,
                                              _passcode.length - 1,
                                            );
                                            _errorKey = null;
                                          }),
                                  icon: const Icon(Icons.backspace_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_errorKey == 'login.error.device')
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(text.loginDeviceVerificationRequired),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login/new-device'),
                        child: Text(text.loginVerifyDeviceAction),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _loading ||
                          _passcode.length != 6 ||
                          _identifierController.text.trim().isEmpty
                      ? null
                      : _submit,
                  child: _loading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(text.loginSubmit),
                ),
              ),
              if (canUseBiometrics)
                Center(
                  child: TextButton.icon(
                    onPressed: _loading ? null : _biometricLogin,
                    icon: const Icon(Icons.fingerprint),
                    label: Text(text.biometricLoginButton),
                  ),
                ),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/login/reset'),
                  child: Text(text.loginForgotPasscode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(shape: const CircleBorder()),
            child: Text(label, style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
      );
}

class _OnboardingFrame extends StatelessWidget {
  const _OnboardingFrame({required this.step, required this.child});

  final String step;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(step),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: child,
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            text.brandInitial,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          text.appTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

String _errorCopy(AppLocalizations text, String key) => switch (key) {
      'validation.phone.invalid' => text.phoneInvalid,
      'onboarding.error.configuration' => text.errorConfiguration,
      'onboarding.error.rateLimited' => text.errorRateLimited,
      'onboarding.error.otpInvalid' => text.errorOtpInvalid,
      'onboarding.error.kycMismatch' => text.kycMismatch,
      'onboarding.error.kycUnavailable' => text.kycUnavailable,
      'onboarding.error.kycRejected' => text.kycRejected,
      'onboarding.error.offline' => text.errorOffline,
      'onboarding.error.resumeUnsupported' => text.onboardingResumeUnsupported,
      _ => text.errorUnexpected,
    };
