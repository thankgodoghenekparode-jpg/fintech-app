// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'YourApp';

  @override
  String get brandInitial => 'Y';

  @override
  String get navHome => 'Home';

  @override
  String get navPayments => 'Payments';

  @override
  String get navCards => 'Cards';

  @override
  String get navSaveBorrow => 'Save & Borrow';

  @override
  String get navMore => 'More';

  @override
  String homeGreetingName(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get homeGreetingGeneric => 'Welcome back';

  @override
  String get homeNotifications => 'Notifications';

  @override
  String get moreAccountPreferences => 'Account & preferences';

  @override
  String get moreProfileKyc => 'Profile & account details';

  @override
  String get moreProfileSubtitle =>
      'View available profile and account information';

  @override
  String get profileTitle => 'Personal profile';

  @override
  String get profileEditUnavailableTitle => 'Profile editing unavailable';

  @override
  String get profileEditUnavailableBody =>
      'The current API contract does not provide a profile read or update operation, contact verification by OTP, or profile photo upload. Your verified account name and tier are shown below; profile changes are not submitted.';

  @override
  String get profileNameUnavailable => 'Name not available';

  @override
  String profileTier(int tier) {
    return 'Tier $tier';
  }

  @override
  String get profileTierUnavailable => 'Tier information unavailable';

  @override
  String get profilePersonalInfo => 'Personal information';

  @override
  String get profileFullName => 'Full name';

  @override
  String get profilePhone => 'Phone number';

  @override
  String get profileEmail => 'Email address';

  @override
  String get profileAddress => 'Residential address';

  @override
  String get profileNotProvided => 'Not provided by account service';

  @override
  String get profileUnavailable => 'Not available from account service';

  @override
  String get profileContractNote =>
      'Your account service currently provides your account name and tier only. Phone, email, address, verification status, and edit-by-OTP operations need an approved API contract before they can be shown or changed here.';

  @override
  String get profileAccountDetails => 'View account details';

  @override
  String get profileDemoNotice =>
      'DEMO DATA ONLY · Ada Nwosu is fictional. No profile or contact data is loaded from a bank.';

  @override
  String get moreLimits => 'Account limits & allowances';

  @override
  String get moreLimitsUnavailable =>
      'Limits are not available from your account yet';

  @override
  String moreDailyLimit(String amount) {
    return 'Daily $amount';
  }

  @override
  String moreSingleLimit(String amount) {
    return 'Per transfer $amount';
  }

  @override
  String get moreStatements => 'Statements & reports';

  @override
  String get moreStatementsSubtitle => 'Request or download account statements';

  @override
  String get moreSecurityControl => 'Security & control';

  @override
  String get moreNotificationsSubtitle =>
      'Account alerts and transaction updates';

  @override
  String get moreCards => 'Card management';

  @override
  String get moreCardsSubtitle => 'View, freeze and manage your cards';

  @override
  String get moreSecurity => 'Security hub';

  @override
  String get moreSecuritySubtitle =>
      'Passcode, transaction PIN and account controls';

  @override
  String get moreSecurityBlocked =>
      'Security settings need approved change-passcode and change-PIN flows. These operations are not defined by the current API contract.';

  @override
  String get moreDevices => 'Linked devices';

  @override
  String get moreDevicesSubtitle => 'Review active sessions on your account';

  @override
  String get moreDevicesBlocked =>
      'The API lists device operations but does not define the device response fields or current-device behavior. Device management is not available yet.';

  @override
  String get moreSupportLegal => 'Payments, support & legal';

  @override
  String get morePaymentsSubtitle =>
      'Transfers, beneficiaries and bill payments';

  @override
  String get moreHelp => 'Help centre & support';

  @override
  String get moreHelpSubtitle => 'Get help with your account and transactions';

  @override
  String get moreLegal => 'Legal, terms & privacy';

  @override
  String get moreLegalSubtitle => 'Read legal drafts and review consent status';

  @override
  String get moreLegalBlocked =>
      'Approved Terms and Privacy documents and version identifiers have not been supplied. Draft legal text must not be presented as approved policy.';

  @override
  String get helpCentreTitle => 'Help & Support';

  @override
  String get helpCentreQuestion => 'How can we help you today?';

  @override
  String get helpSearchHint => 'Search guides and topics';

  @override
  String get helpPopularTopics => 'Popular topics';

  @override
  String get helpTopicAll => 'All';

  @override
  String get helpTopicTransfers => 'Transfers';

  @override
  String get helpTopicCards => 'Cards';

  @override
  String get helpTopicAccount => 'Account';

  @override
  String get helpTopicBills => 'Bills';

  @override
  String get helpTopicOther => 'Other';

  @override
  String get helpFaqTitle => 'Frequently asked questions';

  @override
  String get helpNoResults =>
      'No matching help articles. You can file a support ticket.';

  @override
  String get helpStillNeedHelp => 'Still need help?';

  @override
  String get helpStartChat => 'Start a support conversation';

  @override
  String get helpTicketDescription =>
      'Send a message to the support team and track your ticket here.';

  @override
  String get helpFileTicket => 'File a support ticket';

  @override
  String get helpTrackTickets => 'Track my tickets';

  @override
  String get helpEscalationTitle => 'Escalation information';

  @override
  String get helpEscalationBody =>
      'Approved regulator escalation instructions and response timelines have not been supplied. Contact details will appear here when confirmed.';

  @override
  String get helpContentNote =>
      'Help articles describe current app behavior. Do not share your passcode, transaction PIN or one-time password in a ticket.';

  @override
  String get helpTransferTitle => 'Check a transfer status';

  @override
  String get helpTransferBody =>
      'Open Payments or transaction history and select the transfer to view its current status and available details. If the transfer needs investigation, file a ticket and include its transaction reference. Avoid repeating a transfer while its status is pending.';

  @override
  String get helpViewHistory => 'View transaction history';

  @override
  String get helpCardTitle => 'Freeze or manage a card';

  @override
  String get helpCardBody =>
      'Open Cards, select the card, and use the available card controls. Card settings and sensitive details depend on your bank\'s enabled services and device security support.';

  @override
  String get helpAccountTitle => 'Find your account details';

  @override
  String get helpAccountBody =>
      'Open Add money or Account details to view the account name and number returned by your bank. The app does not display a bank name unless the API provides it.';

  @override
  String get helpBillsTitle => 'A bill payment is pending';

  @override
  String get helpBillsBody =>
      'Check the payment result and transaction status in the bill flow. If the result is pending, do not submit the same payment again; use a support ticket if you need help investigating it.';

  @override
  String get notificationsTickets => 'Support tickets';

  @override
  String get ticketsActive => 'Active tickets';

  @override
  String get ticketsResolved => 'Resolved';

  @override
  String get ticketsEmpty => 'There are no tickets in this list.';

  @override
  String get ticketsLoadError => 'We could not load your support tickets.';

  @override
  String get ticketNewTitle => 'New support ticket';

  @override
  String get ticketCategory => 'Category';

  @override
  String get ticketDescription => 'Describe the issue';

  @override
  String get ticketDescriptionHint =>
      'Include what happened and the transaction reference if relevant. Do not include passwords, PINs or one-time codes.';

  @override
  String get ticketDescriptionValidation =>
      'Enter a message with no more than 4,000 characters.';

  @override
  String get ticketSubmit => 'Submit ticket';

  @override
  String get ticketSubmitError =>
      'We could not submit your ticket. Please try again.';

  @override
  String get ticketLinkedTransaction => 'Linked transaction';

  @override
  String get ticketNoAttachmentNotice =>
      'Attachments are not supported by the current ticket API.';

  @override
  String get ticketDetailTitle => 'Ticket conversation';

  @override
  String get ticketNoMessages => 'No messages have been added yet.';

  @override
  String get ticketReplyHint => 'Write a reply';

  @override
  String get ticketSendReply => 'Send reply';

  @override
  String get ticketReplyError => 'We could not send your reply. Try again.';

  @override
  String get ticketYou => 'You';

  @override
  String get ticketSupport => 'Support';

  @override
  String get supportChatTitle => 'Support chat';

  @override
  String get supportChatTeam => 'Support team';

  @override
  String get supportChatAsyncNotice =>
      'Replies use the support ticket service and are handled asynchronously. Agent availability and response times are not provided.';

  @override
  String get supportChatMessageLabel => 'Message support';

  @override
  String get supportChatMessageHint =>
      'Describe how we can help. Do not share passwords, PINs or one-time codes.';

  @override
  String get supportChatStartButton => 'Start conversation';

  @override
  String get supportChatRefresh => 'Refresh conversation';

  @override
  String get supportChatReplyError =>
      'We could not send this message. It remains in the text box so you can retry. No offline queue is available.';

  @override
  String supportChatLinkedTransaction(String id) {
    return 'Transaction $id';
  }

  @override
  String get ticketStatusOpen => 'Open';

  @override
  String get ticketStatusInProgress => 'In progress';

  @override
  String get ticketStatusResolved => 'Resolved';

  @override
  String get ticketStatusClosed => 'Closed';

  @override
  String get ticketStatusUnknown => 'Status unavailable';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonUnavailable => 'Unavailable';

  @override
  String get reportTitle => 'Report a problem';

  @override
  String get reportSelectIssue => 'Select issue category';

  @override
  String get reportRequired => 'Required';

  @override
  String get reportReasonNotReceived => 'Not received';

  @override
  String get reportReasonChargedFailed => 'Charged but failed';

  @override
  String get reportReasonWrongAmount => 'Wrong amount';

  @override
  String get reportReasonUnauthorized => 'Unauthorised';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get reportAffectedTransaction => 'Affected transaction';

  @override
  String get reportDescribe => 'Describe what happened';

  @override
  String get reportDescriptionHint =>
      'Add details that will help the support team investigate.';

  @override
  String get reportIncludeReference =>
      'Include relevant details. Never include your PIN, passcode or one-time password.';

  @override
  String get reportAttachmentsTitle => 'Screenshots or proof';

  @override
  String get reportAttachmentsUnavailable =>
      'Attachments are not supported by the current ticket API. You can describe the evidence in your report.';

  @override
  String get reportPrivacyReminder =>
      'Your report will be linked to this transaction. Do not include full card details, passwords, PINs or one-time codes.';

  @override
  String get reportNoSla =>
      'Your ticket status and replies will be available in Support tickets. No response time is promised here.';

  @override
  String get reportSubmit => 'Submit dispute ticket';

  @override
  String get reportSelectReason => 'Select an issue category to continue.';

  @override
  String get reportDescriptionRequired =>
      'Describe the issue before submitting.';

  @override
  String get reportSubmitError =>
      'We could not submit this report. Please try again.';

  @override
  String get reportDemoPreviewNotice =>
      'DEMO PREVIEW · Sample transaction only. This will not create a real support ticket.';

  @override
  String get reportDemoPreviewSubmitted =>
      'Preview only. No support ticket was submitted.';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsAll => 'All';

  @override
  String get notificationsTransactions => 'Transactions';

  @override
  String get notificationsSecuritySystem => 'Security & System';

  @override
  String get notificationsRecent => 'Recent updates';

  @override
  String notificationsUnread(int count) {
    return '$count unread';
  }

  @override
  String get notificationsToday => 'Today';

  @override
  String get notificationsEarlier => 'Earlier';

  @override
  String get notificationsEmptyTitle => 'You are all caught up';

  @override
  String get notificationsEmptyBody =>
      'New alerts and account updates will appear here.';

  @override
  String get notificationsLoadError => 'We could not load your notifications.';

  @override
  String get notificationsUpdateError =>
      'We could not update this notification. Try again.';

  @override
  String get notificationsAllRead => 'All notifications marked as read.';

  @override
  String get homeAvailableBalance => 'Available balance';

  @override
  String get homeLedgerBalance => 'Ledger balance';

  @override
  String get homeAccountNumber => 'Account number';

  @override
  String homeTier(String tier) {
    return 'Tier $tier';
  }

  @override
  String get homeCopyAccountNumber => 'Copy account number';

  @override
  String get homeAccountNumberCopied => 'Account number copied';

  @override
  String get homeBalanceHidden => 'Balance hidden';

  @override
  String get homeHideBalance => 'Hide balance';

  @override
  String get homeShowBalance => 'Show balance';

  @override
  String homeBalanceCap(String amount) {
    return 'Balance cap $amount';
  }

  @override
  String get homeQuickSend => 'Send';

  @override
  String get homeQuickBills => 'Bills';

  @override
  String get homeQuickAddMoney => 'Add money';

  @override
  String get fundingTitle => 'Add money';

  @override
  String get fundingHelp => 'How to add money';

  @override
  String get fundingHelpBody =>
      'Send a bank transfer from another Nigerian bank to the account number shown here. Use the account name shown by your sending bank to confirm the recipient before sending.';

  @override
  String get fundingRecommended => 'Recommended';

  @override
  String get fundingRealTime => 'Real time';

  @override
  String get fundingBankTransfer => 'Bank transfer';

  @override
  String get fundingTransferSubtitle => 'Receive a transfer from any bank';

  @override
  String get fundingNumberUnavailable =>
      'Your account number is not available right now.';

  @override
  String get fundingCopy => 'Copy';

  @override
  String get fundingCopied => 'Account number copied';

  @override
  String get fundingTransferInstructions =>
      'Transfer any amount from another Nigerian bank app or USSD to this account number. The funds are credited to your account in real time.';

  @override
  String get fundingShare => 'Share account details';

  @override
  String get fundingDemoNotice =>
      'DEMO PREVIEW · Sample account details only. No funds will be received.';

  @override
  String get commonDone => 'Done';

  @override
  String get homeQuickCards => 'Cards';

  @override
  String get homeQuickSavings => 'Savings';

  @override
  String get homeCards => 'My cards';

  @override
  String homeManageCards(int count) {
    return 'Manage cards ($count)';
  }

  @override
  String get homeCreateCard => 'Create card';

  @override
  String get homeNoCards => 'You do not have a virtual card yet.';

  @override
  String get homeRecentActivity => 'Recent activity';

  @override
  String get historySearch => 'Search transactions';

  @override
  String get historyDateRange => 'Choose date range';

  @override
  String get historyAllTypes => 'All types';

  @override
  String get historyAllStatuses => 'All statuses';

  @override
  String get historyPending => 'Pending';

  @override
  String get historySuccessful => 'Successful';

  @override
  String get historyFailed => 'Failed';

  @override
  String get historyReversed => 'Reversed';

  @override
  String get historyEmpty => 'No transactions match your search.';

  @override
  String get historyExport => 'Export statement';

  @override
  String get commonRetry => 'Retry';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeBeneficiaries => 'Beneficiaries';

  @override
  String get homeNoTransactions => 'Your recent activity will appear here.';

  @override
  String get homeTransactionGeneric => 'Transaction';

  @override
  String get homeRetry => 'Try again';

  @override
  String get homeFeatureNotReady =>
      'This feature is not connected yet. Please check back later.';

  @override
  String get homeAccountLoadError => 'We could not load your account balance.';

  @override
  String get homeTransactionsLoadError => 'We could not load recent activity.';

  @override
  String get homeCardsLoadError => 'We could not load your cards.';

  @override
  String get cardsTitle => 'Cards';

  @override
  String get cardsSubtitle => 'Manage your virtual cards.';

  @override
  String get cardsVirtualCard => 'Virtual card';

  @override
  String get cardsVirtualNaira => 'VIRTUAL · NAIRA';

  @override
  String get cardsDetailsAction => 'Details';

  @override
  String get cardsCreateAction => 'Create virtual card';

  @override
  String get cardsEmptyTitle => 'No cards yet';

  @override
  String get cardsEmptyBody => 'Create a virtual card for online payments.';

  @override
  String get cardsLoadError => 'We could not load your cards.';

  @override
  String get cardsPreviewNotice =>
      'UI preview only. These sample cards are not connected to a bank account and do not represent real card data.';

  @override
  String get welcomePreviewCards => 'Preview cards UI';

  @override
  String get cardStatusActive => 'Active';

  @override
  String get cardStatusFrozen => 'Frozen';

  @override
  String get cardStatusCreating => 'Creating';

  @override
  String get cardStatusExpired => 'Expired';

  @override
  String get cardStatusDeleted => 'Deleted';

  @override
  String get cardStatusUnknown => 'Status unavailable';

  @override
  String get cardFreezeTitle => 'Freeze this card?';

  @override
  String get cardUnfreezeTitle => 'Unfreeze this card?';

  @override
  String get cardFreezePrompt =>
      'New transactions on this card will be declined while it is frozen.';

  @override
  String get cardUnfreezePrompt =>
      'This card will be available for transactions again.';

  @override
  String get cardFreezeAction => 'Freeze';

  @override
  String get cardUnfreezeAction => 'Unfreeze';

  @override
  String get cardFrozen => 'Card frozen.';

  @override
  String get cardUnfrozen => 'Card unfrozen.';

  @override
  String get cardUpdateError => 'We could not update this card. Try again.';

  @override
  String get cardCreateTitle => 'Create virtual card';

  @override
  String get cardLabelField => 'Card name';

  @override
  String get cardLabelHelper => 'Choose a name up to 30 characters.';

  @override
  String get cardLabelRequired => 'Enter a name for this card.';

  @override
  String get cardThemeTitle => 'Choose a card theme';

  @override
  String get cardThemeBerry => 'Berry';

  @override
  String get cardThemeMidnight => 'Midnight';

  @override
  String get cardThemeCoral => 'Coral';

  @override
  String get cardThemeForest => 'Forest';

  @override
  String get cardThemeSand => 'Sand';

  @override
  String get cardThemeSlate => 'Slate';

  @override
  String get cardDailyLimitField => 'Optional daily spend limit';

  @override
  String get cardDailyLimitHelper =>
      'Leave blank if you do not want a card-specific daily limit.';

  @override
  String get cardLimitMustBePositive => 'Enter an amount greater than zero.';

  @override
  String get cardCreateWithPin => 'Review and create';

  @override
  String get cardCreateSuccess => 'Your virtual card was created.';

  @override
  String get cardCreateError =>
      'We could not create this card. Check your details and try again.';

  @override
  String get cardPinTitle => 'Confirm with transaction PIN';

  @override
  String get cardPinPrompt => '4-digit transaction PIN';

  @override
  String get cardNotFound => 'This card is no longer available.';

  @override
  String get cardRevealTitle => 'Show card details';

  @override
  String get cardRevealSubtitle => 'View the full card number, expiry and CVV.';

  @override
  String get cardRevealAction => 'Verify PIN and reveal';

  @override
  String get cardRevealPrompt =>
      'Verify your transaction PIN to view these details.';

  @override
  String get cardRevealTimerNotice =>
      'Card details hide automatically after 30 seconds.';

  @override
  String get cardRevealActiveOnly =>
      'Only active cards can reveal their details.';

  @override
  String get cardRevealError =>
      'We could not verify your PIN or load card details.';

  @override
  String get cardPrivacyUnavailable =>
      'Secure card details are unavailable on this platform.';

  @override
  String get cardNumberField => 'Card number';

  @override
  String get cardExpiryField => 'Expiry';

  @override
  String get cardCvvField => 'CVV';

  @override
  String get cardCopy => 'Copy';

  @override
  String get cardCopied =>
      'Copied. Clipboard content will be cleared when card details are hidden.';

  @override
  String get cardHideDetails => 'Hide details now';

  @override
  String cardDetailsTimeout(int seconds) {
    return 'Details hide in $seconds seconds';
  }

  @override
  String get cardLimitsTitle => 'Card limits';

  @override
  String get cardLimitsSubtitle => 'Set per-transaction and daily limits.';

  @override
  String get cardPerTransactionLimit => 'Per-transaction limit';

  @override
  String get cardLimitsHint =>
      'Limits are subject to your account tier and bank policy.';

  @override
  String get cardLimitsSaved => 'Card limits updated.';

  @override
  String get cardSettingsTitle => 'Card settings and alerts';

  @override
  String get cardSettingsSubtitle => 'Control card notifications and usage.';

  @override
  String get cardPushAlerts => 'Push alerts';

  @override
  String get cardPushAlertsDescription =>
      'Get a notification when this card is used.';

  @override
  String get cardSmsAlerts => 'SMS alerts';

  @override
  String get cardSmsAlertsDescription =>
      'Receive a text message when this card is used.';

  @override
  String get cardOnlinePurchases => 'Online purchases';

  @override
  String get cardInternationalPurchases => 'International purchases';

  @override
  String get cardSettingsLoadError =>
      'We could not load card settings. Try again.';

  @override
  String get cardSettingsSaveError =>
      'We could not save this setting. Your previous setting was restored.';

  @override
  String get cardTransactionsTitle => 'Card transactions';

  @override
  String get cardTransactionsEmpty => 'No card transactions yet.';

  @override
  String get cardTransactionsLoadError =>
      'We could not load card transactions. Try again.';

  @override
  String get cardRenameAction => 'Rename card';

  @override
  String get commonSave => 'Save';

  @override
  String get cardChangeThemeAction => 'Change card theme';

  @override
  String get cardDeleteAction => 'Delete card';

  @override
  String get cardDeletePrompt =>
      'This permanently closes the card. Its transaction history is retained.';

  @override
  String homeOfflineLastUpdated(String time) {
    return 'Offline · Last updated $time';
  }

  @override
  String get homeStatusActive => 'Active';

  @override
  String get homeStatusLocked => 'Locked';

  @override
  String get homeStatusRestricted => 'Restricted';

  @override
  String get homeStatusDormant => 'Dormant';

  @override
  String get homeStatusClosed => 'Closed';

  @override
  String get homeStatusUnavailable => 'Status unavailable';

  @override
  String get homeCardCreating => 'Creating';

  @override
  String get homeCardActive => 'Active';

  @override
  String get homeCardFrozen => 'Frozen';

  @override
  String get homeCardExpired => 'Expired';

  @override
  String get homeCardDeleted => 'Deleted';

  @override
  String get homeTxnPending => 'Pending';

  @override
  String get homeTxnSuccessful => 'Successful';

  @override
  String get homeTxnFailed => 'Failed';

  @override
  String get homeTxnReversed => 'Reversed';

  @override
  String get transactionDetailTitle => 'Transaction details';

  @override
  String get transactionCounterparty => 'Counterparty';

  @override
  String get transactionBank => 'Bank';

  @override
  String get transactionNarration => 'Narration';

  @override
  String get transactionFee => 'Fee';

  @override
  String get transactionReference => 'Reference';

  @override
  String get transactionDate => 'Date and time';

  @override
  String get transactionBalanceAfter => 'Balance after';

  @override
  String get transactionFailureInsufficientFunds =>
      'There was not enough available balance for this transaction.';

  @override
  String get transactionFailureLimit =>
      'This transaction exceeded your account limit.';

  @override
  String get transactionFailureAccountLocked =>
      'Your account status prevented this transaction.';

  @override
  String get transactionFailureGeneric =>
      'This transaction could not be completed.';

  @override
  String get transactionOfflineStale =>
      'Showing the last details available on this device.';

  @override
  String get transactionDetailLoadError =>
      'We could not load this transaction.';

  @override
  String get transactionReceipt => 'Receipt';

  @override
  String get transactionReportProblem => 'Report a problem';

  @override
  String get transactionSaveBeneficiary => 'Save beneficiary';

  @override
  String get welcomeSlideSafeTitle => 'Banking that feels safe';

  @override
  String get welcomeSlideSafeBody =>
      'Your money and personal details stay protected.';

  @override
  String get welcomeSlideSimpleTitle => 'Everyday banking, made simple';

  @override
  String get welcomeSlideSimpleBody =>
      'Handle the things you need in a few clear steps.';

  @override
  String get welcomeSlideYoursTitle => 'Made for you';

  @override
  String get welcomeSlideYoursBody =>
      'A banking experience built around your everyday life.';

  @override
  String get welcomeCreateAccount => 'Create account';

  @override
  String get welcomeLogin => 'Log in';

  @override
  String get welcomePreviewLegal => 'Preview Terms and Privacy';

  @override
  String get welcomePreviewSelfie => 'Preview selfie capture';

  @override
  String get welcomePreviewBiometrics => 'Preview biometrics';

  @override
  String get welcomeLegalFooter =>
      'By continuing, you can review our Terms and Privacy Notice.';

  @override
  String get onboardingStepOne => 'Step 1 of 8';

  @override
  String get onboardingStepTwo => 'Step 2 of 8';

  @override
  String get onboardingStepThree => 'Step 3 of 8';

  @override
  String get onboardingStepFour => 'Step 4 of 8';

  @override
  String get onboardingStepFive => 'Step 5 of 8';

  @override
  String get onboardingStepSix => 'Step 6 of 8';

  @override
  String get onboardingStepSeven => 'Step 7 of 8';

  @override
  String get onboardingStepEight => 'Step 8 of 8';

  @override
  String get phoneTitle => 'What is your phone number?';

  @override
  String get phoneHelper => 'We will send a code by SMS.';

  @override
  String get phoneFieldLabel => 'Phone number';

  @override
  String get phoneInvalid => 'Enter a valid Nigerian phone number.';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonVerify => 'Verify';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonBackToWelcome => 'Back to welcome';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String otpSentTo(String phone) {
    return 'Enter the 6-digit code sent to $phone.';
  }

  @override
  String get otpFieldLabel => 'Six-digit verification code';

  @override
  String get otpResend => 'Resend code';

  @override
  String otpResendCountdown(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get otpChangeNumber => 'Change phone number';

  @override
  String get detailsTitle => 'Your personal details';

  @override
  String get detailsHelper =>
      'Enter your details as they appear on your identity documents.';

  @override
  String get detailsFirstName => 'First name';

  @override
  String get detailsLastName => 'Last name';

  @override
  String get detailsDateOfBirth => 'Date of birth';

  @override
  String get detailsEmail => 'Email address';

  @override
  String get detailsReferralOptional => 'Referral code (optional)';

  @override
  String get detailsNameMatchNote => 'Your name should match your BVN records.';

  @override
  String get nameInvalid => 'Use 2–50 letters, spaces, hyphens or apostrophes.';

  @override
  String get dateOfBirthInvalid => 'Choose a valid date of birth.';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get consentTitle => 'Before we continue';

  @override
  String get consentBlockedNotice =>
      'We cannot ask for your consent until the approved legal documents and versions are available.';

  @override
  String get consentDraftBanner =>
      'Draft preview only. These documents are placeholders, have not been approved by the bank or counsel, and cannot be accepted as live customer terms.';

  @override
  String get consentDraftVersion => 'Draft preview · not an approved document';

  @override
  String get consentDraftNotRecorded =>
      'Preview selections are not saved or sent to the API as consent.';

  @override
  String get consentContinuePreview => 'Continue in preview';

  @override
  String get consentTerms => 'I agree to the Terms and Conditions';

  @override
  String get consentPrivacy => 'I acknowledge the Privacy Notice';

  @override
  String get consentOptionalDataUse => 'Allow optional data use';

  @override
  String get consentOptionalDataUseHint =>
      'Optional and not required to continue. Draft wording only; no preference is stored.';

  @override
  String get termsDraftBody =>
      'CUSTOMER TERMS AND CONDITIONS — DRAFT PREVIEW ONLY\n\nThis placeholder is not an approved legal agreement. It must be replaced with terms approved by the bank and Nigerian legal counsel before customer acceptance.\n\nService description: the product handoff describes a mobile banking app. The provider identity, regulated service description, foundation-bank relationship and applicable terms have not been supplied.\n\nEligibility and verification: the onboarding screens request identity details. Minimum age, eligibility criteria and account-opening conditions remain unconfirmed.\n\nTransactions, limits and fees: approved fee schedules, limits, settlement and reversal terms have not been supplied.\n\nSecurity and support: customers should protect authentication credentials. The approved support contact, complaint process and customer liability terms have not been supplied.\n\nBefore live use, legal owners must provide the effective date, document version, legal entity, fees, limits, complaint details, governing law, dispute terms and approval record.';

  @override
  String get privacyDraftBody =>
      'PRIVACY NOTICE — DRAFT PREVIEW ONLY\n\nThis placeholder is not an approved privacy notice. The controller, purposes and legal bases, recipients, retention periods, transfer locations, contact details and rights-handling process have not been approved.\n\nInformation entered: onboarding asks for phone number, name, date of birth, email, BVN and NIN. The app sends OTP requests and identity numbers to the API configured for the app. The responsible controller and processor details are not identified in the handoff.\n\nCamera and biometrics: the selfie step is intended for identity matching. The provider, processing location, retention/deletion schedule and failed-match process have not been supplied.\n\nPrivacy rights and contact: the applicable rights, request process, controller privacy contact and complaint route must be supplied by the privacy/compliance owner.\n\nBefore live use, obtain approved controller details, purposes and legal bases, recipient categories, transfer locations, retention and deletion rules, biometric-data details, rights process, effective date, version and approval record.';

  @override
  String get consentDocumentUnavailable =>
      'Approved document is not available yet.';

  @override
  String get consentContinue => 'I agree and continue';

  @override
  String get bvnTitle => 'Verify your BVN';

  @override
  String get bvnHelper =>
      'We use your Bank Verification Number to verify your identity.';

  @override
  String get bvnFieldLabel => 'Bank Verification Number';

  @override
  String get bvnVerify => 'Verify BVN';

  @override
  String get ninTitle => 'Verify your NIN';

  @override
  String get ninHelper => 'Enter your 11-digit National Identification Number.';

  @override
  String get ninFieldLabel => 'National Identification Number';

  @override
  String get ninVerify => 'Verify NIN and continue';

  @override
  String get identityNumberHint =>
      'Enter 11 digits. Your number is sent securely for verification.';

  @override
  String get identityNumberInvalid => 'Enter a valid 11-digit number.';

  @override
  String get kycMismatch =>
      'Your details do not match. Check the number and try again.';

  @override
  String get kycUnavailable =>
      'We cannot verify your identity right now. Your progress is saved; try again later.';

  @override
  String get kycRejected =>
      'We could not verify your identity. Contact support for help with your application.';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginHelper =>
      'Sign in with your phone number or email and passcode.';

  @override
  String get loginIdentifier => 'Phone number or email';

  @override
  String get loginPasscodeLabel => 'Enter your 6-digit passcode';

  @override
  String get loginDeleteDigit => 'Delete last digit';

  @override
  String get loginSubmit => 'Log in';

  @override
  String get loginForgotPasscode => 'Forgot passcode?';

  @override
  String get loginInvalid => 'That passcode is not right.';

  @override
  String get loginLocked =>
      'Too many tries. Your account is locked for your safety.';

  @override
  String get loginNewDevice => 'Let’s verify this device.';

  @override
  String get loginDeviceVerificationRequired =>
      'Device verification needs to be completed before sign-in can continue.';

  @override
  String get loginVerifyDeviceAction => 'Verify device';

  @override
  String get resetPasscodeTitle => 'Reset your passcode';

  @override
  String get newDeviceTitle => 'Verify this device';

  @override
  String get flowNotReady =>
      'This secure verification step is not implemented yet. Sign-in cannot continue until it is available.';

  @override
  String get livenessTitle => 'Verify with a selfie';

  @override
  String get livenessHelper =>
      'Center your face, use good light, and remove hats or glasses. Follow the prompts while recording.';

  @override
  String get livenessGoodLighting => 'Good lighting';

  @override
  String get livenessNoHatOrGlasses => 'No hats or glasses';

  @override
  String get livenessNeutralExpression => 'Neutral expression';

  @override
  String get livenessPromptHeading => 'During the recording';

  @override
  String get livenessPromptBlink => 'Blink slowly once.';

  @override
  String get livenessPromptHeadTurn =>
      'Turn your head slowly to the left, then to the right.';

  @override
  String get livenessPrompts =>
      'Follow each instruction at a natural pace and keep your face inside the guide.';

  @override
  String get livenessStartCamera => 'Start camera';

  @override
  String get livenessStartCapture => 'Start selfie recording';

  @override
  String get livenessStopCapture => 'Finish recording';

  @override
  String get livenessRetake => 'Retake selfie';

  @override
  String get livenessNotVerified =>
      'Recording captured on this device. It has not been uploaded or verified.';

  @override
  String get livenessContractBlocker =>
      'Verification cannot finish until the liveness session and secure upload API are provided.';

  @override
  String get biometricSetupTitle => 'Unlock faster';

  @override
  String get biometricSetupHelper =>
      'Use fingerprint or face unlock for a quicker sign-in on this device.';

  @override
  String get biometricSetupPrivacy =>
      'Your biometric stays in your device\'s secure system. We save only your choice to enable this feature.';

  @override
  String get biometricSetupEnable => 'Enable biometrics';

  @override
  String get biometricSetupSkip => 'Not now';

  @override
  String get biometricSetupCancelled =>
      'Biometric setup was cancelled. You can try again or continue without it.';

  @override
  String get biometricSystemReason =>
      'Enable biometric unlock for future sign-in.';

  @override
  String get biometricLoginButton => 'Use biometrics';

  @override
  String get biometricLoginReason =>
      'Use your fingerprint or face to unlock your saved sign-in session.';

  @override
  String get biometricLoginCancelled =>
      'Biometric check was cancelled. Try again or enter your passcode.';

  @override
  String get biometricLoginSessionExpired =>
      'Your secure session has expired. Sign in with your passcode.';

  @override
  String get cameraPermissionDenied =>
      'Camera permission was denied. Allow camera access in your browser or device settings, then try again.';

  @override
  String get cameraUnavailable =>
      'No usable camera is available. Connect or enable a camera and try again.';

  @override
  String get cameraCaptureError =>
      'We could not capture the recording. Try again.';

  @override
  String get cameraPaused =>
      'Camera access stopped when the app was paused. Start the camera again to continue.';

  @override
  String get onboardingResumeUnsupported =>
      'Your code was verified, but the server returned a sign-up step this app cannot safely open. Your session is saved. Please contact support before trying again.';

  @override
  String get onboardingStatusUnavailable =>
      'We could not retrieve your saved sign-up status. Try again when you have a connection.';

  @override
  String get onboardingStepUnsupported =>
      'The server returned a sign-up step this app does not recognize. Your session is saved; setup cannot continue safely yet.';

  @override
  String get onboardingContinueSetup =>
      'Your saved sign-up step is ready to continue.';

  @override
  String get onboardingAccountPending =>
      'Your account is being set up. Check your status again later.';

  @override
  String get onboardingManualReview =>
      'Your identity check needs a manual review. Check your status again later.';

  @override
  String get onboardingRejected =>
      'We could not complete your sign-up. Contact support for help with your application.';

  @override
  String get onboardingAccountReady => 'Your account is ready';

  @override
  String get accountNumberLabel => 'Account number';

  @override
  String get onboardingCheckStatus => 'Check status';

  @override
  String get passcodeCreateTitle => 'Create your login passcode';

  @override
  String get passcodeCreateHelper =>
      'Choose a 6-digit passcode. Avoid repeated or sequential digits.';

  @override
  String get passcodeCreateField => '6-digit passcode';

  @override
  String get passcodeConfirm => 'Confirm passcode';

  @override
  String get passcodeWeak =>
      'Choose a passcode that is not repeated or sequential.';

  @override
  String get transactionPinTitle => 'Create your transaction PIN';

  @override
  String get transactionPinHelper =>
      'Choose a 4-digit PIN to approve money movements.';

  @override
  String get transactionPinField => '4-digit transaction PIN';

  @override
  String get transactionPinConfirm => 'Confirm transaction PIN';

  @override
  String get transactionPinDifferentNote =>
      'Keep your transaction PIN different from your login passcode.';

  @override
  String get credentialLengthInvalid => 'Enter all the required digits.';

  @override
  String get credentialMismatch => 'The entries do not match. Try again.';

  @override
  String get errorConfiguration =>
      'The service is not configured yet. Please try again later.';

  @override
  String get errorRateLimited => 'Please wait a moment before trying again.';

  @override
  String get errorOtpInvalid =>
      'That code is not right or has expired. Try again.';

  @override
  String get errorOffline =>
      'You are offline. Check your connection and try again.';

  @override
  String get errorUnexpected =>
      'We could not complete that request. Please try again.';

  @override
  String get accountDetailsTitle => 'Account details';

  @override
  String get accountNameLabel => 'Account name';

  @override
  String accountTierLabel(String tier) {
    return 'Tier $tier account';
  }

  @override
  String accountStatusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String get accountBankUnavailable => 'Bank name unavailable';

  @override
  String get accountBankUnavailableHelper =>
      'The account service has not supplied an approved bank name.';

  @override
  String accountLimitsTitle(String tier) {
    return 'Tier $tier limits and allowances';
  }

  @override
  String get accountDailyTransferLimit => 'Daily transfer limit';

  @override
  String accountDailyUsed(String amount) {
    return '$amount used today';
  }

  @override
  String accountDailyRemaining(String amount) {
    return '$amount remaining';
  }

  @override
  String get accountMaximumBalance => 'Maximum balance';

  @override
  String get accountSingleTransferMax => 'Single transfer max';

  @override
  String get accountCopyNumber => 'Copy account number';

  @override
  String get accountCopied => 'Account number copied';

  @override
  String get accountShareText => 'Share as text';

  @override
  String get accountShareImage => 'Share as image';

  @override
  String get accountShareTitle => 'Share account details';

  @override
  String get accountShareFailed =>
      'Could not open sharing. Try copying the account number instead.';

  @override
  String get accountNotProvided => 'Not provided';

  @override
  String get paymentsTitle => 'Payments';

  @override
  String get paymentsSearchHint => 'Search recipients or billers';

  @override
  String get paymentsSendMoney => 'Send money';

  @override
  String get paymentsSendBank => 'To bank account';

  @override
  String get paymentsSendBankSubtitle => 'Send to a Nigerian bank account';

  @override
  String get paymentsSendSaved => 'Send to saved';

  @override
  String get paymentsRequestMoney => 'Request money';

  @override
  String get paymentsRequestSubtitle => 'Create a payment request';

  @override
  String get paymentsScanPay => 'Scan and pay QR';

  @override
  String get paymentsAirtimeData => 'Airtime and data';

  @override
  String get paymentsBillsUtilities => 'Bills and utilities';

  @override
  String get paymentsElectricity => 'Electricity';

  @override
  String get paymentsInternetTv => 'Internet and TV';

  @override
  String get paymentsBetting => 'Betting';

  @override
  String get paymentsAllBills => 'All bills';

  @override
  String get paymentsScheduled => 'Scheduled payments';

  @override
  String get scheduledBackendPending =>
      'Scheduled payments are not connected yet. The API needs backend implementation and confirmation before live schedules, debits, or changes can be shown here.';

  @override
  String get scheduledCreate => 'Create new scheduled payment';

  @override
  String get scheduledUpcomingMonth => 'Upcoming this month';

  @override
  String scheduledActiveCount(int count) {
    return '$count Active';
  }

  @override
  String scheduledNextRun(String date) {
    return 'Next run: $date';
  }

  @override
  String get scheduledCalendar => 'Calendar';

  @override
  String get scheduledCalendarDemoToast =>
      'Calendar sync is not connected in this demo.';

  @override
  String scheduledActiveTab(int count) {
    return 'Active ($count)';
  }

  @override
  String scheduledPausedTab(int count) {
    return 'Paused ($count)';
  }

  @override
  String get scheduledCompletedTab => 'Completed';

  @override
  String get scheduledActiveStatus => 'Active';

  @override
  String get scheduledNextLabel => 'Next:';

  @override
  String get scheduledDebitNotice =>
      'Scheduled debits can only run after you authorize them. Keep enough funds available for the payment date; your bank may charge fees for failed mandates.';

  @override
  String get scheduledDemoNotice =>
      'DEMO DATA ONLY · You can try creating, editing, pausing, and cancelling fictional schedules. Changes last only while this preview is open; no real payment or API request is made.';

  @override
  String get scheduledDemoPaused => 'Water bill';

  @override
  String get scheduledDemoCompleted => 'School fees';

  @override
  String scheduledCompletedTabCount(int count) {
    return 'Completed ($count)';
  }

  @override
  String get scheduledPausedStatus => 'Paused';

  @override
  String get scheduledCompletedStatus => 'Completed';

  @override
  String get scheduledCancel => 'Cancel';

  @override
  String get scheduledEmpty => 'No schedules in this section.';

  @override
  String get scheduledNone => 'None';

  @override
  String get scheduledEditTitle => 'Edit scheduled payment';

  @override
  String get scheduledNameField => 'Payment name';

  @override
  String get scheduledAmountField => 'Amount';

  @override
  String get scheduledNameRequired =>
      'Enter a name for this scheduled payment.';

  @override
  String get scheduledAmountInvalid => 'Enter an amount greater than zero.';

  @override
  String get scheduledFrequencyField => 'Frequency';

  @override
  String get scheduledStartDate => 'Start date';

  @override
  String get scheduledOnce => 'Once';

  @override
  String get scheduledDaily => 'Daily';

  @override
  String get scheduledWeekly => 'Weekly';

  @override
  String get scheduledMonthly => 'Monthly';

  @override
  String get scheduledCancelTitle => 'Cancel scheduled payment?';

  @override
  String scheduledCancelPrompt(String name) {
    return 'Remove $name from this demo schedule list?';
  }

  @override
  String get scheduledLocalOnlyToast =>
      'Demo change saved locally for this preview only. No payment was made.';

  @override
  String get scheduledDemoElectricity => 'Ikeja Electric Mandate';

  @override
  String get scheduledMonthly28 => 'Monthly on the 28th';

  @override
  String get scheduledDemoFriday => 'Friday, 28 Oct';

  @override
  String get scheduledDemoRent => 'Amina Yusuf – Rent Support';

  @override
  String get scheduledWeeklyMonday => 'Weekly on Mondays';

  @override
  String get scheduledDemoMonday => 'Monday, 31 Oct';

  @override
  String get scheduledDemoInternet => 'Internet Subscription';

  @override
  String get scheduledMonthly1 => 'Monthly on the 1st';

  @override
  String get scheduledDemoNovember => '1 Nov';

  @override
  String get paymentsDuesLevies => 'Dues and levies';

  @override
  String get paymentsStage2 => 'Stage 2';

  @override
  String get paymentsSavedRecipients => 'Saved recipients';

  @override
  String get paymentsViewAll => 'View all';

  @override
  String get paymentsNoRecipients => 'No saved recipients yet.';

  @override
  String get paymentsRecipientsError => 'Saved recipients could not be loaded.';

  @override
  String get paymentsRecentTransfers => 'Recent transfers';

  @override
  String get paymentsTransactionHistory => 'History';

  @override
  String get paymentsNoTransfers => 'No recent transfers.';

  @override
  String get paymentsNewPayment => 'New payment';

  @override
  String get paymentsFeatureUnavailableTitle => 'Not available yet';

  @override
  String get paymentsFeatureUnavailable =>
      'This payment flow is not implemented yet. No payment has been made.';

  @override
  String get paymentsBankCatalogBlock =>
      'Bank selection is unavailable because the API contract does not provide a bank catalog. We will not guess bank names or codes.';

  @override
  String get paymentsHelpTooltip => 'Help and support';

  @override
  String get paymentsSearchEmpty =>
      'No matching payment options or recipients.';

  @override
  String get billSearchHint => 'Search biller, utility or service...';

  @override
  String get billFrequentTitle => 'Frequent billers';

  @override
  String get billQuickRevend => 'Quick re-vend';

  @override
  String get billCategoriesTitle => 'Categories';

  @override
  String billDemoCategoryCount(int count) {
    return '$count sectors (demo)';
  }

  @override
  String get billDemoNotice =>
      'DEMO DATA ONLY · These sample billers are fictional. Validation and payment are simulated locally; no payment request is sent.';

  @override
  String get billReceiptNotice =>
      'Instant value delivery depends on the biller. Demo receipts and tokens are not real.';

  @override
  String get billElectricity => 'Electricity';

  @override
  String get billElectricityDescription =>
      'Prepaid and postpaid electricity meters';

  @override
  String get billDemoDiscos => 'Sample discos';

  @override
  String get billCableInternet => 'Cable & Internet';

  @override
  String get billCableDescription => 'TV and internet subscriptions';

  @override
  String get billInstantRenewal => 'Demo billers';

  @override
  String get billWater => 'Utility & Water';

  @override
  String get billWaterDescription => 'Water boards and municipal services';

  @override
  String get billStateBoards => 'Sample providers';

  @override
  String get billGovernment => 'Govt & Dues';

  @override
  String get billGovernmentDescription => 'Government services and levies';

  @override
  String get billDirectPayments => 'Demo providers';

  @override
  String get billBetting => 'Betting & Gaming';

  @override
  String get billBettingDescription => 'Gaming wallet top-ups';

  @override
  String get billZeroCharges => 'Demo providers';

  @override
  String get billEducation => 'Education & Exams';

  @override
  String get billEducationDescription => 'Examination and education services';

  @override
  String get billPinDelivery => 'Demo providers';

  @override
  String get billCharity => 'Churches & Charity';

  @override
  String get billCharityDescription => 'Community donations and offerings';

  @override
  String get billDonations => 'Demo providers';

  @override
  String get billTransport => 'Toll & Transport';

  @override
  String get billTransportDescription => 'Toll and transit top-ups';

  @override
  String get billInstantTopup => 'Demo providers';

  @override
  String get billProviderDemo => 'Fictional provider · Demo only';

  @override
  String get billPrepaid => 'Prepaid (Token)';

  @override
  String get billPostpaid => 'Postpaid';

  @override
  String get billMeterNumber => 'Meter number';

  @override
  String get billCustomerReference => 'Customer reference';

  @override
  String get billValidate => 'Validate reference';

  @override
  String get billReferenceInvalid =>
      'The customer reference format is not valid.';

  @override
  String get billDemoValidated => 'DEMO REFERENCE VALIDATED';

  @override
  String get billFictionalName => 'Ada Demo Customer · fictional data';

  @override
  String get billAmount => 'Enter amount';

  @override
  String get billAmountInvalid => 'Enter an amount greater than zero.';

  @override
  String get billSaveBiller => 'Save this biller';

  @override
  String get billSchedulePayment => 'Schedule this payment';

  @override
  String get billContinue => 'Continue to payment';

  @override
  String get billNoMoneyNotice => 'Demo only. No payment will be made.';

  @override
  String get billConfirmTitle => 'Review demo payment';

  @override
  String billConfirmPrompt(String amount, String biller, String reference) {
    return 'Pay ₦$amount to $biller for reference $reference? This is a local demo only.';
  }

  @override
  String get billDemoPayAction => 'Complete demo';

  @override
  String get billDemoResultTitle => 'Demo complete';

  @override
  String get billDemoResultBody =>
      'This was a local simulation. No biller was contacted, no token was issued, and no money moved.';

  @override
  String get billDemoSavedBillerNote =>
      'In a live app this would save the biller; nothing was stored in this preview.';

  @override
  String get billDemoScheduleNote =>
      'In a live app this would start a scheduled-payment flow; no schedule was created here.';

  @override
  String get billCatalogLoadError =>
      'We could not load bill categories and providers.';

  @override
  String get billCatalogEmpty => 'No bill categories match your search.';

  @override
  String billBillerCount(int count) {
    return '$count providers';
  }

  @override
  String get billSavedBillers => 'Saved billers';

  @override
  String get billSavedLoadError => 'We could not load saved billers.';

  @override
  String get billSavedEmpty => 'Your saved billers will appear here.';

  @override
  String get billBillerSelection => 'Choose a provider';

  @override
  String get billNoProviders =>
      'No providers are currently available for this category.';

  @override
  String get billPaymentTitle => 'Pay bill';

  @override
  String get billProductUnavailable =>
      'This biller or product is no longer available. Return to categories and choose another.';

  @override
  String get billHelpText =>
      'Choose a provider and product, validate the customer reference, then review the amount before authorizing with your transaction PIN.';

  @override
  String get billReferenceRequired => 'Enter the customer reference.';

  @override
  String get billValidationError =>
      'We could not validate this bill reference. Check it and try again.';

  @override
  String get billValidateFirst =>
      'Validate the customer reference before continuing.';

  @override
  String get billValidationExpired =>
      'This validation expired. Validate the customer reference again.';

  @override
  String billValidationExpires(String date) {
    return 'Validation expires at $date.';
  }

  @override
  String get billDeliveryPhone => 'Token delivery phone (optional)';

  @override
  String get billDeliveryPhoneHelper =>
      'A prepaid token is shown only after the provider confirms delivery.';

  @override
  String get billAmountHelper => 'Enter the amount supplied by your biller.';

  @override
  String get billFixedAmount => 'Provider-set amount';

  @override
  String billAmountRange(String minimum, String maximum) {
    return 'Allowed amount: $minimum to $maximum';
  }

  @override
  String get billAmountBelowMinimum =>
      'The amount is below the minimum set by the provider.';

  @override
  String get billAmountAboveMaximum =>
      'The amount exceeds the maximum set by the provider.';

  @override
  String billLiveConfirmPrompt(String amount, String biller) {
    return 'Pay $amount to $biller? Review the provider and amount before authorizing.';
  }

  @override
  String get billPaymentError =>
      'We could not confirm the bill payment result. Check transaction history before retrying.';

  @override
  String get billPinVerificationError =>
      'We could not verify your transaction PIN. Check it and try again.';

  @override
  String get billResultPendingTitle => 'Payment processing';

  @override
  String get billResultPending =>
      'The biller is still processing this request. Check transaction history for the final status.';

  @override
  String get billResultSuccessTitle => 'Payment successful';

  @override
  String get billResultSuccess => 'The biller confirmed this payment.';

  @override
  String get billResultFailedTitle => 'Payment not completed';

  @override
  String get billResultFailed =>
      'The biller did not confirm this payment. Check your account and transaction history for updates.';

  @override
  String get billResultRefunded =>
      'The biller did not complete the vend. The refund is confirmed.';

  @override
  String get billResultReviewTitle => 'Check payment status';

  @override
  String get billDoNotRetry =>
      'The provider or refund status is unresolved. Do not start another payment for this bill yet. Check transaction history or contact support.';

  @override
  String get billTokenDeliveryFailed =>
      'The bill was charged, but the prepaid token was not confirmed as delivered. Do not pay again; check transaction history or contact support.';

  @override
  String get billRefundFailed =>
      'The biller did not complete the vend and the refund is not confirmed. Do not retry; check transaction history or contact support.';

  @override
  String get billVendToken => 'Vend token';

  @override
  String get commonClose => 'Close';

  @override
  String get paymentsClearSearch => 'Clear search';

  @override
  String get paymentsRecipientFallback => 'Saved recipient';

  @override
  String get paymentsBeneficiarySearch =>
      'Search name, bank, or account number';

  @override
  String get paymentsRecipientDeleteAction => 'Delete saved recipient';

  @override
  String get paymentsRecipientDeleteTitle => 'Delete saved recipient?';

  @override
  String get paymentsRecipientDeletePrompt =>
      'This removes the recipient from your saved list. It does not affect past payments.';

  @override
  String get paymentsRecipientDeleted => 'Saved recipient deleted.';

  @override
  String get paymentsRecipientDeleteError =>
      'We could not delete this recipient. Try again.';

  @override
  String get paymentsRecipientDeleteUnavailable =>
      'This saved recipient has no ID, so it cannot be deleted.';

  @override
  String get limitsTitle => 'Account limits';

  @override
  String get limitsInfoTitle => 'About these limits';

  @override
  String get limitsInfoBody =>
      'These values come from your account service. Daily usage is shown only when reported by the API.';

  @override
  String get limitsTierStatus => 'Your account tier';

  @override
  String get limitsTierUnavailable => 'Tier information unavailable';

  @override
  String limitsCurrentTier(String tier) {
    return 'Tier $tier';
  }

  @override
  String get limitsDailyTransfer => 'Daily outgoing limit';

  @override
  String get limitsUnavailable => 'Unavailable';

  @override
  String get limitsUsageUnavailable =>
      'Daily usage is not available from the account service.';

  @override
  String limitsDailyUsage(String used, String remaining) {
    return '$used used · $remaining remaining';
  }

  @override
  String get limitsSingleTransfer => 'Single transfer limit';

  @override
  String get limitsSingleTransferDescription =>
      'Maximum outgoing amount per transaction, as returned for this account.';

  @override
  String get limitsBalanceCap => 'Account balance ceiling';

  @override
  String get limitsBalanceUsageUnavailable =>
      'Balance usage is not available from the account service.';

  @override
  String limitsBalanceUsage(String balance, String percent) {
    return 'Ledger balance $balance · $percent% of ceiling';
  }

  @override
  String get limitsUpgradeTitle => 'Need a higher limit?';

  @override
  String get limitsUpgradeBody =>
      'Your tier and current account limits are shown here. Upgrade options will be available when the bank enables the required verification flow.';

  @override
  String get limitsUpgradeAction => 'Check upgrade options';

  @override
  String get limitsUpgradeUnavailable =>
      'The current API does not define the KYC requirements, document upload, or submission flow needed to request a tier upgrade.';

  @override
  String get statementsTitle => 'Account statements';

  @override
  String get statementsIntro =>
      'Request a PDF statement for this account. Your selected range is checked against the maximum period configured by the bank.';

  @override
  String get statementsDateRange => 'Date range';

  @override
  String statementsSelectedDays(String days) {
    return '$days days selected';
  }

  @override
  String get statementsLast30Days => 'Last 30 days';

  @override
  String get statementsLast90Days => 'Last 90 days';

  @override
  String get statementsLast180Days => 'Last 180 days';

  @override
  String get statementsCustomRange => 'Custom';

  @override
  String get statementsChooseRange => 'Choose statement period';

  @override
  String get statementsFrom => 'From';

  @override
  String get statementsTo => 'To';

  @override
  String get statementsPdfOnly => 'PDF statement';

  @override
  String statementsEmailTo(String email) {
    return 'Email to registered address: $email';
  }

  @override
  String get statementsEmailUnavailable =>
      'Email delivery is unavailable for this account.';

  @override
  String get statementsEmailStatusUnavailable =>
      'Registered email availability has not loaded.';

  @override
  String get statementsOptionsLoading =>
      'Loading account statement options and recent requests.';

  @override
  String get statementsHistoryUnavailable =>
      'Request history is unavailable until the statement service responds.';

  @override
  String get statementsDownloadAction => 'Generate and download PDF';

  @override
  String get statementsEmailAction => 'Generate and email PDF';

  @override
  String get statementsHistory => 'Past statement requests';

  @override
  String get statementsHistoryEmpty => 'You have no past statement requests.';

  @override
  String get statementsLoadError =>
      'We could not load statement options and request history. Try again later.';

  @override
  String statementsRangeTooLarge(String days, String maximum) {
    return 'This range is $days days. The maximum allowed range is $maximum days. Choose a shorter period.';
  }

  @override
  String get statementsRequestError =>
      'We could not submit the statement request. Check your connection and try again.';

  @override
  String get statementsDownloadError =>
      'We could not download this statement. Try again when it is ready.';

  @override
  String get statementsDownloadTitle => 'Account statement PDF';

  @override
  String get statementsRequestFailed =>
      'Statement generation failed. You can submit a new request.';

  @override
  String get statementsEmailSent =>
      'Statement generated and sent to your registered email.';

  @override
  String get statementsEmailPending =>
      'Statement is ready; delivery to your registered email is pending.';

  @override
  String get statementsEmailFailed =>
      'Statement generated, but email delivery failed. You can download it from the request history.';

  @override
  String get statementsGenerated =>
      'Statement generated and ready to download.';

  @override
  String get statementsDeliveryEmail => 'Email';

  @override
  String get statementsDeliveryDownload => 'Download';

  @override
  String get statementsStatusQueued => 'Queued';

  @override
  String get statementsStatusGenerating => 'Generating';

  @override
  String get statementsStatusReady => 'Ready';

  @override
  String get statementsStatusFailed => 'Failed';
}
