bool emailIsValid(String email) {
  return RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]{2,}').hasMatch(email);
}
