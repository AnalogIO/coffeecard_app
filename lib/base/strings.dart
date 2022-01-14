abstract class Strings {
  static const appTitle = 'Cafe Analog';

  // Titles for the app bar.
  static const ticketsPageTitle = 'Tickets';
  static const receiptsPageTitle = 'Receipts';
  static const statsPageTitle = 'Statistics';
  static const settingsPageTitle = 'Settings';

  // Titles for the navigation bar.
  static const ticketsNavTitle = ticketsPageTitle;
  static const receiptsNavTitle = receiptsPageTitle;
  static const statsNavTitle = 'Stats';
  static const settingsNavTitle = settingsPageTitle;

  // Test strings.
  static const ticketsPageTestString = 'Test string for Tickets page ☕';

  // // Login email hint and errors
  // static const loginPasscodeHint = 'Enter passcode';
  // static const loginPasscodeEmpty = 'Enter a passcode';

  // Receipts page
  static const receiptFilterAll = 'Swipes & purchases';
  static const receiptFilterSwipes = 'Swipes';
  static const receiptFilterPurchases = 'Purchases';

  // Time since utility
  static const justNow = 'Just now';
  static String hoursAgo(int hours) => '$hours hours ago';
  static const earlierToday = 'Earlier today';
  static const yesterday = 'Yesterday';
  static String daysAgo(int days) => '$days days ago';
}
