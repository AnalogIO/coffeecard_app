abstract class Strings {
  static const appTitle = 'Cafe Analog';

  // Titles for the app bar.
  static const ticketsPageTitle = 'Tickets';
  static const receiptsPageTitle = 'Receipts';
  static const statsPageTitle = 'Statistics';
  static const settingsPageTitle = 'Settings';
  static const buyOneDrinkPageTitle = 'Buy one drink';
  static const buyOtherPageTitle = 'Buy other';
  static const redeemVoucherPageTitle = 'Redeem voucher';

  // Titles for the navigation bar.
  static const ticketsNavTitle = ticketsPageTitle;
  static const receiptsNavTitle = receiptsPageTitle;
  static const statsNavTitle = 'Stats';
  static const settingsNavTitle = settingsPageTitle;

  // Test strings.
  static const ticketsPageTestString = 'Test string for Tickets page ☕';
  static const testDBString = 'Connected to test database';

  // Login email hint and errors
  static const loginPasscodeHint = 'Enter passcode';
  static const loginPasscodeEmpty = 'Enter a passcode';

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

  // App text
  static const analogClosedText = 'Cafe Analog is closed';
  static const shopText = 'Shop';
  static const buyTickets = 'Buy tickets';
  static const buyOneDrink = 'Buy one drink';
  static const buyOther = 'Buy syrup, jugs etc.';
  static const redeemVoucher = 'Redeem voucher';

  // Receipts page
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

  // Time since utility
  static const justNow = 'Just now';
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
}
