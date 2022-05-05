import 'package:chopper/chopper.dart';

abstract class Strings {
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

  // Tickets
  static const ticketsMyTickets = 'My tickets';
  static const shopText = 'Shop';
  static const buyTickets = 'Buy tickets';
  static const buyOneDrink = 'Buy one drink';
  static const buyOther = 'Buy syrup, jugs etc.';
  static const redeemVoucher = 'Redeem voucher';
  static const newLabel = 'NEW';
  static const comingSoonLabel = 'COMING SOON';

  // Opening hours indicator
  static const open = 'open';
  static const closed = 'closed';
  static const openingHoursIndicatorPrefix = "We're";

  // Register
  static const registerAppBarTitle = 'Register';

  static const registerEmailTitle = 'Enter your email';
  static const registerEmailLabel = 'Email';
  static const registerEmailHint =
      'You will need to verify your email address later.';
  static const registerEmailEmpty = 'Enter an email';
  static const registerEmailInvalid = 'Enter a valid email';
  static const registerEmailInUseSuffix = 'is already in use';

  static const registerPasscodeTitle = 'Enter a passcode';
  static const registerPasscodeLabel = 'Passcode';
  static const registerPasscodeRepeatLabel = 'Repeat passcode';
  static const registerPasscodeHint =
      'Enter a four-digit passcode for your account.';
  static const registerPasscodeEmpty = 'Enter a passcode';
  static const registerPasscodeTooShort = 'Enter a four-digit passcode';
  static const registerPasscodeRepeatEmpty = 'Repeat the passcode';
  static const registerPasscodeDoesNotMatch = 'Passcodes do not match';

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

  // Buttons
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
  static const cofeeCardTicketsLeft = 'Tickets left:';
  static const useTicket = 'Use ticket';

  // "Buy ticket" card
  static const paymentOptionMobilePay = 'MobilePay';
  static const paymentOptionOther = 'Other...';
  static const paymentOptionOtherComingSoon = 'This feature is coming soon';

  // Modal explainer
  static const confirmSwipe = 'Confirm use of ticket';
  static const confirmPurchase = 'Confirm purchase';
  static const tapHereToCancel = 'Tap here to cancel';

  static String paymentConfirmationTop(int amount, String title) {
    return "You're buying $amount $title tickets";
  }

  static String paymentConfirmationBottom(int price) {
    return 'Pay $price,- with...';
  }

  static String amountTickets(int amount) {
    return '$amount tickets';
  }

  static String price(int price) {
    return '$price,-';
  }

  // Purchase process
  static const purchaseErrorOk = 'Ok';
  static const purchaseTalking = 'Talking with payment provider';
  static const purchaseCompleting = 'Completing purchase';
  static const purchaseSuccess = 'Success';
  static const purchaseRejectedOrCanceled = 'Payment rejected or canceled';
  static const purchaseRejectedOrCanceledMessage =
      'The payment was rejected or cancelled. No tickets have been added to your account';
  static const purchaseError = "Uh oh, we couldn't complete that purchase";

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
  static const youRedeemed = 'You redeemed';
  static const voucherRedeemed = 'Voucher redeemed 🎉';

  // Settings
  static const settingsPageTitle = 'Settings';
  static const yourProfilePageTitle = 'Your profile';

  static const settingsGroupAccount = 'Account';
  static const settingsGroupFeatures = 'Features';
  static const settingsGroupAbout = 'About Cafe Analog';
  static const settingsGroupProfile = 'Edit profile';

  static const email = 'Email';
  static const passcode = 'Passcode';
  static const change = 'Change';
  static const logOut = 'Log out';
  static const deleteAccount = 'Delete account';

  static const changeEmail = 'Change email';
  static const changeName = 'Change name';
  static const changeOccupation = 'Change occupation';
  static const changePasscode = 'Change passcode';
  static const changeEmailCannotBeSame =
      'New email cannot be the same as the old one';

  static const forgotPasscode = 'Forgot passcode';
  static const forgotPasscodeLinkSent = 'Passcode reset link sent';
  static String forgotPasscodeSentRequestTo(String email) =>
      'We have sent a request to reset your passcode to $email, please check your email';
  static const forgotPasscodeTitleError = 'Looks like an error occoured';
  static const forgotPasscodeBodyError =
      'We were unable to complete your request, please try again later';
  static const forgotPasscodeHint =
      "We'll send you a link to reset your passcode";

  static const deleteAccountText =
      'Performing this action will delete your account and any tickets you own.\n\nThis cannot be undone.\n\nAre you sure you want to proceed?';
  static String deleteAccountEmailConfirmation(String email) =>
      'We have sent a verification link to $email.\n\nPlease confirm your request to delete your account using the provided link.';

  static const signInWithFingerprint = 'Sign in with fingerprint';

  static const faq = 'Frequently Asked Questions';
  static const openingHours = 'Opening hours';
  static const today = 'Today';

  static const name = 'Name';
  static const occupation = 'Occupation';
  static const appearAnonymous = 'Appear anonymous on leaderboard';
  static const appearAnonymousSmall = 'Appear anonymous';
  static const yourProfileDescription =
      'These settings affect your appearance on the leaderboards.';

  static const madeBy = 'Made with ❤ by AnalogIO\nIT University of Copenhagen';
  static const userID = 'User ID';

  // Time since utility
  static const justNow = 'Just now';
  static const minutesAgo = 'minutes $ago';
  static const anHourAgo = 'An hour $ago';
  static const hoursAgo = 'hours $ago';
  static const earlierToday = 'Earlier today';
  static const yesterday = 'Yesterday';
  static const daysAgo = 'days $ago';
  static const aMonth = 'a month';
  static const months = 'months';
  static const yearsAgo = 'years $ago';
  static const ago = 'ago';
  static const around = 'Around';
  static const almost = 'Almost';
  static const moreThan = 'More than';

  // Errors
  static const error = 'Error';

  static String unknownFilterCategory(Object category) {
    return 'Unknown filter category: $category';
  }

  static String formatApiError(Response response) {
    return 'API Error ${response.statusCode} ${response.error}';
  }

  static String invalidRoute(String c, String? route) {
    return '($c) Unknown route: $route';
  }

  static String invalidVoucher(String voucher) {
    return 'The voucher "$voucher" is invalid';
  }

  static String noInternet =
      "Oops, we couldn't connect to the server\n Are you connected to the internet?";
  static String retry = 'Retry';
}
