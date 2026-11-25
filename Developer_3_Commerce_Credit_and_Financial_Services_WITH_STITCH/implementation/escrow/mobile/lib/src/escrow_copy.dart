class EscrowCopy {
  const EscrowCopy();

  String get product => 'Escrow';
  String get loading => 'Loading deals';
  String get loadError => 'Deals could not be loaded.';
  String get retry => 'Retry';
  String get noDeals => 'No deals in this section yet.';
  String get amountUnavailable => 'Amount not supplied';
  String get newDeal => 'New deal';
  String get howEscrowWorks => 'How escrow works';
  String get detailUnavailable =>
      'Deal details are available in a later Escrow batch.';
  String get createTitle => 'Create deal';
  String get type => 'Deal type';
  String get role => 'Your role';
  String get title => 'Deal title';
  String get description => 'Description';
  String get amount => 'Deal amount';
  String get timeline => 'Timeline';
  String get addMilestone => 'Add milestone';
  String get milestoneTitle => 'Milestone name';
  String get milestoneAmount => 'Milestone amount';
  String get checkpointsUnavailable =>
      'Property checkpoints require an approved host template.';
  String get milestonesUnavailable =>
      'Add service milestones; the total must equal the deal amount.';
  String get amountInvalid => 'Enter a valid amount greater than zero.';
  String get titleRequired => 'Enter a deal title.';
  String get milestonesRequired => 'Add at least one service milestone.';
  String get milestonesSumInvalid =>
      'Milestone amounts must equal the deal amount.';
  String get createError => 'The deal could not be prepared. Try again.';
  String get continueLabel => 'Continue';
  String get termsTitle => 'Fees and cancellation terms';
  String get termsUnavailable =>
      'Fee options and fee amounts have not been supplied by the host.';
  String get feePayer => 'Who pays the fee?';
  String get buyerSplit => 'Buyer share (%)';
  String get sellerSplit => 'Seller share';
  String get scenarios => 'Cancellation and refund scenarios';
  String get summary => 'Terms summary';
  String get acceptSummary => 'I have reviewed the supplied terms';
  String get selectAllOptions => 'Select an option for each supplied scenario.';
  String get splitInvalid => 'Buyer and seller shares must total 100%.';
  String get continueUnavailable =>
      'Terms cannot be submitted until a deal ID and host-supplied options are available.';
  String get termsError => 'Terms could not be saved. Review and retry.';
  String get termsSaved => 'Terms saved by the host.';
  String get nonProduction =>
      'NON-PRODUCTION ESCROW PREVIEW · Synthetic sample deal cards only. No API, auth, PIN, bank transfer, fee quote, document upload, or deal operation is connected.';
  String get navOutsidePreview => 'This preview contains Escrow screens only.';
}
