import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

class DemoBillCategoryScreen extends StatefulWidget {
  const DemoBillCategoryScreen({super.key});

  @override
  State<DemoBillCategoryScreen> createState() => _DemoBillCategoryScreenState();
}

class _DemoBillCategoryScreenState extends State<DemoBillCategoryScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final categories = _billCategories(text);
    final visible = categories
        .where(
          (item) =>
              item.name.toLowerCase().contains(_query) ||
              item.description.toLowerCase().contains(_query),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              tooltip: text.commonBack,
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back)),
          title: Text(text.paymentsBillsUtilities)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _DemoBanner(text: text.billDemoNotice),
        const SizedBox(height: 12),
        TextField(
            onChanged: (value) =>
                setState(() => _query = value.trim().toLowerCase()),
            decoration: InputDecoration(
                hintText: text.billSearchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder())),
        const SizedBox(height: 18),
        _SectionHeading(
            title: text.billFrequentTitle, trailing: text.billQuickRevend),
        const SizedBox(height: 8),
        SizedBox(
            height: 86,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              _FrequentBiller(
                  label: 'IKEDC',
                  icon: Icons.bolt_outlined,
                  onTap: () => _openBiller(context, 'Ikeja Electric')),
              _FrequentBiller(
                  label: 'DStv',
                  icon: Icons.tv_outlined,
                  onTap: () => _openBiller(context, 'DStv')),
              _FrequentBiller(
                  label: 'MTN Data',
                  icon: Icons.wifi,
                  onTap: () => _openBiller(context, 'MTN Data')),
              _FrequentBiller(
                  label: 'Bet9ja',
                  icon: Icons.sports_soccer_outlined,
                  onTap: () => _openBiller(context, 'Bet9ja')),
              _FrequentBiller(
                  label: 'Cowry',
                  icon: Icons.directions_bus_outlined,
                  onTap: () => _openBiller(context, 'Cowry')),
            ])),
        const SizedBox(height: 16),
        _SectionHeading(
            title: text.billCategoriesTitle,
            trailing: text.billDemoCategoryCount(categories.length)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visible.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 172),
          itemBuilder: (context, index) {
            final category = visible[index];
            return Card(
                child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push(
                        '/demo/bills/billers?category=${Uri.encodeComponent(category.code)}'),
                    child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  child: Icon(category.icon)),
                              const SizedBox(height: 8),
                              Text(category.name,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 3),
                              Expanded(
                                  child: Text(category.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis)),
                              Row(children: [
                                Expanded(
                                    child: Text(category.footer,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                                const Icon(Icons.chevron_right, size: 18)
                              ]),
                            ]))));
          },
        ),
        const SizedBox(height: 16),
        Card(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.verified_outlined),
                      const SizedBox(width: 10),
                      Expanded(child: Text(text.billReceiptNotice))
                    ]))),
      ]),
    );
  }

  void _openBiller(BuildContext context, String name) =>
      context.push('/demo/bills/pay?biller=${Uri.encodeComponent(name)}');
}

class DemoBillersScreen extends StatelessWidget {
  const DemoBillersScreen({required this.categoryCode, super.key});
  final String categoryCode;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final category = _billCategories(text).firstWhere(
        (item) => item.code == categoryCode,
        orElse: () => _billCategories(text).first);
    final billers = _billersFor(categoryCode);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              tooltip: text.commonBack,
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back)),
          title: Text(category.name)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _DemoBanner(text: text.billDemoNotice),
        const SizedBox(height: 12),
        for (final biller in billers)
          Card(
              child: ListTile(
                  leading: CircleAvatar(child: Icon(category.icon)),
                  title: Text(biller),
                  subtitle: Text(category.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                      '/demo/bills/pay?biller=${Uri.encodeComponent(biller)}'))),
      ]),
    );
  }
}

class DemoBillPayScreen extends StatefulWidget {
  const DemoBillPayScreen({required this.biller, super.key});
  final String biller;

  @override
  State<DemoBillPayScreen> createState() => _DemoBillPayScreenState();
}

class _DemoBillPayScreenState extends State<DemoBillPayScreen> {
  final _reference = TextEditingController();
  final _amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _referenceKey = GlobalKey<FormFieldState<String>>();
  String _product = 'Prepaid';
  bool _validated = false;
  bool _saveBiller = false;
  bool _schedulePayment = false;

