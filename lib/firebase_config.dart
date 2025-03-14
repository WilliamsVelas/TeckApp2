import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWHFHWphksskKoIi7YxWhDMypwaV6jj98',
    appId: '1:407301559175:android:25e12a54b44accc223f922',
    messagingSenderId: '407301559175',
    projectId: 'teckapp',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlQUwSTdCh9mxNJzuLGSE2o6Z5qjDV598',
    appId: '1:652611990027:android:ae939e224bceb41e4b4d0e',
    messagingSenderId: '652611990027',
    projectId: 'kambia-wallet-flutter',
    databaseURL: 'https://kambia-wallet-flutter-default-rtdb.firebaseio.com',
    storageBucket: 'kambia-wallet-flutter.firebasestorage.app',
    iosBundleId: '',
  );
}
