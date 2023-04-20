class MatchCaseIncompleteException implements Exception {
  // Needs to be able to receive all types of objects
  //ignore: no-object-declaration
  Object object;

  MatchCaseIncompleteException(this.object);
}
