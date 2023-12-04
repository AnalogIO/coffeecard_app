abstract final class Strings {
  static const appTitle = 'Cafe Analog';

  // Titles for the app bar.
  static const ticketsPageTitle = 'Tickets';
  static const statsPageTitle = 'Statistics';
  static const buyOneDrinkPageTitle = 'Buy one drink';
  static const buyOtherPageTitle = 'Buy other';
  static const redeemVoucherPageTitle = 'Redeem voucher';

  // Titles for the navigation bar.
  static const ticketsNavTitle = ticketsPageTitle;
  static const receiptsNavTitle = receiptsPageTitle;
  static const statsNavTitle = 'Stats';
  static const settingsNavTitle = settingsPageTitle;

  // Login email hint and errors
  static const loginPasscodeHint = 'Enter passcode';
  static const loginPasscodeEmpty = 'Enter a passcode';
  static const loginHintEmail = 'Email...';
  static const loginTooltipContinue = 'Continue';

  static const loginEnterEmailError = 'Please enter an email';
  static const loginInvalidEmailError = 'Please enter a valid email';

  static const loginSignIn = 'Sign in';
  static const loginCreateAccount = "Don't have an account? Make one";
  static const loginSignInOtherAccount = 'Sign in using another account';

  static const loginForgotYourPasscode = 'Forgot your passcode?';
  static const loginForgot = 'Forgot?';

  // Barista hub
  static const baristaTickets = 'Barista tickets';
  static String perksTitle(String role) => '$role perks';
  static const baristaPerksExplainer =
      'As a contributor to the cafe, you have access to special perks that you can redeem here in the app.';

  static const loginResendVerificationEmail = 'Resend verification email';
  static const loginVerificationEmailSent = 'Verification email sent';
  static String loginVerificationEmailBody(String email) =>
      'We have sent an email to $email, please check your spam folder';

  // Environment
  static const environmentTitle = 'Connected to test environment';
  static const environmentDescription = [
    'The functionality of this app is for testing purposes only.',
    'User account information is not shared with the production environment. This means you will need a separate account for this environment.',
    'Tickets you buy or swipe are *NOT VALID* for use at Cafe Analog.',
  ];
  static const environmentUnderstood = 'Understood';

  // Tickets
  static const ticketsMyTickets = 'My tickets';
  static const shopText = 'Shop';
  static const buyTickets = 'Buy tickets';
  static const buyOneDrink = 'Buy one drink';
  static const buyOther = 'Buy syrup, jugs etc.';
  static const redeemVoucher = 'Redeem voucher';
  static const newLabel = 'NEW';
  static const comingSoonLabel = 'COMING SOON';

  // Opening hours
  static const closed = 'closed';
  static const openingHoursIndicatorPrefix = "We're";
  static const openingHoursDisclaimer =
      'Holidays and exam periods may affect opening hours.';
  static const Map<int, String> weekdaysPlural = {
    DateTime.monday: 'Mondays',
    DateTime.tuesday: 'Tuesdays',
    DateTime.wednesday: 'Wednesdays',
    DateTime.thursday: 'Thursdays',
    DateTime.friday: 'Fridays',
    DateTime.saturday: 'Saturdays',
    DateTime.sunday: 'Sundays',
  };

  // Register
  static const registerAppBarTitle = 'Register';

  static const registerEmailTitle = 'Enter your email';
  static const registerEmailLabel = email;
  static const registerEmailHint =
      'You will need to verify your email address later.';
  static const registerEmailEmpty = 'Enter an email';
  static const registerEmailInvalid = 'Enter a valid email';
  static String registerEmailInUse(String email) => '$email is already in use';

  static const registerPasscodeTitle = loginPasscodeEmpty;
  static const registerPasscodeLabel = 'Passcode';
  static const registerPasscodeRepeatTitle = 'Repeat the passcode';
  static const registerPasscodeRepeatLabel = 'Repeat passcode';
  static const registerPasscodeHint =
      'Enter a four-digit passcode for your account.';
  static const registerPasscodeEmpty = 'Enter a passcode';
  static const registerPasscodeTooShort = 'Enter a four-digit passcode';
  static const registerPasscodeRepeatEmpty = 'Repeat the passcode';
  static const registerPasscodeDoesNotMatch = 'Passcodes do not match';

  static const registerOccupationTitle = "What's your occupation?";

  static const registerNameTitle = 'Enter your name';
  static const registerNameLabel = 'Name';
  static const registerNameEmpty = 'Enter a name';

  static const registerTermsHeading = 'Privacy policy';
  static const registerTermsIntroduction =
      'By creating a user, you accept our privacy policy:';
  static const registerTerms = [
    'Your email is stored only for identification of users in the app.',
    'Your name may be shown on the leaderboard, both in the app and in Cafe Analog. If you are not comfortable with this, you can choose to appear anonymous in the app under Settings.',
    'At any time, you can choose to recall this consent by sending an email to support@analogio.dk.',
  ];
  static const registerFailureHeading = 'Whoops...';
  static const registerFailureBody =
      'Something went wrong while creating your account:';
  static const registerSuccessHeading = 'Success!';
  static const registerSuccessBody =
      "To log in, please verify your email address by clicking the link we've sent to ";

  // Forgot passcode
  static const forgotPasscode = 'Forgot passcode';
  static const forgotPasscodeHint =
      "We'll send you a link to reset your passcode.";
  static const forgotPasscodeNoAccountExists =
      'No account exists with that email';
  static const forgotPasscodeLinkSent = 'Passcode reset link sent';
  static String forgotPasscodeSentRequestTo(String email) =>
      "We've sent a request to reset your passcode to $email.";
  static const forgotPasscodeError = 'An error has occurred';

  // Buttons
  static const buttonContinue = 'Continue';
  static const buttonOK = 'OK';
  static const buttonClose = 'Close';
  static const buttonAccept = 'Accept';
  static const buttonDecline = 'Decline';
  static const buttonGotIt = 'Got it';
  static const buttonCancel = 'Cancel';
  static const buttonUnderstand = 'I understand';
  static const buttonTryAgain = 'Try again';

  // Coffee/ticket card
  static const emptyCoffeeCardTextTop =
      'Tickets that you buy will show up here.';
  static const emptyCoffeeCardTextBottom =
      'Use the section below to shop tickets.';
  static const useTicket = 'Use ticket';

  // "Buy ticket" card
  static const paymentOptionMobilePay = 'MobilePay';
  static const paymentOptionOther = 'Other...';
  static const paymentOptionOtherComingSoon = 'This feature is coming soon';

  // Modal explainer
  static const confirmSwipe = 'Confirm use of ticket';
  static const confirmPurchase = 'Confirm purchase';
  static const tapHereToCancel = 'Tap here to cancel';
  static const String paymentConfirmationButtonRedeem = 'Get your free product';

  static String paymentConfirmationTopTickets(int amount, String title) {
    return "You're buying $amount $title tickets";
  }

  static String paymentConfirmationTopSingle(int amount, String title) {
    return "You're buying and swiping $amount $title";
  }

  static String paymentConfirmationBottomPurchase(int price) {
    return 'Pay $price,- with...';
  }

  static String amountTickets(int amount) {
    return '$amount tickets';
  }

  static String price(int price) {
    return '$price,-';
  }

  static const free = 'FREE';

  // Purchase process
  static const purchaseErrorOk = 'Ok';
  static const purchaseTalking = 'Talking with payment provider';
  static const purchaseCompleting = 'Completing purchase';
  static const purchaseSuccess = 'Success';
  static const purchaseRejectedOrCanceled = 'Payment rejected or canceled';
  static const purchaseRejectedOrCanceledMessage =
      'The payment was rejected or cancelled. No tickets have been added to your account';
  static const purchaseError = "Uh oh, we couldn't complete that purchase";
  static const purchaseTimeout = 'Purchase timed out';
  static const purchaseTimeoutMessage =
      'The payment confirmation was not received in time. If you have completed the purchase in MobilePay, please wait a few minutes';

  // Receipts
  static const receiptsPageTitle = 'Receipts';
  static const singleReceiptPageTitle = 'Receipt';

  static const oneTicket = '1 ticket';
  static const purchased = 'Purchased';
  static const swiped = 'Swiped';

  static const receiptFilterAll = 'Swipes & purchases';
  static const receiptFilterSwipes = 'Swipes';
  static const receiptFilterPurchases = 'Purchases';

  static const receiptPlaceholderName = 'Swiped Espresso based';
  static const receiptCardSwiped = 'Ticket swiped';
  static const receiptCardPurchased = 'Purchased';
  static const receiptCardNote =
      'This can be found again under $receiptsPageTitle.';
  static const receiptTapAnywhereToDismiss = 'Tap anywhere to dismiss';

  static const receipts = 'receipts';
  static String noReceiptsOfTypeTitle(String noneOfType) =>
      "You don't have any $noneOfType... yet.";

  static const buy = 'buy';
  static const swipe = 'swipe';
  static const buyOrSwipe = '$buy or $swipe';
  static String noReceiptsOfTypeMessage(String buyOrSwipe) =>
      'When you $buyOrSwipe tickets, they will show up here.\nGo to the Tickets tab to $buyOrSwipe tickets.';

  // PaymentStatus enum
  static const paymentStatusCompleted = 'Purchased';
  static const paymentStatusRefunded = 'Purchase refunded';
  static const paymentStatusAwaitingPayment = 'Payment pending';
  static const paymentStatusReserved = 'Payment reserved';
  static const paymentStatusFailed = 'Payment failed';

  // Statistics page
  static const statsYourStats = 'Your stats';
  static const statsLeaderboards = 'Leaderboards';

  static const statsShowTopDrinkerFor = 'Show top drinkers';
  static const statsFilterSemester = 'Semester';
  static const statsFilterMonth = 'Month';
  static const statsFilterTotal = 'Total';

  static const statCardMonth = 'Your rank this month';
  static const statCardSemester = 'Your rank this semester';
  static const statCardTotal = 'Your rank (all time)';

  static const statCup = 'cup';
  static const statCups = 'cups';

  // Redeem Voucher
  static const voucherHint = 'Enter a voucher code to redeem it.';
  static const voucherCode = 'Voucher code';
  static const voucherEmpty = 'Enter a voucher code';
  static const voucherUsed = 'That voucher is already used';
  static const voucherRedeemed = 'Voucher redeemed 🎉';
  static String voucherYouRedeemedProducts(
    int numberOfTickets,
    String productName,
  ) =>
      'You redeemed $numberOfTickets $productName!';

  // Settings
  static const settingsPageTitle = 'Settings';
  static const yourProfilePageTitle = 'Your profile';

  static const settingsGroupAccount = 'Account';
  static const settingsGroupFeatures = 'Features';
  static const settingsGroupAbout = 'About';
  static const settingsGroupProfile = 'Edit profile';

  static const email = 'Email';
  static const passcode = 'Passcode';
  static const change = 'Change';
  static const logOut = 'Log out';
  static const deleteAccount = 'Delete account';
  static const credits = 'Credits';
  static const privacyPolicy = 'Privacy policy';

  static const emailShimmerText = 'sample@sample.com';
  static const openingHoursShimmerText = 'Somedays: 8-16';

  static const changeEmail = 'Change email';
  static const changeName = 'Change name';
  static const changeOccupation = 'Change occupation';
  static const changePasscode = 'Change passcode';
  static const changeEmailCannotBeSame =
      'New email cannot be the same as the old one';
  static const changeEmailLogInAgain =
      'After changing your email, you must log in again.';
  static const changeEmailSuccess = 'Email changed!';
  static const changeEmailLogInAgainNewEmail =
      'Please log in again with your updated email.';

  static const changePasscodeTitle = 'Enter a new passcode';
  static const changePasscodeLabel = 'New passcode';
  static const changePasscodeHint = 'Enter a new passcode for your account.';
  static const changePasscodeRepeatTitle = 'Repeat the new passcode';
  static const changePasscodeRepeatLabel = 'Repeat new passcode';

  static const deleteAccountText =
      'Performing this action will delete your account and any tickets you own.\n\nThis cannot be undone.\n\nAre you sure you want to proceed?';
  static String deleteAccountEmailConfirmation(String email) =>
      'We have sent a verification link to $email.\n\nPlease confirm your request to delete your account using the provided link.';

  static const frequentlyAskedQuestions = 'Frequently Asked Questions';
  static const faq = 'FAQ';
  static const openingHours = 'Opening hours';
  static const notAvailable = 'Not available';
  static const today = 'Today';

  static const name = 'Name';
  static const occupation = 'Occupation';
  static const occupationPlaceholder = 'Occupation name fullname';
  static const appearAnonymous = 'Appear anonymous on leaderboard';
  static const appearAnonymousSmall = 'Appear anonymous';
  static const yourProfileDescription =
      'These settings affect your appearance on the leaderboards.';

  static const madeBy = 'Made with ❤ by AnalogIO\nIT University of Copenhagen';
  static const userID = 'User ID';

  // FAQ
  static const faqEntries = {
    'What is the purpose of this app?':
        "This app replaces Cafe Analog's physical coffee card. The idea is that you swipe a ticket when you pour yourself coffee, or show your phone to the barista when swiping a ticket for another beverage.",
    'What is Coffee drinker of the semester?':
        'At the end of each semester, the leaderboards are checked. The person with the most swipes during the semester is crowned Coffee drinker of the semester! They will be rewarded with a special cup that is entitled to free filter coffee refills for the entirety of the next semester. Check how you stack up against the competition under the Statistics tab.',
    "Where'd my tickets go?":
        'Logged in to find no tickets associated with your account? Try checking if you have had any recent activity in the Receipts page. If not, you may be logged into the wrong account.',
    'Where can I find my ID?':
        'You can find your ID at the bottom of the settings page.',
    'Can I buy tickets with cash or card?':
        'You can buy physical coffee cards in the cafe. We are planning to add Google Pay and Apple Pay integration in the app.',
    "Something doesn't seem to work.":
        "If you find something that doesn't seem right, please report it by filling out of the feedback form found under 'Settings > Report a bug or send feedback'.",
    'I have an idea for the app!':
        "We will happily take suggestions! Fill out the feedback form under 'Settings > Report a bug or send feedback' or send an email to feedback@analogio.dk.",
  };

  // Credits
  static const developmentTeam = 'Development team';
  static const aboutAnalogIO = 'About AnalogIO';
  static const analogIOBody =
      "AnalogIO is a group of volunteer software students, supporting the student organization Cafe Analog.\n\nWe create and maintain backend systems, apps and websites for both customers and baristas of the cafe.\n\nWant to help? Have any feedback? Don't hesitate to contact us.";
  static const github = 'GitHub';
  static const provideFeedback = 'Provide feedback or report a bug';
  static const licenses = 'Licenses';
  static const viewLicenses = 'View licenses';

  // Time since utility
  static const justNow = 'just now';
  static const earlierToday = 'earlier today';
  static const yesterday = 'yesterday';
  static const ago = 'ago';
  static const inTheFuture = 'in the future';

  static String minutesAgo(int minutes) =>
      minutes == 1 ? 'a minute $ago' : '$minutes minutes $ago';

  static String hoursAgo(int hours) {
    return hours == 1 ? 'an hour ago' : '$hours hours ago';
  }

  static String daysAgo(int days) {
    return days == 1 ? 'yesterday' : '$days days $ago';
  }

  static String yearsAgo(int years) {
    return years == 1 ? 'a year $ago' : '$years years $ago';
  }

  static String monthsAgo(int months) {
    return months == 1 ? 'a month $ago' : '$months months $ago';
  }

  static String around(String time) => 'around $time';
  static String almost(String time) => 'almost $time';
  static String moreThan(String time) => 'more than $time';

  // Upgrader
  static const upgraderUpdateAvailable = 'An update is available, click ';
  static const upgraderHere = 'here';
  static const upgraderToDownload = ' to download it';

  // Errors
  static const error = 'Error';
  static const cantLaunchUrl = 'The app can not launch the Url';
  static const emailValidationError =
      'An error occurred. Try typing your email again.';

  static String unknownFilterCategory(Object category) {
    return 'Unknown filter category: $category';
  }

  static String invalidRoute(String c, String? route) {
    return '($c) Unknown route: $route';
  }

  static String invalidVoucher(String voucher) {
    return 'The voucher "$voucher" is invalid';
  }

  static const String noInternet =
      "Can't connect to Analog. Are you connected to the internet?";
  static const String retry = 'Retry';
  static const String unknownErrorOccured = 'An unknown error occured';
  static const String loading = 'Loading';
}
