/// Ignore the return value of a function.
///
/// This function is only needed if you need to ignore multiple values in the
/// same scope. Assigning to the underscore (`_`) variable is a better solution
/// in other cases.
void ignoreValue<T>(T _) {
  return;
}
