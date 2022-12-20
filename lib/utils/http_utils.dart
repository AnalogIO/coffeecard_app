import 'dart:convert';

// TODO(fremartini): remove once backend maps errors, https://github.com/AnalogIO/coffeecard_app/issues/387
String formatErrorMessage(Object error) {
  // assumes http response in string format {'message' : 'some error'}
  final m = json.decode(
    error as String,
  ) as Map<String, dynamic>;

  return m['message']! as String;
}
