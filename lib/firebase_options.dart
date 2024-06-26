// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5FF-QZt9-B56UD8y3EKla7984IkoocPo',
    appId: '1:515106728954:web:73433b0d58de842d445243',
    messagingSenderId: '515106728954',
    projectId: 'kjhacks-b1a39',
    authDomain: 'kjhacks-b1a39.firebaseapp.com',
    storageBucket: 'kjhacks-b1a39.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDya_RwZ7zk_kiydwqT3Wm4XAT9ZkMZURo',
    appId: '1:515106728954:android:7a7fcce3d7f01445445243',
    messagingSenderId: '515106728954',
    projectId: 'kjhacks-b1a39',
    storageBucket: 'kjhacks-b1a39.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByBuHdF6NjbSlLzdWK5Juqxa5i_IWnzHY',
    appId: '1:515106728954:ios:4dd187671b028071445243',
    messagingSenderId: '515106728954',
    projectId: 'kjhacks-b1a39',
    storageBucket: 'kjhacks-b1a39.appspot.com',
    iosBundleId: 'com.example.kj',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByBuHdF6NjbSlLzdWK5Juqxa5i_IWnzHY',
    appId: '1:515106728954:ios:80de91d946df6014445243',
    messagingSenderId: '515106728954',
    projectId: 'kjhacks-b1a39',
    storageBucket: 'kjhacks-b1a39.appspot.com',
    iosBundleId: 'com.example.kj.RunnerTests',
  );
}
