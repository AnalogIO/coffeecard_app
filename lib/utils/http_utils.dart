import 'dart:convert';

//TODO: maybe not the best solution?
String formatErrorMessage(Object error) {
  //assumes http response in string format {'message' : 'some error'}
  final m = json.decode(
        error as String,) as Map<String, dynamic>;

  return m['message']! as String;
}
