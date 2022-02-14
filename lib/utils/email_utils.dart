// TODO Belongs somewhere else (new EmailInputBloc?)
bool emailIsValid(String email) {
  return RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]{2,}')
      .hasMatch(email.trim());
}

// TODO Belongs somewhere else (new EmailInputBloc?)
Future<bool> emailIsDuplicate(String email) async {
  return Future.delayed(const Duration(milliseconds: 250), () => false);
}
