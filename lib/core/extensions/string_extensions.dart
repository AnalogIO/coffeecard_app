extension StringExtensions on String {
  String capitalize() {
    // Closed string is const, and does not contain an emoji
    // ignore: avoid-substring
    return this[0].toUpperCase() + substring(1);
  }
}
