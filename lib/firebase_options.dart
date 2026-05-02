import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyASlxlXnzi3on2eZYmBelo4H3q8f2wb5LE',
    appId: '1:420023069793:web:6eb910dde0611311ff0e20',
    messagingSenderId: '420023069793',
    projectId: 'moneytip--tip-tracker',
    authDomain: 'moneytip--tip-tracker.firebaseapp.com',
    storageBucket: 'moneytip--tip-tracker.firebasestorage.app',
    measurementId: 'G-0THX0QMB53',
  );
}
