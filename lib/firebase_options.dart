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
    apiKey: 'AIzaSyCOrvClPM0bM5W4Uc0Zmy-h4cDi3qRDg6o',
    appId: '1:966407046437:web:58727d1afe21121574c6cc',
    messagingSenderId: '966407046437',
    projectId: 'clothing-app-1a164',
    authDomain: 'clothing-app-1a164.firebaseapp.com',
    storageBucket: 'clothing-app-1a164.firebasestorage.app',
    measurementId: 'G-L29D5JV58N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDj1zlklLitQN9EL1wEJ8hHlhyYxN8E75M',
    appId: '1:966407046437:android:d7b4e6764d8f579074c6cc',
    messagingSenderId: '966407046437',
    projectId: 'clothing-app-1a164',
    storageBucket: 'clothing-app-1a164.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDz-wwYHa6Y5iewY74S8PZwFBu5YVBIkk',
    appId: '1:966407046437:ios:6fe0b4d0d38eb92f74c6cc',
    messagingSenderId: '966407046437',
    projectId: 'clothing-app-1a164',
    storageBucket: 'clothing-app-1a164.firebasestorage.app',
    iosBundleId: 'com.example.clothingStore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDz-wwYHa6Y5iewY74S8PZwFBu5YVBIkk',
    appId: '1:966407046437:ios:6fe0b4d0d38eb92f74c6cc',
    messagingSenderId: '966407046437',
    projectId: 'clothing-app-1a164',
    storageBucket: 'clothing-app-1a164.firebasestorage.app',
    iosBundleId: 'com.example.clothingStore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCOrvClPM0bM5W4Uc0Zmy-h4cDi3qRDg6o',
    appId: '1:966407046437:web:47037f8521aca31374c6cc',
    messagingSenderId: '966407046437',
    projectId: 'clothing-app-1a164',
    authDomain: 'clothing-app-1a164.firebaseapp.com',
    storageBucket: 'clothing-app-1a164.firebasestorage.app',
    measurementId: 'G-KYC30PR78Y',
  );
}
