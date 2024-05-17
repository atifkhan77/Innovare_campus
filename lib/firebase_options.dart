// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyA_6TcLmrmadcB1Fkkll33jLvPw7D2TRC4',
    appId: '1:497450333684:web:0b5f3ed584022d0c7bb5a1',
    messagingSenderId: '497450333684',
    projectId: 'innovarecamp',
    authDomain: 'innovarecamp.firebaseapp.com',
    storageBucket: 'innovarecamp.appspot.com',
    measurementId: 'G-L1QRM89T6K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA07AABQxgWIi-NTgxqfe3K4kGqaiPwoio',
    appId: '1:497450333684:android:b731046bb78effbb7bb5a1',
    messagingSenderId: '497450333684',
    projectId: 'innovarecamp',
    storageBucket: 'innovarecamp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXFgpQQ1MTqH9iKAc1FUswjmA8mmUJbQE',
    appId: '1:497450333684:ios:d9092624818f8d137bb5a1',
    messagingSenderId: '497450333684',
    projectId: 'innovarecamp',
    storageBucket: 'innovarecamp.appspot.com',
    iosBundleId: 'com.example.innovareCampus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXFgpQQ1MTqH9iKAc1FUswjmA8mmUJbQE',
    appId: '1:497450333684:ios:d9092624818f8d137bb5a1',
    messagingSenderId: '497450333684',
    projectId: 'innovarecamp',
    storageBucket: 'innovarecamp.appspot.com',
    iosBundleId: 'com.example.innovareCampus',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA_6TcLmrmadcB1Fkkll33jLvPw7D2TRC4',
    appId: '1:497450333684:web:54665ad0644292117bb5a1',
    messagingSenderId: '497450333684',
    projectId: 'innovarecamp',
    authDomain: 'innovarecamp.firebaseapp.com',
    storageBucket: 'innovarecamp.appspot.com',
    measurementId: 'G-ZHBMQF19EF',
  );

}