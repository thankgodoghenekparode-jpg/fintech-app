import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'YourApp'**
  String get appTitle;

  /// No description provided for @brandInitial.
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get brandInitial;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get navPayments;

  /// No description provided for @navCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get navCards;

  /// No description provided for @navSaveBorrow.
  ///
  /// In en, this message translates to:
  /// **'Save & Borrow'**
  String get navSaveBorrow;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @homeGreetingName.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String homeGreetingName(String name);

  /// No description provided for @homeGreetingGeneric.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeGreetingGeneric;

  /// No description provided for @homeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get homeNotifications;

  /// No description provided for @moreAccountPreferences.
  ///
  /// In en, this message translates to:
  /// **'Account & preferences'**
  String get moreAccountPreferences;

  /// No description provided for @moreProfileKyc.
  ///
  /// In en, this message translates to:
  /// **'Profile & account details'**
  String get moreProfileKyc;

  /// No description provided for @moreProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your account name, number and tier'**
  String get moreProfileSubtitle;

  /// No description provided for @moreLimits.
  ///
  /// In en, this message translates to:
  /// **'Account limits & allowances'**
  String get moreLimits;

  /// No description provided for @moreLimitsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Limits are not available from your account yet'**
  String get moreLimitsUnavailable;

  /// No description provided for @moreDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily {amount}'**
  String moreDailyLimit(String amount);

  /// No description provided for @moreSingleLimit.
  ///
  /// In en, this message translates to:
  /// **'Per transfer {amount}'**
  String moreSingleLimit(String amount);

  /// No description provided for @moreStatements.
  ///
  /// In en, this message translates to:
  /// **'Statements & reports'**
  String get moreStatements;

  /// No description provided for @moreStatementsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request or download account statements'**
  String get moreStatementsSubtitle;

  /// No description provided for @moreSecurityControl.
  ///
  /// In en, this message translates to:
  /// **'Security & control'**
  String get moreSecurityControl;

  /// No description provided for @moreNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account alerts and transaction updates'**
  String get moreNotificationsSubtitle;

  /// No description provided for @moreCards.
  ///
  /// In en, this message translates to:
  /// **'Card management'**
  String get moreCards;

  /// No description provided for @moreCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View, freeze and manage your cards'**
  String get moreCardsSubtitle;

  /// No description provided for @moreSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security hub'**
  String get moreSecurity;

  /// No description provided for @moreSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Passcode, transaction PIN and account controls'**
  String get moreSecuritySubtitle;

  /// No description provided for @moreSecurityBlocked.
  ///
  /// In en, this message translates to:
  /// **'Security settings need approved change-passcode and change-PIN flows. These operations are not defined by the current API contract.'**
  String get moreSecurityBlocked;

  /// No description provided for @moreDevices.
  ///
  /// In en, this message translates to:
  /// **'Linked devices'**
  String get moreDevices;

  /// No description provided for @moreDevicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review active sessions on your account'**
  String get moreDevicesSubtitle;

  /// No description provided for @moreDevicesBlocked.
  ///
  /// In en, this message translates to:
  /// **'The API lists device operations but does not define the device response fields or current-device behavior. Device management is not available yet.'**
  String get moreDevicesBlocked;

  /// No description provided for @moreSupportLegal.
  ///
  /// In en, this message translates to:
  /// **'Payments, support & legal'**
  String get moreSupportLegal;

  /// No description provided for @morePaymentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transfers, beneficiaries and bill payments'**
  String get morePaymentsSubtitle;

  /// No description provided for @moreHelp.
  ///
  /// In en, this message translates to:
  /// **'Help centre & support'**
  String get moreHelp;

  /// No description provided for @moreHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help with your account and transactions'**
  String get moreHelpSubtitle;

  /// No description provided for @moreLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal, terms & privacy'**
  String get moreLegal;

  /// No description provided for @moreLegalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read legal drafts and review consent status'**
  String get moreLegalSubtitle;

  /// No description provided for @moreLegalBlocked.
  ///
  /// In en, this message translates to:
  /// **'Approved Terms and Privacy documents and version identifiers have not been supplied. Draft legal text must not be presented as approved policy.'**
  String get moreLegalBlocked;

  /// No description provided for @helpCentreTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpCentreTitle;

  /// No description provided for @helpCentreQuestion.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get helpCentreQuestion;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search guides and topics'**
  String get helpSearchHint;

  /// No description provided for @helpPopularTopics.
  ///
  /// In en, this message translates to:
  /// **'Popular topics'**
  String get helpPopularTopics;

  /// No description provided for @helpTopicAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get helpTopicAll;

  /// No description provided for @helpTopicTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get helpTopicTransfers;

  /// No description provided for @helpTopicCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get helpTopicCards;

  /// No description provided for @helpTopicAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get helpTopicAccount;

  /// No description provided for @helpTopicBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get helpTopicBills;

  /// No description provided for @helpTopicOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get helpTopicOther;

  /// No description provided for @helpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get helpFaqTitle;

  /// No description provided for @helpNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching help articles. You can file a support ticket.'**
  String get helpNoResults;

  /// No description provided for @helpStillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get helpStillNeedHelp;

  /// No description provided for @helpStartChat.
  ///
  /// In en, this message translates to:
  /// **'Start a support conversation'**
  String get helpStartChat;

  /// No description provided for @helpTicketDescription.
  ///
  /// In en, this message translates to:
  /// **'Send a message to the support team and track your ticket here.'**
  String get helpTicketDescription;

  /// No description provided for @helpFileTicket.
  ///
  /// In en, this message translates to:
  /// **'File a support ticket'**
  String get helpFileTicket;

  /// No description provided for @helpTrackTickets.
  ///
  /// In en, this message translates to:
  /// **'Track my tickets'**
  String get helpTrackTickets;

  /// No description provided for @helpEscalationTitle.
  ///
  /// In en, this message translates to:
  /// **'Escalation information'**
  String get helpEscalationTitle;

  /// No description provided for @helpEscalationBody.
  ///
  /// In en, this message translates to:
  /// **'Approved regulator escalation instructions and response timelines have not been supplied. Contact details will appear here when confirmed.'**
  String get helpEscalationBody;

  /// No description provided for @helpContentNote.
  ///
  /// In en, this message translates to:
  /// **'Help articles describe current app behavior. Do not share your passcode, transaction PIN or one-time password in a ticket.'**
  String get helpContentNote;

  /// No description provided for @helpTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Check a transfer status'**
  String get helpTransferTitle;

  /// No description provided for @helpTransferBody.
  ///
  /// In en, this message translates to:
  /// **'Open Payments or transaction history and select the transfer to view its current status and available details. If the transfer needs investigation, file a ticket and include its transaction reference. Avoid repeating a transfer while its status is pending.'**
  String get helpTransferBody;

  /// No description provided for @helpViewHistory.
  ///
  /// In en, this message translates to:
  /// **'View transaction history'**
  String get helpViewHistory;

  /// No description provided for @helpCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Freeze or manage a card'**
  String get helpCardTitle;

  /// No description provided for @helpCardBody.
  ///
  /// In en, this message translates to:
  /// **'Open Cards, select the card, and use the available card controls. Card settings and sensitive details depend on your bank\'s enabled services and device security support.'**
  String get helpCardBody;

  /// No description provided for @helpAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your account details'**
  String get helpAccountTitle;

  /// No description provided for @helpAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Open Add money or Account details to view the account name and number returned by your bank. The app does not display a bank name unless the API provides it.'**
  String get helpAccountBody;

  /// No description provided for @helpBillsTitle.
  ///
  /// In en, this message translates to:
  /// **'A bill payment is pending'**
  String get helpBillsTitle;

  /// No description provided for @helpBillsBody.
  ///
  /// In en, this message translates to:
  /// **'Check the payment result and transaction status in the bill flow. If the result is pending, do not submit the same payment again; use a support ticket if you need help investigating it.'**
  String get helpBillsBody;

  /// No description provided for @notificationsTickets.
  ///
  /// In en, this message translates to:
  /// **'Support tickets'**
  String get notificationsTickets;

  /// No description provided for @ticketsActive.
  ///
  /// In en, this message translates to:
  /// **'Active tickets'**
  String get ticketsActive;

  /// No description provided for @ticketsResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get ticketsResolved;

  /// No description provided for @ticketsEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no tickets in this list.'**
  String get ticketsEmpty;

  /// No description provided for @ticketsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your support tickets.'**
  String get ticketsLoadError;

  /// No description provided for @ticketNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New support ticket'**
  String get ticketNewTitle;

  /// No description provided for @ticketCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get ticketCategory;

  /// No description provided for @ticketDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get ticketDescription;

  /// No description provided for @ticketDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Include what happened and the transaction reference if relevant. Do not include passwords, PINs or one-time codes.'**
  String get ticketDescriptionHint;

  /// No description provided for @ticketDescriptionValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a message with no more than 4,000 characters.'**
  String get ticketDescriptionValidation;

  /// No description provided for @ticketSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit ticket'**
  String get ticketSubmit;

  /// No description provided for @ticketSubmitError.
  ///
  /// In en, this message translates to:
  /// **'We could not submit your ticket. Please try again.'**
  String get ticketSubmitError;

  /// No description provided for @ticketLinkedTransaction.
  ///
  /// In en, this message translates to:
  /// **'Linked transaction'**
  String get ticketLinkedTransaction;

  /// No description provided for @ticketNoAttachmentNotice.
  ///
  /// In en, this message translates to:
  /// **'Attachments are not supported by the current ticket API.'**
  String get ticketNoAttachmentNotice;

  /// No description provided for @ticketDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Ticket conversation'**
  String get ticketDetailTitle;

  /// No description provided for @ticketNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages have been added yet.'**
  String get ticketNoMessages;

  /// No description provided for @ticketReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Write a reply'**
  String get ticketReplyHint;

  /// No description provided for @ticketSendReply.
  ///
  /// In en, this message translates to:
  /// **'Send reply'**
  String get ticketSendReply;

  /// No description provided for @ticketReplyError.
  ///
  /// In en, this message translates to:
  /// **'We could not send your reply. Try again.'**
  String get ticketReplyError;

  /// No description provided for @ticketYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get ticketYou;

  /// No description provided for @ticketSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get ticketSupport;

  /// No description provided for @supportChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Support chat'**
  String get supportChatTitle;

  /// No description provided for @supportChatTeam.
  ///
  /// In en, this message translates to:
  /// **'Support team'**
  String get supportChatTeam;

  /// No description provided for @supportChatAsyncNotice.
  ///
  /// In en, this message translates to:
  /// **'Replies use the support ticket service and are handled asynchronously. Agent availability and response times are not provided.'**
  String get supportChatAsyncNotice;

  /// No description provided for @supportChatMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message support'**
  String get supportChatMessageLabel;

  /// No description provided for @supportChatMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Describe how we can help. Do not share passwords, PINs or one-time codes.'**
  String get supportChatMessageHint;

  /// No description provided for @supportChatStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start conversation'**
  String get supportChatStartButton;

  /// No description provided for @supportChatRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh conversation'**
  String get supportChatRefresh;

  /// No description provided for @supportChatReplyError.
  ///
  /// In en, this message translates to:
  /// **'We could not send this message. It remains in the text box so you can retry. No offline queue is available.'**
  String get supportChatReplyError;

  /// No description provided for @supportChatLinkedTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction {id}'**
  String supportChatLinkedTransaction(String id);

  /// No description provided for @ticketStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get ticketStatusOpen;

  /// No description provided for @ticketStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get ticketStatusInProgress;

  /// No description provided for @ticketStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get ticketStatusResolved;

  /// No description provided for @ticketStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get ticketStatusClosed;

  /// No description provided for @ticketStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Status unavailable'**
  String get ticketStatusUnknown;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get commonUnavailable;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get reportTitle;

  /// No description provided for @reportSelectIssue.
  ///
  /// In en, this message translates to:
  /// **'Select issue category'**
  String get reportSelectIssue;

  /// No description provided for @reportRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get reportRequired;

  /// No description provided for @reportReasonNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Not received'**
  String get reportReasonNotReceived;

  /// No description provided for @reportReasonChargedFailed.
  ///
  /// In en, this message translates to:
  /// **'Charged but failed'**
  String get reportReasonChargedFailed;

  /// No description provided for @reportReasonWrongAmount.
  ///
  /// In en, this message translates to:
  /// **'Wrong amount'**
  String get reportReasonWrongAmount;

  /// No description provided for @reportReasonUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorised'**
  String get reportReasonUnauthorized;

  /// No description provided for @reportReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportReasonOther;

  /// No description provided for @reportAffectedTransaction.
  ///
  /// In en, this message translates to:
  /// **'Affected transaction'**
  String get reportAffectedTransaction;

  /// No description provided for @reportDescribe.
  ///
  /// In en, this message translates to:
  /// **'Describe what happened'**
  String get reportDescribe;

  /// No description provided for @reportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add details that will help the support team investigate.'**
  String get reportDescriptionHint;

  /// No description provided for @reportIncludeReference.
  ///
  /// In en, this message translates to:
  /// **'Include relevant details. Never include your PIN, passcode or one-time password.'**
  String get reportIncludeReference;

  /// No description provided for @reportAttachmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Screenshots or proof'**
  String get reportAttachmentsTitle;

  /// No description provided for @reportAttachmentsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Attachments are not supported by the current ticket API. You can describe the evidence in your report.'**
  String get reportAttachmentsUnavailable;

  /// No description provided for @reportPrivacyReminder.
  ///
  /// In en, this message translates to:
  /// **'Your report will be linked to this transaction. Do not include full card details, passwords, PINs or one-time codes.'**
  String get reportPrivacyReminder;

  /// No description provided for @reportNoSla.
  ///
  /// In en, this message translates to:
  /// **'Your ticket status and replies will be available in Support tickets. No response time is promised here.'**
  String get reportNoSla;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit dispute ticket'**
  String get reportSubmit;

  /// No description provided for @reportSelectReason.
  ///
  /// In en, this message translates to:
  /// **'Select an issue category to continue.'**
  String get reportSelectReason;

  /// No description provided for @reportDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue before submitting.'**
  String get reportDescriptionRequired;

  /// No description provided for @reportSubmitError.
  ///
  /// In en, this message translates to:
  /// **'We could not submit this report. Please try again.'**
  String get reportSubmitError;

  /// No description provided for @reportDemoPreviewNotice.
  ///
  /// In en, this message translates to:
  /// **'DEMO PREVIEW · Sample transaction only. This will not create a real support ticket.'**
  String get reportDemoPreviewNotice;

  /// No description provided for @reportDemoPreviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Preview only. No support ticket was submitted.'**
  String get reportDemoPreviewSubmitted;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsAll;

  /// No description provided for @notificationsTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get notificationsTransactions;

  /// No description provided for @notificationsSecuritySystem.
  ///
  /// In en, this message translates to:
  /// **'Security & System'**
  String get notificationsSecuritySystem;

  /// No description provided for @notificationsRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent updates'**
  String get notificationsRecent;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String notificationsUnread(int count);

  /// No description provided for @notificationsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationsToday;

  /// No description provided for @notificationsEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notificationsEarlier;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'New alerts and account updates will appear here.'**
  String get notificationsEmptyBody;

  /// No description provided for @notificationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your notifications.'**
  String get notificationsLoadError;

  /// No description provided for @notificationsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'We could not update this notification. Try again.'**
  String get notificationsUpdateError;

  /// No description provided for @notificationsAllRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read.'**
  String get notificationsAllRead;

  /// No description provided for @homeAvailableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get homeAvailableBalance;

  /// No description provided for @homeLedgerBalance.
  ///
  /// In en, this message translates to:
  /// **'Ledger balance'**
  String get homeLedgerBalance;

  /// No description provided for @homeAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get homeAccountNumber;

  /// No description provided for @homeTier.
  ///
  /// In en, this message translates to:
  /// **'Tier {tier}'**
  String homeTier(String tier);

  /// No description provided for @homeCopyAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Copy account number'**
  String get homeCopyAccountNumber;

  /// No description provided for @homeAccountNumberCopied.
  ///
  /// In en, this message translates to:
  /// **'Account number copied'**
  String get homeAccountNumberCopied;

  /// No description provided for @homeBalanceHidden.
  ///
  /// In en, this message translates to:
  /// **'Balance hidden'**
  String get homeBalanceHidden;

  /// No description provided for @homeHideBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide balance'**
  String get homeHideBalance;

  /// No description provided for @homeShowBalance.
  ///
  /// In en, this message translates to:
  /// **'Show balance'**
  String get homeShowBalance;

  /// No description provided for @homeBalanceCap.
  ///
  /// In en, this message translates to:
  /// **'Balance cap {amount}'**
  String homeBalanceCap(String amount);

  /// No description provided for @homeQuickSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get homeQuickSend;

  /// No description provided for @homeQuickBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get homeQuickBills;

  /// No description provided for @homeQuickAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get homeQuickAddMoney;

  /// No description provided for @fundingTitle.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get fundingTitle;

  /// No description provided for @fundingHelp.
  ///
  /// In en, this message translates to:
  /// **'How to add money'**
  String get fundingHelp;

  /// No description provided for @fundingHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Send a bank transfer from another Nigerian bank to the account number shown here. Use the account name shown by your sending bank to confirm the recipient before sending.'**
  String get fundingHelpBody;

  /// No description provided for @fundingRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get fundingRecommended;

  /// No description provided for @fundingRealTime.
  ///
  /// In en, this message translates to:
  /// **'Real time'**
  String get fundingRealTime;

  /// No description provided for @fundingBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get fundingBankTransfer;

  /// No description provided for @fundingTransferSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive a transfer from any bank'**
  String get fundingTransferSubtitle;

  /// No description provided for @fundingNumberUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Your account number is not available right now.'**
  String get fundingNumberUnavailable;

  /// No description provided for @fundingCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get fundingCopy;

  /// No description provided for @fundingCopied.
  ///
  /// In en, this message translates to:
  /// **'Account number copied'**
  String get fundingCopied;

  /// No description provided for @fundingTransferInstructions.
  ///
  /// In en, this message translates to:
  /// **'Transfer any amount from another Nigerian bank app or USSD to this account number. The funds are credited to your account in real time.'**
  String get fundingTransferInstructions;

  /// No description provided for @fundingShare.
  ///
  /// In en, this message translates to:
  /// **'Share account details'**
  String get fundingShare;

  /// No description provided for @fundingDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'DEMO PREVIEW · Sample account details only. No funds will be received.'**
  String get fundingDemoNotice;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @homeQuickCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get homeQuickCards;

  /// No description provided for @homeQuickSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get homeQuickSavings;

  /// No description provided for @homeCards.
  ///
  /// In en, this message translates to:
  /// **'My cards'**
  String get homeCards;

  /// No description provided for @homeManageCards.
  ///
  /// In en, this message translates to:
  /// **'Manage cards ({count})'**
  String homeManageCards(int count);

  /// No description provided for @homeCreateCard.
  ///
  /// In en, this message translates to:
  /// **'Create card'**
  String get homeCreateCard;

  /// No description provided for @homeNoCards.
  ///
  /// In en, this message translates to:
  /// **'You do not have a virtual card yet.'**
  String get homeNoCards;

  /// No description provided for @homeRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get homeRecentActivity;

  /// No description provided for @historySearch.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get historySearch;

  /// No description provided for @historyDateRange.
  ///
  /// In en, this message translates to:
  /// **'Choose date range'**
  String get historyDateRange;

  /// No description provided for @historyAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get historyAllTypes;

  /// No description provided for @historyAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get historyAllStatuses;

  /// No description provided for @historyPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get historyPending;

  /// No description provided for @historySuccessful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get historySuccessful;

  /// No description provided for @historyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get historyFailed;

  /// No description provided for @historyReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get historyReversed;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transactions match your search.'**
  String get historyEmpty;

  /// No description provided for @historyExport.
  ///
  /// In en, this message translates to:
  /// **'Export statement'**
  String get historyExport;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeBeneficiaries.
  ///
  /// In en, this message translates to:
  /// **'Beneficiaries'**
  String get homeBeneficiaries;

  /// No description provided for @homeNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'Your recent activity will appear here.'**
  String get homeNoTransactions;

  /// No description provided for @homeTransactionGeneric.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get homeTransactionGeneric;

  /// No description provided for @homeRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get homeRetry;

  /// No description provided for @homeFeatureNotReady.
  ///
  /// In en, this message translates to:
  /// **'This feature is not connected yet. Please check back later.'**
  String get homeFeatureNotReady;

  /// No description provided for @homeAccountLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your account balance.'**
  String get homeAccountLoadError;

  /// No description provided for @homeTransactionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load recent activity.'**
  String get homeTransactionsLoadError;

  /// No description provided for @homeCardsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your cards.'**
  String get homeCardsLoadError;

  /// No description provided for @cardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cardsTitle;

  /// No description provided for @cardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your virtual cards.'**
  String get cardsSubtitle;

  /// No description provided for @cardsVirtualCard.
  ///
  /// In en, this message translates to:
  /// **'Virtual card'**
  String get cardsVirtualCard;

  /// No description provided for @cardsVirtualNaira.
  ///
  /// In en, this message translates to:
  /// **'VIRTUAL · NAIRA'**
  String get cardsVirtualNaira;

  /// No description provided for @cardsDetailsAction.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get cardsDetailsAction;

  /// No description provided for @cardsCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create virtual card'**
  String get cardsCreateAction;

  /// No description provided for @cardsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No cards yet'**
  String get cardsEmptyTitle;

  /// No description provided for @cardsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a virtual card for online payments.'**
  String get cardsEmptyBody;

  /// No description provided for @cardsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your cards.'**
  String get cardsLoadError;

  /// No description provided for @cardsPreviewNotice.
  ///
  /// In en, this message translates to:
  /// **'UI preview only. These sample cards are not connected to a bank account and do not represent real card data.'**
  String get cardsPreviewNotice;

  /// No description provided for @welcomePreviewCards.
  ///
  /// In en, this message translates to:
  /// **'Preview cards UI'**
  String get welcomePreviewCards;

  /// No description provided for @cardStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get cardStatusActive;

  /// No description provided for @cardStatusFrozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get cardStatusFrozen;

  /// No description provided for @cardStatusCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating'**
  String get cardStatusCreating;

  /// No description provided for @cardStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get cardStatusExpired;

  /// No description provided for @cardStatusDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get cardStatusDeleted;

  /// No description provided for @cardStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Status unavailable'**
  String get cardStatusUnknown;

  /// No description provided for @cardFreezeTitle.
  ///
  /// In en, this message translates to:
  /// **'Freeze this card?'**
  String get cardFreezeTitle;

  /// No description provided for @cardUnfreezeTitle.
  ///
  /// In en, this message translates to:
  /// **'Unfreeze this card?'**
  String get cardUnfreezeTitle;

  /// No description provided for @cardFreezePrompt.
  ///
  /// In en, this message translates to:
  /// **'New transactions on this card will be declined while it is frozen.'**
  String get cardFreezePrompt;

  /// No description provided for @cardUnfreezePrompt.
  ///
  /// In en, this message translates to:
  /// **'This card will be available for transactions again.'**
  String get cardUnfreezePrompt;

  /// No description provided for @cardFreezeAction.
  ///
  /// In en, this message translates to:
  /// **'Freeze'**
  String get cardFreezeAction;

  /// No description provided for @cardUnfreezeAction.
  ///
  /// In en, this message translates to:
  /// **'Unfreeze'**
  String get cardUnfreezeAction;

  /// No description provided for @cardFrozen.
  ///
  /// In en, this message translates to:
  /// **'Card frozen.'**
  String get cardFrozen;

  /// No description provided for @cardUnfrozen.
  ///
  /// In en, this message translates to:
  /// **'Card unfrozen.'**
  String get cardUnfrozen;

  /// No description provided for @cardUpdateError.
  ///
  /// In en, this message translates to:
  /// **'We could not update this card. Try again.'**
  String get cardUpdateError;

  /// No description provided for @cardCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create virtual card'**
  String get cardCreateTitle;

  /// No description provided for @cardLabelField.
  ///
  /// In en, this message translates to:
  /// **'Card name'**
  String get cardLabelField;

  /// No description provided for @cardLabelHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose a name up to 30 characters.'**
  String get cardLabelHelper;

  /// No description provided for @cardLabelRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for this card.'**
  String get cardLabelRequired;

  /// No description provided for @cardThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a card theme'**
  String get cardThemeTitle;

  /// No description provided for @cardThemeBerry.
  ///
  /// In en, this message translates to:
  /// **'Berry'**
  String get cardThemeBerry;

  /// No description provided for @cardThemeMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get cardThemeMidnight;

  /// No description provided for @cardThemeCoral.
  ///
  /// In en, this message translates to:
  /// **'Coral'**
  String get cardThemeCoral;

  /// No description provided for @cardThemeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get cardThemeForest;

  /// No description provided for @cardThemeSand.
  ///
  /// In en, this message translates to:
  /// **'Sand'**
  String get cardThemeSand;

  /// No description provided for @cardThemeSlate.
  ///
  /// In en, this message translates to:
  /// **'Slate'**
  String get cardThemeSlate;

  /// No description provided for @cardDailyLimitField.
  ///
  /// In en, this message translates to:
  /// **'Optional daily spend limit'**
  String get cardDailyLimitField;

  /// No description provided for @cardDailyLimitHelper.
  ///
  /// In en, this message translates to:
  /// **'Leave blank if you do not want a card-specific daily limit.'**
  String get cardDailyLimitHelper;

  /// No description provided for @cardLimitMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get cardLimitMustBePositive;

  /// No description provided for @cardCreateWithPin.
  ///
  /// In en, this message translates to:
  /// **'Review and create'**
  String get cardCreateWithPin;

  /// No description provided for @cardCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your virtual card was created.'**
  String get cardCreateSuccess;

  /// No description provided for @cardCreateError.
  ///
  /// In en, this message translates to:
  /// **'We could not create this card. Check your details and try again.'**
  String get cardCreateError;

  /// No description provided for @cardPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm with transaction PIN'**
  String get cardPinTitle;

  /// No description provided for @cardPinPrompt.
  ///
  /// In en, this message translates to:
  /// **'4-digit transaction PIN'**
  String get cardPinPrompt;

  /// No description provided for @cardNotFound.
  ///
  /// In en, this message translates to:
  /// **'This card is no longer available.'**
  String get cardNotFound;

  /// No description provided for @cardRevealTitle.
  ///
  /// In en, this message translates to:
  /// **'Show card details'**
  String get cardRevealTitle;

  /// No description provided for @cardRevealSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View the full card number, expiry and CVV.'**
  String get cardRevealSubtitle;

  /// No description provided for @cardRevealAction.
  ///
  /// In en, this message translates to:
  /// **'Verify PIN and reveal'**
  String get cardRevealAction;

  /// No description provided for @cardRevealPrompt.
  ///
  /// In en, this message translates to:
  /// **'Verify your transaction PIN to view these details.'**
  String get cardRevealPrompt;

  /// No description provided for @cardRevealTimerNotice.
  ///
  /// In en, this message translates to:
  /// **'Card details hide automatically after 30 seconds.'**
  String get cardRevealTimerNotice;

  /// No description provided for @cardRevealActiveOnly.
  ///
  /// In en, this message translates to:
  /// **'Only active cards can reveal their details.'**
  String get cardRevealActiveOnly;

  /// No description provided for @cardRevealError.
  ///
  /// In en, this message translates to:
  /// **'We could not verify your PIN or load card details.'**
  String get cardRevealError;

  /// No description provided for @cardPrivacyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Secure card details are unavailable on this platform.'**
  String get cardPrivacyUnavailable;

  /// No description provided for @cardNumberField.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumberField;

  /// No description provided for @cardExpiryField.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get cardExpiryField;

  /// No description provided for @cardCvvField.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cardCvvField;

  /// No description provided for @cardCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get cardCopy;

  /// No description provided for @cardCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied. Clipboard content will be cleared when card details are hidden.'**
  String get cardCopied;

  /// No description provided for @cardHideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide details now'**
  String get cardHideDetails;

  /// No description provided for @cardDetailsTimeout.
  ///
  /// In en, this message translates to:
  /// **'Details hide in {seconds} seconds'**
  String cardDetailsTimeout(int seconds);

  /// No description provided for @cardLimitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Card limits'**
  String get cardLimitsTitle;

  /// No description provided for @cardLimitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set per-transaction and daily limits.'**
  String get cardLimitsSubtitle;

  /// No description provided for @cardPerTransactionLimit.
  ///
  /// In en, this message translates to:
  /// **'Per-transaction limit'**
  String get cardPerTransactionLimit;

  /// No description provided for @cardLimitsHint.
  ///
  /// In en, this message translates to:
  /// **'Limits are subject to your account tier and bank policy.'**
  String get cardLimitsHint;

  /// No description provided for @cardLimitsSaved.
  ///
  /// In en, this message translates to:
  /// **'Card limits updated.'**
  String get cardLimitsSaved;

  /// No description provided for @cardSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Card settings and alerts'**
  String get cardSettingsTitle;

  /// No description provided for @cardSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control card notifications and usage.'**
  String get cardSettingsSubtitle;

  /// No description provided for @cardPushAlerts.
  ///
  /// In en, this message translates to:
  /// **'Push alerts'**
  String get cardPushAlerts;

  /// No description provided for @cardPushAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get a notification when this card is used.'**
  String get cardPushAlertsDescription;

  /// No description provided for @cardSmsAlerts.
  ///
  /// In en, this message translates to:
  /// **'SMS alerts'**
  String get cardSmsAlerts;

  /// No description provided for @cardSmsAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive a text message when this card is used.'**
  String get cardSmsAlertsDescription;

  /// No description provided for @cardOnlinePurchases.
  ///
  /// In en, this message translates to:
  /// **'Online purchases'**
  String get cardOnlinePurchases;

  /// No description provided for @cardInternationalPurchases.
  ///
  /// In en, this message translates to:
  /// **'International purchases'**
  String get cardInternationalPurchases;

  /// No description provided for @cardSettingsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load card settings. Try again.'**
  String get cardSettingsLoadError;

  /// No description provided for @cardSettingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'We could not save this setting. Your previous setting was restored.'**
  String get cardSettingsSaveError;

  /// No description provided for @cardTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Card transactions'**
  String get cardTransactionsTitle;

  /// No description provided for @cardTransactionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No card transactions yet.'**
  String get cardTransactionsEmpty;

  /// No description provided for @cardTransactionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load card transactions. Try again.'**
  String get cardTransactionsLoadError;

  /// No description provided for @cardRenameAction.
  ///
  /// In en, this message translates to:
  /// **'Rename card'**
  String get cardRenameAction;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @cardChangeThemeAction.
  ///
  /// In en, this message translates to:
  /// **'Change card theme'**
  String get cardChangeThemeAction;

  /// No description provided for @cardDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete card'**
  String get cardDeleteAction;

  /// No description provided for @cardDeletePrompt.
  ///
  /// In en, this message translates to:
  /// **'This permanently closes the card. Its transaction history is retained.'**
  String get cardDeletePrompt;

  /// No description provided for @homeOfflineLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Offline · Last updated {time}'**
  String homeOfflineLastUpdated(String time);

  /// No description provided for @homeStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get homeStatusActive;

  /// No description provided for @homeStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get homeStatusLocked;

  /// No description provided for @homeStatusRestricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get homeStatusRestricted;

  /// No description provided for @homeStatusDormant.
  ///
  /// In en, this message translates to:
  /// **'Dormant'**
  String get homeStatusDormant;

  /// No description provided for @homeStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get homeStatusClosed;

  /// No description provided for @homeStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Status unavailable'**
  String get homeStatusUnavailable;

  /// No description provided for @homeCardCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating'**
  String get homeCardCreating;

  /// No description provided for @homeCardActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get homeCardActive;

  /// No description provided for @homeCardFrozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get homeCardFrozen;

  /// No description provided for @homeCardExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get homeCardExpired;

  /// No description provided for @homeCardDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get homeCardDeleted;

  /// No description provided for @homeTxnPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get homeTxnPending;

  /// No description provided for @homeTxnSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get homeTxnSuccessful;

  /// No description provided for @homeTxnFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get homeTxnFailed;

  /// No description provided for @homeTxnReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get homeTxnReversed;

  /// No description provided for @transactionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get transactionDetailTitle;

  /// No description provided for @transactionCounterparty.
  ///
  /// In en, this message translates to:
  /// **'Counterparty'**
  String get transactionCounterparty;

  /// No description provided for @transactionBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get transactionBank;

  /// No description provided for @transactionNarration.
  ///
  /// In en, this message translates to:
  /// **'Narration'**
  String get transactionNarration;

  /// No description provided for @transactionFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get transactionFee;

  /// No description provided for @transactionReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get transactionReference;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get transactionDate;

  /// No description provided for @transactionBalanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Balance after'**
  String get transactionBalanceAfter;

  /// No description provided for @transactionFailureInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'There was not enough available balance for this transaction.'**
  String get transactionFailureInsufficientFunds;

  /// No description provided for @transactionFailureLimit.
  ///
  /// In en, this message translates to:
  /// **'This transaction exceeded your account limit.'**
  String get transactionFailureLimit;

  /// No description provided for @transactionFailureAccountLocked.
  ///
  /// In en, this message translates to:
  /// **'Your account status prevented this transaction.'**
  String get transactionFailureAccountLocked;

  /// No description provided for @transactionFailureGeneric.
  ///
  /// In en, this message translates to:
  /// **'This transaction could not be completed.'**
  String get transactionFailureGeneric;

  /// No description provided for @transactionOfflineStale.
  ///
  /// In en, this message translates to:
  /// **'Showing the last details available on this device.'**
  String get transactionOfflineStale;

  /// No description provided for @transactionDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load this transaction.'**
  String get transactionDetailLoadError;

  /// No description provided for @transactionReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get transactionReceipt;

  /// No description provided for @transactionReportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get transactionReportProblem;

  /// No description provided for @transactionSaveBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Save beneficiary'**
  String get transactionSaveBeneficiary;

  /// No description provided for @welcomeSlideSafeTitle.
  ///
  /// In en, this message translates to:
  /// **'Banking that feels safe'**
  String get welcomeSlideSafeTitle;

  /// No description provided for @welcomeSlideSafeBody.
  ///
  /// In en, this message translates to:
  /// **'Your money and personal details stay protected.'**
  String get welcomeSlideSafeBody;

  /// No description provided for @welcomeSlideSimpleTitle.
  ///
  /// In en, this message translates to:
  /// **'Everyday banking, made simple'**
  String get welcomeSlideSimpleTitle;

  /// No description provided for @welcomeSlideSimpleBody.
  ///
  /// In en, this message translates to:
  /// **'Handle the things you need in a few clear steps.'**
  String get welcomeSlideSimpleBody;

  /// No description provided for @welcomeSlideYoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Made for you'**
  String get welcomeSlideYoursTitle;

  /// No description provided for @welcomeSlideYoursBody.
  ///
  /// In en, this message translates to:
  /// **'A banking experience built around your everyday life.'**
  String get welcomeSlideYoursBody;

  /// No description provided for @welcomeCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get welcomeCreateAccount;

  /// No description provided for @welcomeLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get welcomeLogin;

  /// No description provided for @welcomePreviewLegal.
  ///
  /// In en, this message translates to:
  /// **'Preview Terms and Privacy'**
  String get welcomePreviewLegal;

  /// No description provided for @welcomePreviewSelfie.
  ///
  /// In en, this message translates to:
  /// **'Preview selfie capture'**
  String get welcomePreviewSelfie;

  /// No description provided for @welcomePreviewBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Preview biometrics'**
  String get welcomePreviewBiometrics;

  /// No description provided for @welcomeLegalFooter.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you can review our Terms and Privacy Notice.'**
  String get welcomeLegalFooter;

  /// No description provided for @onboardingStepOne.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 8'**
  String get onboardingStepOne;

  /// No description provided for @onboardingStepTwo.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 8'**
  String get onboardingStepTwo;

  /// No description provided for @onboardingStepThree.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 8'**
  String get onboardingStepThree;

  /// No description provided for @onboardingStepFour.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 8'**
  String get onboardingStepFour;

  /// No description provided for @onboardingStepFive.
  ///
  /// In en, this message translates to:
  /// **'Step 5 of 8'**
  String get onboardingStepFive;

  /// No description provided for @onboardingStepSix.
  ///
  /// In en, this message translates to:
  /// **'Step 6 of 8'**
  String get onboardingStepSix;

  /// No description provided for @onboardingStepSeven.
  ///
  /// In en, this message translates to:
  /// **'Step 7 of 8'**
  String get onboardingStepSeven;

  /// No description provided for @onboardingStepEight.
  ///
  /// In en, this message translates to:
  /// **'Step 8 of 8'**
  String get onboardingStepEight;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your phone number?'**
  String get phoneTitle;

  /// No description provided for @phoneHelper.
  ///
  /// In en, this message translates to:
  /// **'We will send a code by SMS.'**
  String get phoneHelper;

  /// No description provided for @phoneFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneFieldLabel;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Nigerian phone number.'**
  String get phoneInvalid;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get commonVerify;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonBackToWelcome.
  ///
  /// In en, this message translates to:
  /// **'Back to welcome'**
  String get commonBackToWelcome;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {phone}.'**
  String otpSentTo(String phone);

  /// No description provided for @otpFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Six-digit verification code'**
  String get otpFieldLabel;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get otpResend;

  /// No description provided for @otpResendCountdown.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String otpResendCountdown(int seconds);

  /// No description provided for @otpChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get otpChangeNumber;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal details'**
  String get detailsTitle;

  /// No description provided for @detailsHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter your details as they appear on your identity documents.'**
  String get detailsHelper;

  /// No description provided for @detailsFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get detailsFirstName;

  /// No description provided for @detailsLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get detailsLastName;

  /// No description provided for @detailsDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get detailsDateOfBirth;

  /// No description provided for @detailsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get detailsEmail;

  /// No description provided for @detailsReferralOptional.
  ///
  /// In en, this message translates to:
  /// **'Referral code (optional)'**
  String get detailsReferralOptional;

  /// No description provided for @detailsNameMatchNote.
  ///
  /// In en, this message translates to:
  /// **'Your name should match your BVN records.'**
  String get detailsNameMatchNote;

  /// No description provided for @nameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use 2–50 letters, spaces, hyphens or apostrophes.'**
  String get nameInvalid;

  /// No description provided for @dateOfBirthInvalid.
  ///
  /// In en, this message translates to:
  /// **'Choose a valid date of birth.'**
  String get dateOfBirthInvalid;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'Before we continue'**
  String get consentTitle;

  /// No description provided for @consentBlockedNotice.
  ///
  /// In en, this message translates to:
  /// **'We cannot ask for your consent until the approved legal documents and versions are available.'**
  String get consentBlockedNotice;

  /// No description provided for @consentDraftBanner.
  ///
  /// In en, this message translates to:
  /// **'Draft preview only. These documents are placeholders, have not been approved by the bank or counsel, and cannot be accepted as live customer terms.'**
  String get consentDraftBanner;

  /// No description provided for @consentDraftVersion.
  ///
  /// In en, this message translates to:
  /// **'Draft preview · not an approved document'**
  String get consentDraftVersion;

  /// No description provided for @consentDraftNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Preview selections are not saved or sent to the API as consent.'**
  String get consentDraftNotRecorded;

  /// No description provided for @consentContinuePreview.
  ///
  /// In en, this message translates to:
  /// **'Continue in preview'**
  String get consentContinuePreview;

  /// No description provided for @consentTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get consentTerms;

  /// No description provided for @consentPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I acknowledge the Privacy Notice'**
  String get consentPrivacy;

  /// No description provided for @consentOptionalDataUse.
  ///
  /// In en, this message translates to:
  /// **'Allow optional data use'**
  String get consentOptionalDataUse;

  /// No description provided for @consentOptionalDataUseHint.
  ///
  /// In en, this message translates to:
  /// **'Optional and not required to continue. Draft wording only; no preference is stored.'**
  String get consentOptionalDataUseHint;

  /// No description provided for @termsDraftBody.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER TERMS AND CONDITIONS — DRAFT PREVIEW ONLY\n\nThis placeholder is not an approved legal agreement. It must be replaced with terms approved by the bank and Nigerian legal counsel before customer acceptance.\n\nService description: the product handoff describes a mobile banking app. The provider identity, regulated service description, foundation-bank relationship and applicable terms have not been supplied.\n\nEligibility and verification: the onboarding screens request identity details. Minimum age, eligibility criteria and account-opening conditions remain unconfirmed.\n\nTransactions, limits and fees: approved fee schedules, limits, settlement and reversal terms have not been supplied.\n\nSecurity and support: customers should protect authentication credentials. The approved support contact, complaint process and customer liability terms have not been supplied.\n\nBefore live use, legal owners must provide the effective date, document version, legal entity, fees, limits, complaint details, governing law, dispute terms and approval record.'**
  String get termsDraftBody;

  /// No description provided for @privacyDraftBody.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY NOTICE — DRAFT PREVIEW ONLY\n\nThis placeholder is not an approved privacy notice. The controller, purposes and legal bases, recipients, retention periods, transfer locations, contact details and rights-handling process have not been approved.\n\nInformation entered: onboarding asks for phone number, name, date of birth, email, BVN and NIN. The app sends OTP requests and identity numbers to the API configured for the app. The responsible controller and processor details are not identified in the handoff.\n\nCamera and biometrics: the selfie step is intended for identity matching. The provider, processing location, retention/deletion schedule and failed-match process have not been supplied.\n\nPrivacy rights and contact: the applicable rights, request process, controller privacy contact and complaint route must be supplied by the privacy/compliance owner.\n\nBefore live use, obtain approved controller details, purposes and legal bases, recipient categories, transfer locations, retention and deletion rules, biometric-data details, rights process, effective date, version and approval record.'**
  String get privacyDraftBody;

  /// No description provided for @consentDocumentUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Approved document is not available yet.'**
  String get consentDocumentUnavailable;

  /// No description provided for @consentContinue.
  ///
  /// In en, this message translates to:
  /// **'I agree and continue'**
  String get consentContinue;

  /// No description provided for @bvnTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your BVN'**
  String get bvnTitle;

  /// No description provided for @bvnHelper.
  ///
  /// In en, this message translates to:
  /// **'We use your Bank Verification Number to verify your identity.'**
  String get bvnHelper;

  /// No description provided for @bvnFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank Verification Number'**
  String get bvnFieldLabel;

  /// No description provided for @bvnVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify BVN'**
  String get bvnVerify;

  /// No description provided for @ninTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your NIN'**
  String get ninTitle;

  /// No description provided for @ninHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter your 11-digit National Identification Number.'**
  String get ninHelper;

  /// No description provided for @ninFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'National Identification Number'**
  String get ninFieldLabel;

  /// No description provided for @ninVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify NIN and continue'**
  String get ninVerify;

  /// No description provided for @identityNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 11 digits. Your number is sent securely for verification.'**
  String get identityNumberHint;

  /// No description provided for @identityNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 11-digit number.'**
  String get identityNumberInvalid;

  /// No description provided for @kycMismatch.
  ///
  /// In en, this message translates to:
  /// **'Your details do not match. Check the number and try again.'**
  String get kycMismatch;

  /// No description provided for @kycUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We cannot verify your identity right now. Your progress is saved; try again later.'**
  String get kycUnavailable;

  /// No description provided for @kycRejected.
  ///
  /// In en, this message translates to:
  /// **'We could not verify your identity. Contact support for help with your application.'**
  String get kycRejected;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginHelper.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone number or email and passcode.'**
  String get loginHelper;

  /// No description provided for @loginIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get loginIdentifier;

  /// No description provided for @loginPasscodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your 6-digit passcode'**
  String get loginPasscodeLabel;

  /// No description provided for @loginDeleteDigit.
  ///
  /// In en, this message translates to:
  /// **'Delete last digit'**
  String get loginDeleteDigit;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginSubmit;

  /// No description provided for @loginForgotPasscode.
  ///
  /// In en, this message translates to:
  /// **'Forgot passcode?'**
  String get loginForgotPasscode;

  /// No description provided for @loginInvalid.
  ///
  /// In en, this message translates to:
  /// **'That passcode is not right.'**
  String get loginInvalid;

  /// No description provided for @loginLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Your account is locked for your safety.'**
  String get loginLocked;

  /// No description provided for @loginNewDevice.
  ///
  /// In en, this message translates to:
  /// **'Let’s verify this device.'**
  String get loginNewDevice;

  /// No description provided for @loginDeviceVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Device verification needs to be completed before sign-in can continue.'**
  String get loginDeviceVerificationRequired;

  /// No description provided for @loginVerifyDeviceAction.
  ///
  /// In en, this message translates to:
  /// **'Verify device'**
  String get loginVerifyDeviceAction;

  /// No description provided for @resetPasscodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your passcode'**
  String get resetPasscodeTitle;

  /// No description provided for @newDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify this device'**
  String get newDeviceTitle;

  /// No description provided for @flowNotReady.
  ///
  /// In en, this message translates to:
  /// **'This secure verification step is not implemented yet. Sign-in cannot continue until it is available.'**
  String get flowNotReady;

  /// No description provided for @livenessTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify with a selfie'**
  String get livenessTitle;

  /// No description provided for @livenessHelper.
  ///
  /// In en, this message translates to:
  /// **'Center your face, use good light, and remove hats or glasses. Follow the prompts while recording.'**
  String get livenessHelper;

  /// No description provided for @livenessGoodLighting.
  ///
  /// In en, this message translates to:
  /// **'Good lighting'**
  String get livenessGoodLighting;

  /// No description provided for @livenessNoHatOrGlasses.
  ///
  /// In en, this message translates to:
  /// **'No hats or glasses'**
  String get livenessNoHatOrGlasses;

  /// No description provided for @livenessNeutralExpression.
  ///
  /// In en, this message translates to:
  /// **'Neutral expression'**
  String get livenessNeutralExpression;

  /// No description provided for @livenessPromptHeading.
  ///
  /// In en, this message translates to:
  /// **'During the recording'**
  String get livenessPromptHeading;

  /// No description provided for @livenessPromptBlink.
  ///
  /// In en, this message translates to:
  /// **'Blink slowly once.'**
  String get livenessPromptBlink;

  /// No description provided for @livenessPromptHeadTurn.
  ///
  /// In en, this message translates to:
  /// **'Turn your head slowly to the left, then to the right.'**
  String get livenessPromptHeadTurn;

  /// No description provided for @livenessPrompts.
  ///
  /// In en, this message translates to:
  /// **'Follow each instruction at a natural pace and keep your face inside the guide.'**
  String get livenessPrompts;

  /// No description provided for @livenessStartCamera.
  ///
  /// In en, this message translates to:
  /// **'Start camera'**
  String get livenessStartCamera;

  /// No description provided for @livenessStartCapture.
  ///
  /// In en, this message translates to:
  /// **'Start selfie recording'**
  String get livenessStartCapture;

  /// No description provided for @livenessStopCapture.
  ///
  /// In en, this message translates to:
  /// **'Finish recording'**
  String get livenessStopCapture;

  /// No description provided for @livenessRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake selfie'**
  String get livenessRetake;

  /// No description provided for @livenessNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Recording captured on this device. It has not been uploaded or verified.'**
  String get livenessNotVerified;

  /// No description provided for @livenessContractBlocker.
  ///
  /// In en, this message translates to:
  /// **'Verification cannot finish until the liveness session and secure upload API are provided.'**
  String get livenessContractBlocker;

  /// No description provided for @biometricSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock faster'**
  String get biometricSetupTitle;

  /// No description provided for @biometricSetupHelper.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face unlock for a quicker sign-in on this device.'**
  String get biometricSetupHelper;

  /// No description provided for @biometricSetupPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your biometric stays in your device\'s secure system. We save only your choice to enable this feature.'**
  String get biometricSetupPrivacy;

  /// No description provided for @biometricSetupEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable biometrics'**
  String get biometricSetupEnable;

  /// No description provided for @biometricSetupSkip.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get biometricSetupSkip;

  /// No description provided for @biometricSetupCancelled.
  ///
  /// In en, this message translates to:
  /// **'Biometric setup was cancelled. You can try again or continue without it.'**
  String get biometricSetupCancelled;

  /// No description provided for @biometricSystemReason.
  ///
  /// In en, this message translates to:
  /// **'Enable biometric unlock for future sign-in.'**
  String get biometricSystemReason;

  /// No description provided for @biometricLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get biometricLoginButton;

  /// No description provided for @biometricLoginReason.
  ///
  /// In en, this message translates to:
  /// **'Use your fingerprint or face to unlock your saved sign-in session.'**
  String get biometricLoginReason;

  /// No description provided for @biometricLoginCancelled.
  ///
  /// In en, this message translates to:
  /// **'Biometric check was cancelled. Try again or enter your passcode.'**
  String get biometricLoginCancelled;

  /// No description provided for @biometricLoginSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your secure session has expired. Sign in with your passcode.'**
  String get biometricLoginSessionExpired;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission was denied. Allow camera access in your browser or device settings, then try again.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No usable camera is available. Connect or enable a camera and try again.'**
  String get cameraUnavailable;

  /// No description provided for @cameraCaptureError.
  ///
  /// In en, this message translates to:
  /// **'We could not capture the recording. Try again.'**
  String get cameraCaptureError;

  /// No description provided for @cameraPaused.
  ///
  /// In en, this message translates to:
  /// **'Camera access stopped when the app was paused. Start the camera again to continue.'**
  String get cameraPaused;

  /// No description provided for @onboardingResumeUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Your code was verified, but the server returned a sign-up step this app cannot safely open. Your session is saved. Please contact support before trying again.'**
  String get onboardingResumeUnsupported;

  /// No description provided for @onboardingStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We could not retrieve your saved sign-up status. Try again when you have a connection.'**
  String get onboardingStatusUnavailable;

  /// No description provided for @onboardingStepUnsupported.
  ///
  /// In en, this message translates to:
  /// **'The server returned a sign-up step this app does not recognize. Your session is saved; setup cannot continue safely yet.'**
  String get onboardingStepUnsupported;

  /// No description provided for @onboardingContinueSetup.
  ///
  /// In en, this message translates to:
  /// **'Your saved sign-up step is ready to continue.'**
  String get onboardingContinueSetup;

  /// No description provided for @onboardingAccountPending.
  ///
  /// In en, this message translates to:
  /// **'Your account is being set up. Check your status again later.'**
  String get onboardingAccountPending;

  /// No description provided for @onboardingManualReview.
  ///
  /// In en, this message translates to:
  /// **'Your identity check needs a manual review. Check your status again later.'**
  String get onboardingManualReview;

  /// No description provided for @onboardingRejected.
  ///
  /// In en, this message translates to:
  /// **'We could not complete your sign-up. Contact support for help with your application.'**
  String get onboardingRejected;

  /// No description provided for @onboardingAccountReady.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready'**
  String get onboardingAccountReady;

  /// No description provided for @accountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumberLabel;

  /// No description provided for @onboardingCheckStatus.
  ///
  /// In en, this message translates to:
  /// **'Check status'**
  String get onboardingCheckStatus;

  /// No description provided for @passcodeCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your login passcode'**
  String get passcodeCreateTitle;

  /// No description provided for @passcodeCreateHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose a 6-digit passcode. Avoid repeated or sequential digits.'**
  String get passcodeCreateHelper;

  /// No description provided for @passcodeCreateField.
  ///
  /// In en, this message translates to:
  /// **'6-digit passcode'**
  String get passcodeCreateField;

  /// No description provided for @passcodeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm passcode'**
  String get passcodeConfirm;

  /// No description provided for @passcodeWeak.
  ///
  /// In en, this message translates to:
  /// **'Choose a passcode that is not repeated or sequential.'**
  String get passcodeWeak;

  /// No description provided for @transactionPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your transaction PIN'**
  String get transactionPinTitle;

  /// No description provided for @transactionPinHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4-digit PIN to approve money movements.'**
  String get transactionPinHelper;

  /// No description provided for @transactionPinField.
  ///
  /// In en, this message translates to:
  /// **'4-digit transaction PIN'**
  String get transactionPinField;

  /// No description provided for @transactionPinConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm transaction PIN'**
  String get transactionPinConfirm;

  /// No description provided for @transactionPinDifferentNote.
  ///
  /// In en, this message translates to:
  /// **'Keep your transaction PIN different from your login passcode.'**
  String get transactionPinDifferentNote;

  /// No description provided for @credentialLengthInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter all the required digits.'**
  String get credentialLengthInvalid;

  /// No description provided for @credentialMismatch.
  ///
  /// In en, this message translates to:
  /// **'The entries do not match. Try again.'**
  String get credentialMismatch;

  /// No description provided for @errorConfiguration.
  ///
  /// In en, this message translates to:
  /// **'The service is not configured yet. Please try again later.'**
  String get errorConfiguration;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment before trying again.'**
  String get errorRateLimited;

  /// No description provided for @errorOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code is not right or has expired. Try again.'**
  String get errorOtpInvalid;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Check your connection and try again.'**
  String get errorOffline;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'We could not complete that request. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @accountDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get accountDetailsTitle;

  /// No description provided for @accountNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountNameLabel;

  /// No description provided for @accountTierLabel.
  ///
  /// In en, this message translates to:
  /// **'Tier {tier} account'**
  String accountTierLabel(String tier);

  /// No description provided for @accountStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String accountStatusLabel(String status);

  /// No description provided for @accountBankUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Bank name unavailable'**
  String get accountBankUnavailable;

  /// No description provided for @accountBankUnavailableHelper.
  ///
  /// In en, this message translates to:
  /// **'The account service has not supplied an approved bank name.'**
  String get accountBankUnavailableHelper;

  /// No description provided for @accountLimitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tier {tier} limits and allowances'**
  String accountLimitsTitle(String tier);

  /// No description provided for @accountDailyTransferLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily transfer limit'**
  String get accountDailyTransferLimit;

  /// No description provided for @accountDailyUsed.
  ///
  /// In en, this message translates to:
  /// **'{amount} used today'**
  String accountDailyUsed(String amount);

  /// No description provided for @accountDailyRemaining.
  ///
  /// In en, this message translates to:
  /// **'{amount} remaining'**
  String accountDailyRemaining(String amount);

  /// No description provided for @accountMaximumBalance.
  ///
  /// In en, this message translates to:
  /// **'Maximum balance'**
  String get accountMaximumBalance;

  /// No description provided for @accountSingleTransferMax.
  ///
  /// In en, this message translates to:
  /// **'Single transfer max'**
  String get accountSingleTransferMax;

  /// No description provided for @accountCopyNumber.
  ///
  /// In en, this message translates to:
  /// **'Copy account number'**
  String get accountCopyNumber;

  /// No description provided for @accountCopied.
  ///
  /// In en, this message translates to:
  /// **'Account number copied'**
  String get accountCopied;

  /// No description provided for @accountShareText.
  ///
  /// In en, this message translates to:
  /// **'Share as text'**
  String get accountShareText;

  /// No description provided for @accountShareImage.
  ///
  /// In en, this message translates to:
  /// **'Share as image'**
  String get accountShareImage;

  /// No description provided for @accountShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share account details'**
  String get accountShareTitle;

  /// No description provided for @accountShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open sharing. Try copying the account number instead.'**
  String get accountShareFailed;

  /// No description provided for @accountNotProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get accountNotProvided;

  /// No description provided for @paymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsTitle;

  /// No description provided for @paymentsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipients or billers'**
  String get paymentsSearchHint;

  /// No description provided for @paymentsSendMoney.
  ///
  /// In en, this message translates to:
  /// **'Send money'**
  String get paymentsSendMoney;

  /// No description provided for @paymentsSendBank.
  ///
  /// In en, this message translates to:
  /// **'To bank account'**
  String get paymentsSendBank;

  /// No description provided for @paymentsSendBankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send to a Nigerian bank account'**
  String get paymentsSendBankSubtitle;

  /// No description provided for @paymentsSendSaved.
  ///
  /// In en, this message translates to:
  /// **'Send to saved'**
  String get paymentsSendSaved;

  /// No description provided for @paymentsRequestMoney.
  ///
  /// In en, this message translates to:
  /// **'Request money'**
  String get paymentsRequestMoney;

  /// No description provided for @paymentsRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a payment request'**
  String get paymentsRequestSubtitle;

  /// No description provided for @paymentsScanPay.
  ///
  /// In en, this message translates to:
  /// **'Scan and pay QR'**
  String get paymentsScanPay;

  /// No description provided for @paymentsAirtimeData.
  ///
  /// In en, this message translates to:
  /// **'Airtime and data'**
  String get paymentsAirtimeData;

  /// No description provided for @paymentsBillsUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills and utilities'**
  String get paymentsBillsUtilities;

  /// No description provided for @paymentsElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get paymentsElectricity;

  /// No description provided for @paymentsInternetTv.
  ///
  /// In en, this message translates to:
  /// **'Internet and TV'**
  String get paymentsInternetTv;

  /// No description provided for @paymentsBetting.
  ///
  /// In en, this message translates to:
  /// **'Betting'**
  String get paymentsBetting;

  /// No description provided for @paymentsAllBills.
  ///
  /// In en, this message translates to:
  /// **'All bills'**
  String get paymentsAllBills;

  /// No description provided for @paymentsScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled payments'**
  String get paymentsScheduled;

  /// No description provided for @scheduledBackendPending.
  ///
  /// In en, this message translates to:
  /// **'Scheduled payments are not connected yet. The API needs backend implementation and confirmation before live schedules, debits, or changes can be shown here.'**
  String get scheduledBackendPending;

  /// No description provided for @scheduledCreate.
  ///
  /// In en, this message translates to:
  /// **'Create new scheduled payment'**
  String get scheduledCreate;

  /// No description provided for @scheduledUpcomingMonth.
  ///
  /// In en, this message translates to:
  /// **'Upcoming this month'**
  String get scheduledUpcomingMonth;

  /// No description provided for @scheduledActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String scheduledActiveCount(int count);

  /// No description provided for @scheduledNextRun.
  ///
  /// In en, this message translates to:
  /// **'Next run: {date}'**
  String scheduledNextRun(String date);

  /// No description provided for @scheduledCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get scheduledCalendar;

  /// No description provided for @scheduledCalendarDemoToast.
  ///
  /// In en, this message translates to:
  /// **'Calendar sync is not connected in this demo.'**
  String get scheduledCalendarDemoToast;

  /// No description provided for @scheduledActiveTab.
  ///
  /// In en, this message translates to:
  /// **'Active ({count})'**
  String scheduledActiveTab(int count);

  /// No description provided for @scheduledPausedTab.
  ///
  /// In en, this message translates to:
  /// **'Paused ({count})'**
  String scheduledPausedTab(int count);

  /// No description provided for @scheduledCompletedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get scheduledCompletedTab;

  /// No description provided for @scheduledActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get scheduledActiveStatus;

  /// No description provided for @scheduledNextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next:'**
  String get scheduledNextLabel;

  /// No description provided for @scheduledDebitNotice.
  ///
  /// In en, this message translates to:
  /// **'Scheduled debits can only run after you authorize them. Keep enough funds available for the payment date; your bank may charge fees for failed mandates.'**
  String get scheduledDebitNotice;

  /// No description provided for @scheduledDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'DEMO DATA ONLY · You can try creating, editing, pausing, and cancelling fictional schedules. Changes last only while this preview is open; no real payment or API request is made.'**
  String get scheduledDemoNotice;

  /// No description provided for @scheduledDemoPaused.
  ///
  /// In en, this message translates to:
  /// **'Water bill'**
  String get scheduledDemoPaused;

  /// No description provided for @scheduledDemoCompleted.
  ///
  /// In en, this message translates to:
  /// **'School fees'**
  String get scheduledDemoCompleted;

  /// No description provided for @scheduledCompletedTabCount.
  ///
  /// In en, this message translates to:
  /// **'Completed ({count})'**
  String scheduledCompletedTabCount(int count);

  /// No description provided for @scheduledPausedStatus.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get scheduledPausedStatus;

  /// No description provided for @scheduledCompletedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get scheduledCompletedStatus;

  /// No description provided for @scheduledCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get scheduledCancel;

  /// No description provided for @scheduledEmpty.
  ///
  /// In en, this message translates to:
  /// **'No schedules in this section.'**
  String get scheduledEmpty;

  /// No description provided for @scheduledNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get scheduledNone;

  /// No description provided for @scheduledEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit scheduled payment'**
  String get scheduledEditTitle;

  /// No description provided for @scheduledNameField.
  ///
  /// In en, this message translates to:
  /// **'Payment name'**
  String get scheduledNameField;

  /// No description provided for @scheduledAmountField.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get scheduledAmountField;

  /// No description provided for @scheduledNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for this scheduled payment.'**
  String get scheduledNameRequired;

  /// No description provided for @scheduledAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get scheduledAmountInvalid;

  /// No description provided for @scheduledFrequencyField.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get scheduledFrequencyField;

  /// No description provided for @scheduledStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get scheduledStartDate;

  /// No description provided for @scheduledOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get scheduledOnce;

  /// No description provided for @scheduledDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get scheduledDaily;

  /// No description provided for @scheduledWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get scheduledWeekly;

  /// No description provided for @scheduledMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get scheduledMonthly;

  /// No description provided for @scheduledCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel scheduled payment?'**
  String get scheduledCancelTitle;

  /// No description provided for @scheduledCancelPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from this demo schedule list?'**
  String scheduledCancelPrompt(String name);

  /// No description provided for @scheduledLocalOnlyToast.
  ///
  /// In en, this message translates to:
  /// **'Demo change saved locally for this preview only. No payment was made.'**
  String get scheduledLocalOnlyToast;

  /// No description provided for @scheduledDemoElectricity.
  ///
  /// In en, this message translates to:
  /// **'Ikeja Electric Mandate'**
  String get scheduledDemoElectricity;

  /// No description provided for @scheduledMonthly28.
  ///
  /// In en, this message translates to:
  /// **'Monthly on the 28th'**
  String get scheduledMonthly28;

  /// No description provided for @scheduledDemoFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday, 28 Oct'**
  String get scheduledDemoFriday;

  /// No description provided for @scheduledDemoRent.
  ///
  /// In en, this message translates to:
  /// **'Amina Yusuf – Rent Support'**
  String get scheduledDemoRent;

  /// No description provided for @scheduledWeeklyMonday.
  ///
  /// In en, this message translates to:
  /// **'Weekly on Mondays'**
  String get scheduledWeeklyMonday;

  /// No description provided for @scheduledDemoMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday, 31 Oct'**
  String get scheduledDemoMonday;

  /// No description provided for @scheduledDemoInternet.
  ///
  /// In en, this message translates to:
  /// **'Internet Subscription'**
  String get scheduledDemoInternet;

  /// No description provided for @scheduledMonthly1.
  ///
  /// In en, this message translates to:
  /// **'Monthly on the 1st'**
  String get scheduledMonthly1;

  /// No description provided for @scheduledDemoNovember.
  ///
  /// In en, this message translates to:
  /// **'1 Nov'**
  String get scheduledDemoNovember;

  /// No description provided for @paymentsDuesLevies.
  ///
  /// In en, this message translates to:
  /// **'Dues and levies'**
  String get paymentsDuesLevies;

  /// No description provided for @paymentsStage2.
  ///
  /// In en, this message translates to:
  /// **'Stage 2'**
  String get paymentsStage2;

  /// No description provided for @paymentsSavedRecipients.
  ///
  /// In en, this message translates to:
  /// **'Saved recipients'**
  String get paymentsSavedRecipients;

  /// No description provided for @paymentsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get paymentsViewAll;

  /// No description provided for @paymentsNoRecipients.
  ///
  /// In en, this message translates to:
  /// **'No saved recipients yet.'**
  String get paymentsNoRecipients;

  /// No description provided for @paymentsRecipientsError.
  ///
  /// In en, this message translates to:
  /// **'Saved recipients could not be loaded.'**
  String get paymentsRecipientsError;

  /// No description provided for @paymentsRecentTransfers.
  ///
  /// In en, this message translates to:
  /// **'Recent transfers'**
  String get paymentsRecentTransfers;

  /// No description provided for @paymentsTransactionHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get paymentsTransactionHistory;

  /// No description provided for @paymentsNoTransfers.
  ///
  /// In en, this message translates to:
  /// **'No recent transfers.'**
  String get paymentsNoTransfers;

  /// No description provided for @paymentsNewPayment.
  ///
  /// In en, this message translates to:
  /// **'New payment'**
  String get paymentsNewPayment;

  /// No description provided for @paymentsFeatureUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get paymentsFeatureUnavailableTitle;

  /// No description provided for @paymentsFeatureUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This payment flow is not implemented yet. No payment has been made.'**
  String get paymentsFeatureUnavailable;

  /// No description provided for @paymentsBankCatalogBlock.
  ///
  /// In en, this message translates to:
  /// **'Bank selection is unavailable because the API contract does not provide a bank catalog. We will not guess bank names or codes.'**
  String get paymentsBankCatalogBlock;

  /// No description provided for @paymentsHelpTooltip.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get paymentsHelpTooltip;

  /// No description provided for @paymentsSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No matching payment options or recipients.'**
  String get paymentsSearchEmpty;

  /// No description provided for @billSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search biller, utility or service...'**
  String get billSearchHint;

  /// No description provided for @billFrequentTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequent billers'**
  String get billFrequentTitle;

  /// No description provided for @billQuickRevend.
  ///
  /// In en, this message translates to:
  /// **'Quick re-vend'**
  String get billQuickRevend;

  /// No description provided for @billCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get billCategoriesTitle;

  /// No description provided for @billDemoCategoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sectors (demo)'**
  String billDemoCategoryCount(int count);

  /// No description provided for @billDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'DEMO DATA ONLY · These sample billers are fictional. Validation and payment are simulated locally; no payment request is sent.'**
  String get billDemoNotice;

  /// No description provided for @billReceiptNotice.
  ///
  /// In en, this message translates to:
  /// **'Instant value delivery depends on the biller. Demo receipts and tokens are not real.'**
  String get billReceiptNotice;

  /// No description provided for @billElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get billElectricity;

  /// No description provided for @billElectricityDescription.
  ///
  /// In en, this message translates to:
  /// **'Prepaid and postpaid electricity meters'**
  String get billElectricityDescription;

  /// No description provided for @billDemoDiscos.
  ///
  /// In en, this message translates to:
  /// **'Sample discos'**
  String get billDemoDiscos;

  /// No description provided for @billCableInternet.
  ///
  /// In en, this message translates to:
  /// **'Cable & Internet'**
  String get billCableInternet;

  /// No description provided for @billCableDescription.
  ///
  /// In en, this message translates to:
  /// **'TV and internet subscriptions'**
  String get billCableDescription;

  /// No description provided for @billInstantRenewal.
  ///
  /// In en, this message translates to:
  /// **'Demo billers'**
  String get billInstantRenewal;

  /// No description provided for @billWater.
  ///
  /// In en, this message translates to:
  /// **'Utility & Water'**
  String get billWater;

  /// No description provided for @billWaterDescription.
  ///
  /// In en, this message translates to:
  /// **'Water boards and municipal services'**
  String get billWaterDescription;

  /// No description provided for @billStateBoards.
  ///
  /// In en, this message translates to:
  /// **'Sample providers'**
  String get billStateBoards;

  /// No description provided for @billGovernment.
  ///
  /// In en, this message translates to:
  /// **'Govt & Dues'**
  String get billGovernment;

  /// No description provided for @billGovernmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Government services and levies'**
  String get billGovernmentDescription;

  /// No description provided for @billDirectPayments.
  ///
  /// In en, this message translates to:
  /// **'Demo providers'**
  String get billDirectPayments;

  /// No description provided for @billBetting.
  ///
  /// In en, this message translates to:
  /// **'Betting & Gaming'**
  String get billBetting;

  /// No description provided for @billBettingDescription.
  ///
  /// In en, this message translates to:
  /// **'Gaming wallet top-ups'**
  String get billBettingDescription;

  /// No description provided for @billZeroCharges.
  ///
  /// In en, this message translates to:
  /// **'Demo providers'**
  String get billZeroCharges;

  /// No description provided for @billEducation.
  ///
  /// In en, this message translates to:
  /// **'Education & Exams'**
  String get billEducation;

  /// No description provided for @billEducationDescription.
  ///
  /// In en, this message translates to:
  /// **'Examination and education services'**
  String get billEducationDescription;

  /// No description provided for @billPinDelivery.
  ///
  /// In en, this message translates to:
  /// **'Demo providers'**
  String get billPinDelivery;

  /// No description provided for @billCharity.
  ///
  /// In en, this message translates to:
  /// **'Churches & Charity'**
  String get billCharity;

  /// No description provided for @billCharityDescription.
  ///
  /// In en, this message translates to:
  /// **'Community donations and offerings'**
  String get billCharityDescription;

  /// No description provided for @billDonations.
  ///
  /// In en, this message translates to:
  /// **'Demo providers'**
  String get billDonations;

  /// No description provided for @billTransport.
  ///
  /// In en, this message translates to:
  /// **'Toll & Transport'**
  String get billTransport;

  /// No description provided for @billTransportDescription.
  ///
  /// In en, this message translates to:
  /// **'Toll and transit top-ups'**
  String get billTransportDescription;

  /// No description provided for @billInstantTopup.
  ///
  /// In en, this message translates to:
  /// **'Demo providers'**
  String get billInstantTopup;

  /// No description provided for @billProviderDemo.
  ///
  /// In en, this message translates to:
  /// **'Fictional provider · Demo only'**
  String get billProviderDemo;

  /// No description provided for @billPrepaid.
  ///
  /// In en, this message translates to:
  /// **'Prepaid (Token)'**
  String get billPrepaid;

  /// No description provided for @billPostpaid.
  ///
  /// In en, this message translates to:
  /// **'Postpaid'**
  String get billPostpaid;

  /// No description provided for @billMeterNumber.
  ///
  /// In en, this message translates to:
  /// **'Meter number'**
  String get billMeterNumber;

  /// No description provided for @billCustomerReference.
  ///
  /// In en, this message translates to:
  /// **'Customer reference'**
  String get billCustomerReference;

  /// No description provided for @billValidate.
  ///
  /// In en, this message translates to:
  /// **'Validate reference'**
  String get billValidate;

  /// No description provided for @billReferenceInvalid.
  ///
  /// In en, this message translates to:
  /// **'The customer reference format is not valid.'**
  String get billReferenceInvalid;

  /// No description provided for @billDemoValidated.
  ///
  /// In en, this message translates to:
  /// **'DEMO REFERENCE VALIDATED'**
  String get billDemoValidated;

  /// No description provided for @billFictionalName.
  ///
  /// In en, this message translates to:
  /// **'Ada Demo Customer · fictional data'**
  String get billFictionalName;

  /// No description provided for @billAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get billAmount;

  /// No description provided for @billAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get billAmountInvalid;

  /// No description provided for @billSaveBiller.
  ///
  /// In en, this message translates to:
  /// **'Save this biller'**
  String get billSaveBiller;

  /// No description provided for @billSchedulePayment.
  ///
  /// In en, this message translates to:
  /// **'Schedule this payment'**
  String get billSchedulePayment;

  /// No description provided for @billContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get billContinue;

  /// No description provided for @billNoMoneyNotice.
  ///
  /// In en, this message translates to:
  /// **'Demo only. No payment will be made.'**
  String get billNoMoneyNotice;

  /// No description provided for @billConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Review demo payment'**
  String get billConfirmTitle;

  /// No description provided for @billConfirmPrompt.
  ///
  /// In en, this message translates to:
  /// **'Pay ₦{amount} to {biller} for reference {reference}? This is a local demo only.'**
  String billConfirmPrompt(String amount, String biller, String reference);

  /// No description provided for @billDemoPayAction.
  ///
  /// In en, this message translates to:
  /// **'Complete demo'**
  String get billDemoPayAction;

  /// No description provided for @billDemoResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo complete'**
  String get billDemoResultTitle;

  /// No description provided for @billDemoResultBody.
  ///
  /// In en, this message translates to:
  /// **'This was a local simulation. No biller was contacted, no token was issued, and no money moved.'**
  String get billDemoResultBody;

  /// No description provided for @billDemoSavedBillerNote.
  ///
  /// In en, this message translates to:
  /// **'In a live app this would save the biller; nothing was stored in this preview.'**
  String get billDemoSavedBillerNote;

  /// No description provided for @billDemoScheduleNote.
  ///
  /// In en, this message translates to:
  /// **'In a live app this would start a scheduled-payment flow; no schedule was created here.'**
  String get billDemoScheduleNote;

  /// No description provided for @billCatalogLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load bill categories and providers.'**
  String get billCatalogLoadError;

  /// No description provided for @billCatalogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bill categories match your search.'**
  String get billCatalogEmpty;

  /// No description provided for @billBillerCount.
  ///
  /// In en, this message translates to:
  /// **'{count} providers'**
  String billBillerCount(int count);

  /// No description provided for @billSavedBillers.
  ///
  /// In en, this message translates to:
  /// **'Saved billers'**
  String get billSavedBillers;

  /// No description provided for @billSavedLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load saved billers.'**
  String get billSavedLoadError;

  /// No description provided for @billSavedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your saved billers will appear here.'**
  String get billSavedEmpty;

  /// No description provided for @billBillerSelection.
  ///
  /// In en, this message translates to:
  /// **'Choose a provider'**
  String get billBillerSelection;

  /// No description provided for @billNoProviders.
  ///
  /// In en, this message translates to:
  /// **'No providers are currently available for this category.'**
  String get billNoProviders;

  /// No description provided for @billPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay bill'**
  String get billPaymentTitle;

  /// No description provided for @billProductUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This biller or product is no longer available. Return to categories and choose another.'**
  String get billProductUnavailable;

  /// No description provided for @billHelpText.
  ///
  /// In en, this message translates to:
  /// **'Choose a provider and product, validate the customer reference, then review the amount before authorizing with your transaction PIN.'**
  String get billHelpText;

  /// No description provided for @billReferenceRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer reference.'**
  String get billReferenceRequired;

  /// No description provided for @billValidationError.
  ///
  /// In en, this message translates to:
  /// **'We could not validate this bill reference. Check it and try again.'**
  String get billValidationError;

  /// No description provided for @billValidateFirst.
  ///
  /// In en, this message translates to:
  /// **'Validate the customer reference before continuing.'**
  String get billValidateFirst;

  /// No description provided for @billValidationExpired.
  ///
  /// In en, this message translates to:
  /// **'This validation expired. Validate the customer reference again.'**
  String get billValidationExpired;

  /// No description provided for @billValidationExpires.
  ///
  /// In en, this message translates to:
  /// **'Validation expires at {date}.'**
  String billValidationExpires(String date);

  /// No description provided for @billDeliveryPhone.
  ///
  /// In en, this message translates to:
  /// **'Token delivery phone (optional)'**
  String get billDeliveryPhone;

  /// No description provided for @billDeliveryPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'A prepaid token is shown only after the provider confirms delivery.'**
  String get billDeliveryPhoneHelper;

  /// No description provided for @billAmountHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount supplied by your biller.'**
  String get billAmountHelper;

  /// No description provided for @billFixedAmount.
  ///
  /// In en, this message translates to:
  /// **'Provider-set amount'**
  String get billFixedAmount;

  /// No description provided for @billAmountRange.
  ///
  /// In en, this message translates to:
  /// **'Allowed amount: {minimum} to {maximum}'**
  String billAmountRange(String minimum, String maximum);

  /// No description provided for @billAmountBelowMinimum.
  ///
  /// In en, this message translates to:
  /// **'The amount is below the minimum set by the provider.'**
  String get billAmountBelowMinimum;

  /// No description provided for @billAmountAboveMaximum.
  ///
  /// In en, this message translates to:
  /// **'The amount exceeds the maximum set by the provider.'**
  String get billAmountAboveMaximum;

  /// No description provided for @billLiveConfirmPrompt.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} to {biller}? Review the provider and amount before authorizing.'**
  String billLiveConfirmPrompt(String amount, String biller);

  /// No description provided for @billPaymentError.
  ///
  /// In en, this message translates to:
  /// **'We could not confirm the bill payment result. Check transaction history before retrying.'**
  String get billPaymentError;

  /// No description provided for @billPinVerificationError.
  ///
  /// In en, this message translates to:
  /// **'We could not verify your transaction PIN. Check it and try again.'**
  String get billPinVerificationError;

  /// No description provided for @billResultPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment processing'**
  String get billResultPendingTitle;

  /// No description provided for @billResultPending.
  ///
  /// In en, this message translates to:
  /// **'The biller is still processing this request. Check transaction history for the final status.'**
  String get billResultPending;

  /// No description provided for @billResultSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get billResultSuccessTitle;

  /// No description provided for @billResultSuccess.
  ///
  /// In en, this message translates to:
  /// **'The biller confirmed this payment.'**
  String get billResultSuccess;

  /// No description provided for @billResultFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment not completed'**
  String get billResultFailedTitle;

  /// No description provided for @billResultFailed.
  ///
  /// In en, this message translates to:
  /// **'The biller did not confirm this payment. Check your account and transaction history for updates.'**
  String get billResultFailed;

  /// No description provided for @billResultRefunded.
  ///
  /// In en, this message translates to:
  /// **'The biller did not complete the vend. The refund is confirmed.'**
  String get billResultRefunded;

  /// No description provided for @billResultReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Check payment status'**
  String get billResultReviewTitle;

  /// No description provided for @billDoNotRetry.
  ///
  /// In en, this message translates to:
  /// **'The provider or refund status is unresolved. Do not start another payment for this bill yet. Check transaction history or contact support.'**
  String get billDoNotRetry;

  /// No description provided for @billTokenDeliveryFailed.
  ///
  /// In en, this message translates to:
  /// **'The bill was charged, but the prepaid token was not confirmed as delivered. Do not pay again; check transaction history or contact support.'**
  String get billTokenDeliveryFailed;

  /// No description provided for @billRefundFailed.
  ///
  /// In en, this message translates to:
  /// **'The biller did not complete the vend and the refund is not confirmed. Do not retry; check transaction history or contact support.'**
  String get billRefundFailed;

  /// No description provided for @billVendToken.
  ///
  /// In en, this message translates to:
  /// **'Vend token'**
  String get billVendToken;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @paymentsClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get paymentsClearSearch;

  /// No description provided for @paymentsRecipientFallback.
  ///
  /// In en, this message translates to:
  /// **'Saved recipient'**
  String get paymentsRecipientFallback;

  /// No description provided for @paymentsBeneficiarySearch.
  ///
  /// In en, this message translates to:
  /// **'Search name, bank, or account number'**
  String get paymentsBeneficiarySearch;

  /// No description provided for @paymentsRecipientDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete saved recipient'**
  String get paymentsRecipientDeleteAction;

  /// No description provided for @paymentsRecipientDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete saved recipient?'**
  String get paymentsRecipientDeleteTitle;

  /// No description provided for @paymentsRecipientDeletePrompt.
  ///
  /// In en, this message translates to:
  /// **'This removes the recipient from your saved list. It does not affect past payments.'**
  String get paymentsRecipientDeletePrompt;

  /// No description provided for @paymentsRecipientDeleted.
  ///
  /// In en, this message translates to:
  /// **'Saved recipient deleted.'**
  String get paymentsRecipientDeleted;

  /// No description provided for @paymentsRecipientDeleteError.
  ///
  /// In en, this message translates to:
  /// **'We could not delete this recipient. Try again.'**
  String get paymentsRecipientDeleteError;

  /// No description provided for @paymentsRecipientDeleteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This saved recipient has no ID, so it cannot be deleted.'**
  String get paymentsRecipientDeleteUnavailable;

  /// No description provided for @limitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account limits'**
  String get limitsTitle;

  /// No description provided for @limitsInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'About these limits'**
  String get limitsInfoTitle;

  /// No description provided for @limitsInfoBody.
  ///
  /// In en, this message translates to:
  /// **'These values come from your account service. Daily usage is shown only when reported by the API.'**
  String get limitsInfoBody;

  /// No description provided for @limitsTierStatus.
  ///
  /// In en, this message translates to:
  /// **'Your account tier'**
  String get limitsTierStatus;

  /// No description provided for @limitsTierUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Tier information unavailable'**
  String get limitsTierUnavailable;

  /// No description provided for @limitsCurrentTier.
  ///
  /// In en, this message translates to:
  /// **'Tier {tier}'**
  String limitsCurrentTier(String tier);

  /// No description provided for @limitsDailyTransfer.
  ///
  /// In en, this message translates to:
  /// **'Daily outgoing limit'**
  String get limitsDailyTransfer;

  /// No description provided for @limitsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get limitsUnavailable;

  /// No description provided for @limitsUsageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Daily usage is not available from the account service.'**
  String get limitsUsageUnavailable;

  /// No description provided for @limitsDailyUsage.
  ///
  /// In en, this message translates to:
  /// **'{used} used · {remaining} remaining'**
  String limitsDailyUsage(String used, String remaining);

  /// No description provided for @limitsSingleTransfer.
  ///
  /// In en, this message translates to:
  /// **'Single transfer limit'**
  String get limitsSingleTransfer;

  /// No description provided for @limitsSingleTransferDescription.
  ///
  /// In en, this message translates to:
  /// **'Maximum outgoing amount per transaction, as returned for this account.'**
  String get limitsSingleTransferDescription;

  /// No description provided for @limitsBalanceCap.
  ///
  /// In en, this message translates to:
  /// **'Account balance ceiling'**
  String get limitsBalanceCap;

  /// No description provided for @limitsBalanceUsageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Balance usage is not available from the account service.'**
  String get limitsBalanceUsageUnavailable;

  /// No description provided for @limitsBalanceUsage.
  ///
  /// In en, this message translates to:
  /// **'Ledger balance {balance} · {percent}% of ceiling'**
  String limitsBalanceUsage(String balance, String percent);

  /// No description provided for @limitsUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Need a higher limit?'**
  String get limitsUpgradeTitle;

  /// No description provided for @limitsUpgradeBody.
  ///
  /// In en, this message translates to:
  /// **'Your tier and current account limits are shown here. Upgrade options will be available when the bank enables the required verification flow.'**
  String get limitsUpgradeBody;

  /// No description provided for @limitsUpgradeAction.
  ///
  /// In en, this message translates to:
  /// **'Check upgrade options'**
  String get limitsUpgradeAction;

  /// No description provided for @limitsUpgradeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The current API does not define the KYC requirements, document upload, or submission flow needed to request a tier upgrade.'**
  String get limitsUpgradeUnavailable;

  /// No description provided for @statementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account statements'**
  String get statementsTitle;

  /// No description provided for @statementsIntro.
  ///
  /// In en, this message translates to:
  /// **'Request a PDF statement for this account. Your selected range is checked against the maximum period configured by the bank.'**
  String get statementsIntro;

  /// No description provided for @statementsDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get statementsDateRange;

  /// No description provided for @statementsSelectedDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days selected'**
  String statementsSelectedDays(String days);

  /// No description provided for @statementsLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get statementsLast30Days;

  /// No description provided for @statementsLast90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get statementsLast90Days;

  /// No description provided for @statementsLast180Days.
  ///
  /// In en, this message translates to:
  /// **'Last 180 days'**
  String get statementsLast180Days;

  /// No description provided for @statementsCustomRange.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get statementsCustomRange;

  /// No description provided for @statementsChooseRange.
  ///
  /// In en, this message translates to:
  /// **'Choose statement period'**
  String get statementsChooseRange;

  /// No description provided for @statementsFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get statementsFrom;

  /// No description provided for @statementsTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get statementsTo;

  /// No description provided for @statementsPdfOnly.
  ///
  /// In en, this message translates to:
  /// **'PDF statement'**
  String get statementsPdfOnly;

  /// No description provided for @statementsEmailTo.
  ///
  /// In en, this message translates to:
  /// **'Email to registered address: {email}'**
  String statementsEmailTo(String email);

  /// No description provided for @statementsEmailUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Email delivery is unavailable for this account.'**
  String get statementsEmailUnavailable;

  /// No description provided for @statementsEmailStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Registered email availability has not loaded.'**
  String get statementsEmailStatusUnavailable;

  /// No description provided for @statementsOptionsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading account statement options and recent requests.'**
  String get statementsOptionsLoading;

  /// No description provided for @statementsHistoryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Request history is unavailable until the statement service responds.'**
  String get statementsHistoryUnavailable;

  /// No description provided for @statementsDownloadAction.
  ///
  /// In en, this message translates to:
  /// **'Generate and download PDF'**
  String get statementsDownloadAction;

  /// No description provided for @statementsEmailAction.
  ///
  /// In en, this message translates to:
  /// **'Generate and email PDF'**
  String get statementsEmailAction;

  /// No description provided for @statementsHistory.
  ///
  /// In en, this message translates to:
  /// **'Past statement requests'**
  String get statementsHistory;

  /// No description provided for @statementsHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no past statement requests.'**
  String get statementsHistoryEmpty;

  /// No description provided for @statementsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load statement options and request history. Try again later.'**
  String get statementsLoadError;

  /// No description provided for @statementsRangeTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This range is {days} days. The maximum allowed range is {maximum} days. Choose a shorter period.'**
  String statementsRangeTooLarge(String days, String maximum);

  /// No description provided for @statementsRequestError.
  ///
  /// In en, this message translates to:
  /// **'We could not submit the statement request. Check your connection and try again.'**
  String get statementsRequestError;

  /// No description provided for @statementsDownloadError.
  ///
  /// In en, this message translates to:
  /// **'We could not download this statement. Try again when it is ready.'**
  String get statementsDownloadError;

  /// No description provided for @statementsDownloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Account statement PDF'**
  String get statementsDownloadTitle;

  /// No description provided for @statementsRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Statement generation failed. You can submit a new request.'**
  String get statementsRequestFailed;

  /// No description provided for @statementsEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Statement generated and sent to your registered email.'**
  String get statementsEmailSent;

  /// No description provided for @statementsEmailPending.
  ///
  /// In en, this message translates to:
  /// **'Statement is ready; delivery to your registered email is pending.'**
  String get statementsEmailPending;

  /// No description provided for @statementsEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Statement generated, but email delivery failed. You can download it from the request history.'**
  String get statementsEmailFailed;

  /// No description provided for @statementsGenerated.
  ///
  /// In en, this message translates to:
  /// **'Statement generated and ready to download.'**
  String get statementsGenerated;

  /// No description provided for @statementsDeliveryEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get statementsDeliveryEmail;

  /// No description provided for @statementsDeliveryDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get statementsDeliveryDownload;

  /// No description provided for @statementsStatusQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get statementsStatusQueued;

  /// No description provided for @statementsStatusGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating'**
  String get statementsStatusGenerating;

  /// No description provided for @statementsStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statementsStatusReady;

  /// No description provided for @statementsStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statementsStatusFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
