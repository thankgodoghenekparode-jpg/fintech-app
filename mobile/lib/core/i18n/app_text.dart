/// Central English text catalog for the isolated Developer 2 workspace.
abstract final class AppText {
  static const appTitle = 'Group & Community';
  static const heading = 'Build together';
  static const description =
      'Your group banking and community tools in one place.';
  static const products = [
    'Cooperatives',
    'Ajo / Esusu',
    'Target Savings',
    'Revenue Collection',
    'Agent Network',
  ];
  static const createCooperative = 'Create cooperative';
  static const cooperativesHome = 'Cooperatives';
  static const cooperativeHomeDescription =
      'Group savings and shared financial tools for people who save together.';
  static const cooperativeSavingsSummary =
      'Total cooperative savings and shares';
  static const cooperativeSummaryUnavailable = 'Unavailable';
  static const activeCooperatives = 'Active societies';
  static const nextContribution = 'Next contribution';
  static const myCooperatives = 'My cooperatives';
  static const membershipDescription = 'Active memberships and governance';
  static const cooperativeEmptyTitle = 'Cooperative list unavailable';
  static const cooperativeEmptyInfo =
      'The service has not defined the cooperative list data yet, so we cannot tell whether you already belong to a group. You can still create a cooperative or join with a code.';
  static const joinCooperativeTitle = 'Join a cooperative';
  static const joinCooperativeHeadline = 'Join with an invite code';
  static const joinCooperativeInfo =
      'Enter the code shared by a cooperative admin to review the group before requesting to join.';
  static const cooperativeInviteCode = 'Invite code';
  static const cooperativeInviteCodeInvalid =
      'Enter a valid cooperative invite code.';
  static const previewCooperative = 'Preview cooperative';
  static const previewUnavailableAction = 'Preview unavailable';
  static const cooperativePreviewUnavailable =
      'Cooperative preview is unavailable because the service has not defined the preview response fields. No membership request was sent.';
  static const cooperativeHowTitle = 'How cooperatives work';
  static const cooperativeHowInfo =
      'Members save together, follow shared rules, and review group decisions. Available limits depend on verification.';
  static const openCreateCooperative = 'Create a cooperative';
  static const cooperativeDetails = 'Cooperative details';
  static const cooperativeType = 'Type and documents';
  static const principalAdmins = 'Principal admins';
  static const review = 'Review';
  static const name = 'Cooperative name';
  static const descriptionLabel = 'Description';
  static const meetingSchedule = 'Meeting schedule';
  static const nameRequired = 'Enter a name between 3 and 60 characters.';
  static const typeRegistered = 'Registered';
  static const typeInformal = 'Informal';
  static const registeredInfo =
      'Registered groups need a registration certificate and bye-laws before verification.';
  static const registeredUnavailable =
      'Registered cooperative setup is unavailable until document submission is connected. No request was sent.';
  static const informalUnavailable =
      'Informal cooperative setup needs officer identity details, but the service does not define how to submit them. No request was sent.';
  static const informalInfo =
      'Informal groups use a graduated trust level. Limits depend on verification.';
  static const adminPhone = 'Additional principal admin phone';
  static const addAdmin = 'Add another admin';
  static const removeAdmin = 'Remove admin';
  static const adminsInfo =
      'The creator is the first principal admin. Add one or two more.';
  static const adminsRequired = 'Add at least one other principal admin.';
  static const continueLabel = 'Continue';
  static const back = 'Back';
  static const submit = 'Create cooperative';
  static const submitting = 'Submitting request…';
  static const created = 'Creation request submitted';
  static const createdInfo =
      'Your cooperative is pending verification. Access may be restricted until verification is complete.';
  static const verificationReviewInfo =
      'After your setup is accepted, the cooperative may remain restricted until verification is complete.';
  static const done = 'Done';
  static const createError =
      'We could not submit the request. Check your connection and try again.';
  static const authMissing =
      'Sign in to your banking app before creating a cooperative.';
  static const apiUnconfigured =
      'The cooperative service is not configured on this build.';
  static const createCircle = 'Create an Ajo circle';
  static const circleDetails = 'Basics';
  static const payoutProtection = 'Protection';
  static const circleReview = 'Review your circle';
  static const circleName = 'Circle name';
  static const circleNameInvalid = 'Enter a name between 3 and 60 characters.';
  static const roundContribution = 'Contribution per round (NGN)';
  static const roundContributionInvalid =
      'Enter a valid amount greater than zero, with up to two decimal places.';
  static const frequencyLabel = 'Contribution frequency';
  static const slotsLabel = 'Number of members';
  static const slotsInvalid = 'A circle needs at least two members.';
  static const circlePotEstimate = 'Estimated group pot';
  static const circleDurationEstimate = 'Estimated final round';
  static const circlePlanEstimateNote =
      'Planning estimate assumes one payout per member at the selected frequency.';
  static const startDateLabel = 'Start date';
  static const startDateInvalid = 'Choose a date within the next 60 days.';
  static const payoutOrder = 'Payout order';
  static const orderRandom = 'Random draw';
  static const orderChosen = 'Members choose slots';
  static const orderOrganizer = 'Organizer sets order';
  static const orderOrganizerConsent =
      'Every member must agree to an organizer-set payout order.';
  static const orderStepInfo = 'Choose how members receive payout slots.';
  static const protectionLabel = 'Protection mode';
  static const protectedMode = 'Protected';
  static const safeguardsOnly = 'Safeguards only';
  static const protectedInfo = 'Members arrange guarantor or deposit cover.';
  static const safeguardsInfo =
      'No cover is provided. Verified identity, trust checks and auto-debit safeguards apply.';
  static const trustLimitInfo =
      'Circle limits depend on verification and are confirmed when you submit.';
  static const circleCreateInfo =
      'Circle dates and payout order lock once the cycle starts.';
  static const circleCreated = 'Circle created';
  static const circleCreatedInfo =
      'Your circle was created. The service did not return its circle ID, so you cannot open it or invite members from here yet. Do not submit another create request for the same circle.';
  static const circleCreateStatusUnknownTitle = 'Circle status unknown';
  static const circleCreateStatusUnknown =
      'We could not confirm whether this circle was created. Do not submit these same details again until you have checked its status with your service provider.';
  static const returnToAjo = 'Return to Ajo';
  static const ajoSummaryTitle = 'Your circles';
  static const ajoPooledValue = 'Total pooled volume';
  static const ajoActiveCircles = 'Active circles';
  static const ajoNextPayout = 'Next payout';
  static const ajoUnavailable = 'Unavailable';
  static const ajoNoCircles = 'Circle list is unavailable';
  static const ajoNoCirclesInfo =
      'The service has not defined the circle list data yet, so we cannot tell whether you already belong to a circle. You can still create a circle or join with a code.';
  static const ajoPendingInvitations = 'Pending invitations';
  static const ajoHowTitle = 'How Ajo works';
  static const ajoHowStepOne =
      'Members agree on a contribution, schedule, and payout order.';
  static const ajoHowStepTwo =
      'Members contribute on schedule while the agreed person receives the pot.';
  static const ajoHowStepThree =
      'Review each round and its status before taking action.';
  static const ajoJoinTitle = 'Join an Ajo circle';
  static const ajoJoinReviewInvite = 'Review a circle invite';
  static const ajoJoinInviteInfo =
      'Enter the invite code to review the contribution, schedule, payout order, and protection before deciding to join.';
  static const ajoInviteCode = 'Invite code';
  static const ajoInviteCodeInvalid = 'Enter a valid circle invite code.';
  static const ajoPreviewCircle = 'Preview circle';
  static const ajoPreviewUnavailableAction = 'Preview unavailable';
  static const ajoPreviewUnavailable =
      'Circle preview is unavailable because the service has not defined the invite-preview response fields. No join request was sent.';
  static const targetSavings = 'Target savings';
  static const targetSavingsIntro = 'Save toward what matters';
  static const targetSavingsDescription =
      'Create a goal and track your progress over time.';
  static const targetSavingsTotal = 'Total saved across goals';
  static const targetSavingsUnavailable = 'Unavailable';
  static const targetSavingsGoals = 'Your goals';
  static const targetSavingsListUnavailable =
      'Goal balances and progress will appear here when the savings service provides them.';
  static const targetSavingsStatusUnavailable = 'Goal data unavailable';
  static const targetGoalUnavailableTitle = 'Required goal data unavailable';
  static const targetGoalUnavailableInfo =
      'The service has not provided the goal details or response fields this screen needs. It will not estimate balances, charges, or terms.';
  static const targetSavingsPreviewTitle = 'Plan for a goal';
  static const targetSavingsPreviewDescription =
      'You could save toward a trip, school fees, or something important to you.';
  static const createTargetSavingsGoal = 'Create a goal';
  static const createSavingsGoalTitle = 'Create a savings goal';
  static const targetGoalSteps = ['Goal', 'Plan', 'Mode', 'Funding', 'Review'];
  static const targetStep = 'Step';
  static const targetGoalQuestion = 'What are you saving for?';
  static const targetGoalName = 'Goal name';
  static const targetGoalNameInvalid = 'Use at least 2 characters.';
  static const targetAmount = 'Target amount';
  static const targetAmountInvalid = 'Enter a valid amount in naira.';
  static const targetTheme = 'Choose a theme';
  static const targetThemes = [
    'General',
    'Travel',
    'Education',
    'Home',
    'Health'
  ];
  static const targetDateQuestion = 'When do you want to reach it?';
  static const targetDateInfo =
      'Choose when you want to reach your goal. Automatic contributions use a separate schedule.';
  static const targetDateAdd = 'Choose a target date';
  static const targetPlanFrequency = 'Estimate contributions';
  static const targetPlanEstimateFrequency = 'Estimate frequency';
  static const targetPlanEstimatePrefix = 'Suggested contribution';
  static const targetPlanEstimateInfo =
      'Planning estimate only. This does not schedule automatic contributions.';
  static const targetModeQuestion = 'Choose how your savings work';
  static const targetFlexible = 'Flexible';
  static const targetFlexibleInfo =
      'Access your savings under the product rules.';
  static const targetLocked = 'Locked';
  static const targetLockedInfo =
      'Keep savings set aside until the goal matures.';
  static const targetWithdrawalInfo =
      'Any withdrawal charge or restriction is confirmed by the service before you proceed.';
  static const targetFundingPlan = 'Funding plan';
  static const targetAutoSaveUnavailable =
      'Automatic saving needs a separate schedule. The create service does not return a goal ID, so schedule setup is unavailable here.';
  static const targetFirstDeposit = 'First deposit (optional)';
  static const targetDepositPinInfo = 'A first deposit requires PIN approval.';
  static const targetReview = 'Review your goal';
  static const targetNoDate = 'No date set';
  static const targetAutoSaveNotConfigured = 'Not configured';
  static const targetOff = 'Off';
  static const targetNoDeposit = 'None';
  static const targetPinRequired = 'PIN setup required';
  static const targetCreateNeedsPin =
      'Creating a goal and authorizing a first deposit requires your banking PIN.';
  static const targetPinPrompt = 'Enter your 4-digit transaction PIN';
  static const targetPinContinue = 'Continue';
  static const targetPinCancel = 'Cancel';
  static const targetCreateSuccess = 'Goal created';
  static const targetCreateAutoSaveNotEnabled =
      'Your goal was created, but automatic saving was not set up. The service did not return a goal ID, so the app cannot open its schedule setup.';
  static const targetCreateError =
      'We could not create your goal. Check your connection and try again.';
  static const targetPinError =
      'PIN verification failed. Check your PIN and try again.';
  static const targetDateRequired = 'Choose a target date to continue.';
  static const targetDepositInvalid = 'Enter a valid first deposit amount.';
  static const targetAutoSaveTitle = 'Automatic savings';
  static const targetAutoSaveFrequency = 'Contribution frequency';
  static const targetAutoSaveAmount = 'Contribution amount';
  static const targetAutoSaveStartDate = 'First contribution date';
  static const targetAutoSaveConsent = 'I agree to automatic contributions';
  static const targetAutoSaveConsentInfo =
      'The selected amount will be requested on this schedule. Contributions depend on available funds and the service rules.';
  static const targetAutoSavePreviewUnavailable =
      'Goal progress and a completion estimate are unavailable until goal details are connected.';
  static const targetTopUpTitle = 'Add money';
  static const targetTopUpAmount = 'Amount to add';
  static const targetTopUpBalanceUnavailable =
      'Main account balance is unavailable. The service will check available funds when you confirm.';
  static const targetTopUpConfirm = 'Review top-up';
  static const targetTopUpConfirmInfo =
      'Confirm adding this amount to your savings goal from your main account. Any applicable service rules are checked when you submit.';
  static const targetTopUpSuccess = 'Top-up submitted';
  static const targetTopUpSubmittedAmount = 'Amount submitted';
  static const targetTopUpSuccessInfo =
      'The service accepted your top-up request. Check your goal activity for the posted result.';
  static const targetTopUpError =
      'We could not submit the top-up. Check your connection and try again.';
  static const targetTopUpRetry = 'Retry same top-up';
  static const revenueReferenceRequired =
      'Requires a real bill or payer reference.';
  static const targetAutoSaveDateRequired = 'Choose a future start date.';
  static const targetAutoSaveConsentRequired =
      'Review and accept the automatic contribution consent to continue.';
  static const targetAutoSaveSuccess = 'Automatic savings set up';
  static const targetAutoSaveSuccessInfo =
      'Your contribution schedule was saved.';
  static const targetAutoSaveError =
      'We could not save this schedule. Check your connection and try again.';
  static const targetAutoSaveInsufficient =
      'The service could not set up this schedule because funds are insufficient.';
  static const targetFrequencyDaily = 'Daily';
  static const targetFrequencyWeekly = 'Weekly';
  static const targetFrequencyMonthly = 'Monthly';
  static const targetRetry = 'Retry with same request';
  static const targetAutoSaveConsentDetail =
      'I authorize automatic contributions using the schedule selected above.';
  static const circleCreateError =
      'We could not create the circle. Check the details and try again.';
  static const frequencyDaily = 'Daily';
  static const frequencyWeekly = 'Weekly';
  static const frequencyMonthly = 'Monthly';
  static const currencySymbol = '₦';
  static const platformNoGuarantee = 'The platform does not guarantee payouts.';
  static const selectStartDate = 'Choose a start date';
  static const contributionDetails = 'Contribution details';
  static const memberCount = 'Members';
  static const startDateReview = 'Start date';
  static const orderReview = 'Payout order';
  static const protectionReview = 'Protection';
}
