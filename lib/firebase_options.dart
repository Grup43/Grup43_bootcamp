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
    apiKey: 'AIzaSyDAk7zH77ut-kZSJdzeApAIzIjugHOzmUI',
    appId: '1:786010809670:web:f53dca198aabd650c6f147',
    messagingSenderId: '786010809670',
    projectId: 'bootcampgrup43',
    authDomain: 'bootcampgrup43.firebaseapp.com',
    storageBucket: 'bootcampgrup43.firebasestorage.app',
    measurementId: 'G-CSH3KREQC7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1PGfgFRVR7I8VbQb-ADwDjckfRFtQ8NA',
    appId: '1:786010809670:android:b28c817bf071e6d5c6f147',
    messagingSenderId: '786010809670',
    projectId: 'bootcampgrup43',
    storageBucket: 'bootcampgrup43.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBzLkE3vlCh1DJt7x9MQpb0fp4qJ4TR1U',
    appId: '1:786010809670:ios:5c7c12d832ba8bc2c6f147',
    messagingSenderId: '786010809670',
    projectId: 'bootcampgrup43',
    storageBucket: 'bootcampgrup43.firebasestorage.app',
    iosBundleId: 'com.example.educoachFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCBzLkE3vlCh1DJt7x9MQpb0fp4qJ4TR1U',
    appId: '1:786010809670:ios:5c7c12d832ba8bc2c6f147',
    messagingSenderId: '786010809670',
    projectId: 'bootcampgrup43',
    storageBucket: 'bootcampgrup43.firebasestorage.app',
    iosBundleId: 'com.example.educoachFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDAk7zH77ut-kZSJdzeApAIzIjugHOzmUI',
    appId: '1:786010809670:web:85d585f426e5d5f6c6f147',
    messagingSenderId: '786010809670',
    projectId: 'bootcampgrup43',
    authDomain: 'bootcampgrup43.firebaseapp.com',
    storageBucket: 'bootcampgrup43.firebasestorage.app',
    measurementId: 'G-88EGM112G8',
  );
}
