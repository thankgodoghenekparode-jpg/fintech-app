/// Localized copy supplied by the embedding host. This feature owns no i18n
/// catalog and does not couple presentation strings to an API response.
class PayAmSmallCopy {
  const PayAmSmallCopy({
    this.marketplaceTitle = 'Pay Am Small',
    this.marketplaceSubtitle = 'Marketplace',
    this.searchHint = 'Search products and categories',
    this.searchLabel = 'Search marketplace',
    this.categoriesTitle = 'Categories',
    this.allCategories = 'All',
    this.featuredProducts = 'Featured products',
    this.featuredVendors = 'Featured vendors',
    this.viewAll = 'View all',
    this.verifiedVendor = 'Verified vendor',
    this.openStorefront = 'Open storefront',
    this.productDetails = 'Product details',
    this.payInFull = 'Pay in full',
    this.priceLock = 'Price-lock',
    this.purchaseOptions = 'Purchase options',
    this.deliveryTerms = 'Delivery terms',
    this.lockedPricePromise = 'Price-lock terms',
    this.continueLabel = 'Continue',
    this.outOfStock = 'Out of stock',
    this.optionUnavailable = 'This option is unavailable',
    this.storefrontTitle = 'Vendor storefront',
    this.aboutVendor = 'About',
    this.storeProducts = 'Products',
    this.suspendedTitle = 'Vendor unavailable',
    this.suspendedBody = 'This vendor is not available right now.',
    this.emptyTitle = 'Nothing to show yet',
    this.emptyBody = 'Try another search or check back later.',
    this.errorTitle = 'We could not load this page',
    this.errorBody = 'Check your connection and try again.',
    this.restrictedTitle = 'Marketplace unavailable',
    this.restrictedBody = 'This content is not available for this account.',
    this.notFoundTitle = 'This item is unavailable',
    this.loading = 'Loading',
    this.retry = 'Try again',
    this.selectCategory = 'Select category',
    this.selectPurchaseOption = 'Select a purchase option',
    this.reviewsLabel = 'reviews',
    this.nonProductionNotice =
        'Preview only · Synthetic data · Not for payments',
    this.planSetupTitle = 'Configure Plan',
    this.planReviewTitle = 'Plan Summary & Terms',
    this.planStepOne = 'Step 1 of 2: Configure Plan',
    this.planStepTwo = 'Step 2 of 2: Review & Authorize',
    this.planItemsInVault = 'Items in this Price-Lock Vault',
    this.planAddAnotherItem = 'Add another item to this vault',
    this.planAddItemsUnavailable =
        'Adding items depends on the host cart flow.',
    this.planTargetAmount = 'Target vault amount',
    this.planDeadline = 'Plan deadline',
    this.planChooseDeadline = 'Choose a deadline',
    this.planDeadlineHelp =
        'The quote service checks the vendor’s committed lock window.',
    this.planFundingMethod = 'Top-up schedule & funding method',
    this.planManualFunding = 'Flexible / Manual',
    this.planAutomatedFunding = 'Automated schedule',
    this.planAutoSaveUnavailable =
        'Schedule fields are not defined by the API contract yet.',
    this.planQuoteDetails = 'Quote & fee summary',
    this.planRules = 'Price-Lock Rules & Transparency',
    this.planContinueReview = 'Review Plan Summary & Terms',
    this.planAccept = 'Accept & continue to PIN',
    this.planAcceptTerms =
        'I have reviewed and agree to the terms shown above.',
    this.planFullTerms = 'Terms & Merchant Agreement',
    this.planRefreshQuote = 'Refresh quote',
    this.planTryAgain = 'Try again',
    this.planQuoteLoading = 'Loading quote…',
    this.planCreating = 'Waiting for host authorization…',
    this.planQuoteError = 'We could not load the plan quote. Try again.',
    this.planVendorUnavailable = 'This vendor is not available right now.',
    this.planDeadlineInvalid =
        'Choose a deadline within the vendor’s committed lock window.',
    this.planRestricted = 'Plan setup is unavailable for this account.',
    this.planTermsChanged =
        'The plan terms changed. Refresh the quote before accepting.',
    this.planTermsMissing = 'The quote did not include reviewable terms.',
    this.planCreateError = 'The plan could not be created. Try again.',
    this.planCreated = 'Plan created',
    this.planCreatedBody = 'Your plan was created successfully.',
    this.planPreviewComplete = 'Preview acceptance complete',
    this.planPreviewCompleteBody =
        'This synthetic preview did not create a real plan or make a payment.',
    this.planQuoteNoFacts = 'Quote details will appear here when supplied.',
    this.planQuoteNoTerms = 'No plan terms were supplied by the quote.',
    this.planMonthNames = const [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
  });

  final String marketplaceTitle;
  final String marketplaceSubtitle;
  final String searchHint;
  final String searchLabel;
  final String categoriesTitle;
  final String allCategories;
  final String featuredProducts;
  final String featuredVendors;
  final String viewAll;
  final String verifiedVendor;
  final String openStorefront;
  final String productDetails;
  final String payInFull;
  final String priceLock;
  final String purchaseOptions;
  final String deliveryTerms;
  final String lockedPricePromise;
  final String continueLabel;
  final String outOfStock;
  final String optionUnavailable;
  final String storefrontTitle;
  final String aboutVendor;
  final String storeProducts;
  final String suspendedTitle;
  final String suspendedBody;
  final String emptyTitle;
  final String emptyBody;
  final String errorTitle;
  final String errorBody;
  final String restrictedTitle;
  final String restrictedBody;
  final String notFoundTitle;
  final String loading;
  final String retry;
  final String selectCategory;
  final String selectPurchaseOption;
  final String reviewsLabel;
  final String nonProductionNotice;
  final String planSetupTitle;
  final String planReviewTitle;
  final String planStepOne;
  final String planStepTwo;
  final String planItemsInVault;
  final String planAddAnotherItem;
  final String planAddItemsUnavailable;
  final String planTargetAmount;
  final String planDeadline;
  final String planChooseDeadline;
  final String planDeadlineHelp;
  final String planFundingMethod;
  final String planManualFunding;
  final String planAutomatedFunding;
  final String planAutoSaveUnavailable;
  final String planQuoteDetails;
  final String planRules;
  final String planContinueReview;
  final String planAccept;
  final String planAcceptTerms;
  final String planFullTerms;
  final String planRefreshQuote;
  final String planTryAgain;
  final String planQuoteLoading;
  final String planCreating;
  final String planQuoteError;
  final String planVendorUnavailable;
  final String planDeadlineInvalid;
  final String planRestricted;
  final String planTermsChanged;
  final String planTermsMissing;
  final String planCreateError;
  final String planCreated;
  final String planCreatedBody;
  final String planPreviewComplete;
  final String planPreviewCompleteBody;
  final String planQuoteNoFacts;
  final String planQuoteNoTerms;
  final List<String> planMonthNames;
}
