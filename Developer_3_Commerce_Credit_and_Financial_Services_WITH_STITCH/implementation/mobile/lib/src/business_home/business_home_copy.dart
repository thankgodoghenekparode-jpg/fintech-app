/// Localized content supplied by the host's central text layer.
abstract interface class MerchantHomeCopy {
  String get title;
  String get loading;
  String get errorTitle;
  String get errorBody;
  String get offlineTitle;
  String get offlineBody;
  String get retry;
  String get emptyTitle;
  String get emptyBody;
  String get createBusiness;
  String get switchBusiness;
  String get verified;
  String get restricted;
  String get availableBalance;
  String get balanceHidden;
  String get hideBalance;
  String get showBalance;
  String get todaySales;
  String get quickActions;
  String get collect;
  String get paymentLinkAction;
  String get invoice;
  String get refund;
  String get recentPayments;
  String get noPaymentsTitle;
  String get noPaymentsBody;
  String get settled;
  String get pending;
  String get failed;
  String get qrChannel;
  String get paymentLinkChannel;
  String get bankTransferChannel;
  String get paymentStatus;

  /// Delegates money and date rendering to the shared formatter/i18n layer.
  String formatMoney(int amountKobo);
  String formatPaymentDate(DateTime dateTime);
}
