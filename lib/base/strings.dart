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

  // Tickets
  static const ticketsMyTickets = 'My tickets';
  static const analogClosedTitle = 'Cafe Analog is closed';
  static const analogClosedText =
      'Analog is currently closed, come back later!';
  static const shopText = 'Shop';
  static const buyTickets = 'Buy tickets';
  static const buyOneDrink = 'Buy one drink';
  static const buyOther = 'Buy syrup, jugs etc.';
  static const redeemVoucher = 'Redeem voucher';

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

  // Coffee card
  static const emptyCoffeeCardTextTop =
      'Tickets that you buy will show up here';
  static const emptyCoffeeCardTextBottom =
      'Use the section below to shop tickets.';
  static const cofeeCardTicketsLeft = 'Tickets left:';
  static const useTicket = 'Use ticket';

  // Ticket card
  static const paymentOptionApplePay = 'Apple Pay';
  static const paymentOptionMobilePay = 'MobilePay';
  static String paymentConfirmationTop(int amount, String title) {
    return "You're buying $amount tickets of $title";
  }

  static String paymentConfirmationBottom(int price) {
    return 'Pay $price,- with ...';
  }

  static String amountTickets(int amount) {
    return '$amount tickets';
  }

  static String price(int price) {
    return '$price,-';
  }

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
  static const receiptCardNote = 'This can be found again under Reciepts.';
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

  // FIXME: no logic in this file
  static String formatLeaderboardPostfix(int rank) {
    final rankStr = rank.toString();
    final lastDigit = rankStr[rankStr.length - 1];

    switch (lastDigit) {
      case '1':
        return 'st';
      case '2':
        return 'nd';
      case '3':
        return 'rd';
      default:
        return 'th';
    }
  }

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
  static const appearAnonymous = 'Appear anonymous in leaderboard';
  static const appearAnonymousSmall = 'Appear anonymous';
  // FIXME decide between these or:
  // static const appearAnonymous = 'Hide my info in leaderboard';

  static const signInWithFingerprint = 'Sign in with fingerprint';

  static const faq = 'Frequently Asked Questions';
  static const openingHours = 'Opening hours';
  static const today = 'Today';

  static const name = 'Name';
  static const occupation = 'Occupation';
  static const changeProfilePicture = 'Change profile picture';

  static const madeBy = 'Made with ❤ by Analog IO\nIT University of Copenhagen';
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
}
