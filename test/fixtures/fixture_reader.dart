import 'dart:io';

// ignore
// ignore: avoid-top-level-members-in-tests
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
