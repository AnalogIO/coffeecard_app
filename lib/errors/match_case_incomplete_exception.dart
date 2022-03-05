class MatchCaseIncompleteException implements Exception {
  //FIXME: object that caused the problem, how to handle?
  Object object;

  MatchCaseIncompleteException(this.object);
}
