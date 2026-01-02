// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web not configured');
    }
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-kb-BSWPkWYO2lxQP9d0j4v8-U19kAWg',
    appId: '1:321569287178:android:53832240f0ba49ffd5c3f3',
    messagingSenderId: '321569287178',
    projectId: 'meeragold',
    storageBucket: 'meeragold.firebasestorage.app',
  );
}
