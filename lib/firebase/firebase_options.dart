import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.'
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
          'you can reconfigure this by running the FlutterFire CLI again.'
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.'
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.'
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.'
        );
    }
  }

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: '1:32610493328:android:a9bf042df5763d9e7b8915',
    messagingSenderId: '32610493328',
    projectId: 'swafe-app',
    databaseURL:
        dotenv.env['FIREBASE_DB_URL']!,
    storageBucket: 'swafe-app.appspot.com',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: '1:32610493328:ios:31042fc4d18b28827b8915',
    messagingSenderId: '32610493328',
    projectId: 'swafe-app',
    databaseURL:
        dotenv.env['FIREBASE_DB_URL']!,
    storageBucket: 'swafe-app.appspot.com',
    iosClientId:
        dotenv.env['FIREBASE_IOS_ID']!,
    iosBundleId: 'com.example.swafe',
  );
}