  @override
  void dispose() {
    _reference.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final isElectricity = widget.biller.toLowerCase().contains('electric');
    final nameLabel =
        isElectricity ? text.billMeterNumber : text.billCustomerReference;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              tooltip: text.commonBack,
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back)),
          title: Text(widget.biller)),
      body: Form(
          key: _formKey,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            _DemoBanner(text: text.billDemoNotice),
            const SizedBox(height: 12),
            Card(
                child: ListTile(
                    leading:
                        const CircleAvatar(child: Icon(Icons.bolt_outlined)),
                    title: Text(widget.biller,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(text.billProviderDemo))),
            const SizedBox(height: 12),
            SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                      value: 'Prepaid', label: Text(text.billPrepaid)),
                  ButtonSegment(
                      value: 'Postpaid', label: Text(text.billPostpaid))
                ],
                selected: {
                  _product
                },
                onSelectionChanged: (values) => setState(() {
                      _product = values.first;
                      _validated = false;
                    })),
            const SizedBox(height: 16),
            TextFormField(
                key: _referenceKey,
                controller: _reference,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: nameLabel,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        tooltip: text.billValidate,
                        onPressed: _validate,
                        icon: const Icon(Icons.verified_outlined))),
                validator: (value) => value == null || value.trim().length < 6
                    ? text.billReferenceInvalid
                    : null,
                onChanged: (_) {
                  if (_validated) setState(() => _validated = false);
                }),
            const SizedBox(height: 8),
            OutlinedButton.icon(
                onPressed: _validate,
                icon: const Icon(Icons.verified_outlined),
                label: Text(text.billValidate)),
            if (_validated) ...[
              const SizedBox(height: 8),
              Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: ListTile(
                      leading: const Icon(Icons.verified),
                      title: Text(text.billDemoValidated),
                      subtitle: Text(text.billFictionalName))),
            ],
            const SizedBox(height: 16),
            TextFormField(
                controller: _amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: text.billAmount,
                    prefixText: '\u20a6',
                    border: const OutlineInputBorder()),
                validator: (value) {
                  final amount = double.tryParse(value?.trim() ?? '');
                  return amount == null || amount <= 0
                      ? text.billAmountInvalid
                      : null;
                }),
            const SizedBox(height: 12),
            SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(text.billSaveBiller),
                value: _saveBiller,
                onChanged: (value) => setState(() => _saveBiller = value)),
            SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(text.billSchedulePayment),
                value: _schedulePayment,
                onChanged: (value) => setState(() => _schedulePayment = value)),
            const SizedBox(height: 16),
            SizedBox(
                height: 52,
                child: FilledButton(
                    onPressed: _validated ? _confirmPayment : null,
                    child: Text(text.billContinue))),
            const SizedBox(height: 8),
            Text(text.billNoMoneyNotice,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ])),
    );
  }

  void _validate() {
    if (!_referenceKey.currentState!.validate()) return;
    setState(() => _validated = true);
  }

  Future<void> _confirmPayment() async {
    final text = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amount.text.trim());
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(text.billConfirmTitle),
              content: Text(text.billConfirmPrompt(widget.biller,
                  _reference.text.trim(), amount.toStringAsFixed(2))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(text.commonCancel)),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(text.billDemoPayAction))
              ],
            ));
    if (confirmed != true || !mounted) return;
    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              icon: const Icon(Icons.info_outline),
              title: Text(text.billDemoResultTitle),
              content: Text([
                text.billDemoResultBody,
                if (_saveBiller) text.billDemoSavedBillerNote,
                if (_schedulePayment) text.billDemoScheduleNote,
              ].join('\n\n')),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(text.commonClose))
              ],
            ));
  }
}

class _BillCategory {
  const _BillCategory(
      this.code, this.name, this.description, this.footer, this.icon);
  final String code;
  final String name;
  final String description;
  final String footer;
  final IconData icon;
}

List<_BillCategory> _billCategories(AppLocalizations text) => [
      _BillCategory(
          'electricity',
          text.billElectricity,
          text.billElectricityDescription,
          text.billDemoDiscos,
          Icons.bolt_outlined),
      _BillCategory('cable', text.billCableInternet, text.billCableDescription,
          text.billInstantRenewal, Icons.live_tv_outlined),
      _BillCategory('water', text.billWater, text.billWaterDescription,
          text.billStateBoards, Icons.water_drop_outlined),
      _BillCategory(
          'government',
          text.billGovernment,
          text.billGovernmentDescription,
          text.billDirectPayments,
          Icons.account_balance_outlined),
      _BillCategory('betting', text.billBetting, text.billBettingDescription,
          text.billZeroCharges, Icons.sports_soccer_outlined),
      _BillCategory(
          'education',
          text.billEducation,
          text.billEducationDescription,
          text.billPinDelivery,
          Icons.school_outlined),
      _BillCategory('charity', text.billCharity, text.billCharityDescription,
          text.billDonations, Icons.volunteer_activism_outlined),
      _BillCategory(
          'transport',
          text.billTransport,
          text.billTransportDescription,
          text.billInstantTopup,
          Icons.directions_bus_outlined),
    ];

List<String> _billersFor(String code) => switch (code) {
      'electricity' => ['Ikeja Electric', 'Eko Electric', 'Abuja Electric'],
      'cable' => ['DStv', 'GOtv', 'StarTimes'],
      'water' => ['State Water Board'],
      'government' => ['Revenue Collection'],
      'betting' => ['Bet9ja', 'SportyBet'],
      'education' => ['JAMB', 'WAEC'],
      'charity' => ['Community Donation'],
      _ => ['Lekki Concession Toll', 'Cowry Transit'],
    };

class _DemoBanner extends StatelessWidget {
  const _DemoBanner({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(padding: const EdgeInsets.all(12), child: Text(text)));
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.trailing});
  final String title;
  final String trailing;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        Text(trailing, style: Theme.of(context).textTheme.bodySmall)
      ]);
}

class _FrequentBiller extends StatelessWidget {
  const _FrequentBiller(
      {required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 76,
      child: InkWell(
          onTap: onTap,
          child: Column(children: [
            CircleAvatar(child: Icon(icon)),
            const SizedBox(height: 6),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)
          ])));
}
