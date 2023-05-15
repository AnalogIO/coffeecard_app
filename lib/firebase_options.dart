import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get production {
    if (kIsWeb) throw UnsupportedError('Web is not supported');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyBSOwHLlN9ig7f0fLvQ7nra5OfWgbetT4c',
          appId: '1:897975858437:android:5496e6f1f212adf7e3336c',
          messagingSenderId: '897975858437',
          projectId: 'analogio-47cf0',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyA9AeIYgYXPJKJHw6CgyynPYXvNqvh8R6I',
          appId: '1:897975858437:ios:9b4793f78215e1fa',
          messagingSenderId: '897975858437',
          projectId: 'analogio-47cf0',
          iosClientId:
              '897975858437-5mtqt6dn8qarvrb8ebfujvvkb5nldcoi.apps.googleusercontent.com',
          iosBundleId: 'DK.AnalogIO.DigitalCoffeeCard',
        );
      default:
        throw UnsupportedError(
          'Unsupported platform $defaultTargetPlatform',
        );
    }
  }

  static FirebaseOptions get development {
    if (kIsWeb) throw UnsupportedError('Web is not supported');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyCfpHZomC2_5Dw4xlXyg0U77KZDtPEGZlM',
          appId: '1:707418028743:android:79864852bd8c91f90e1ce2',
          messagingSenderId: '707418028743',
          projectId: 'analogio-development',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyCxfE-Rz0lTiFp7IrGxfph0_-aWHAlmqMY',
          appId: '1:707418028743:ios:4a7aa2156c4e0f150e1ce2',
          messagingSenderId: '707418028743',
          projectId: 'analogio-development',
          iosClientId:
              '707418028743-fnktdlvjrcmu3n8af3v83dhr7v7lfpvh.apps.googleusercontent.com',
          iosBundleId: 'dk.analogio.analog.dev',
        );
      default:
        throw UnsupportedError(
          'Unsupported platform $defaultTargetPlatform',
        );
    }
  }
}
