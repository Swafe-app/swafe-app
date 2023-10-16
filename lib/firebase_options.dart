import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5F_t4QTKoz7VM953_aw1Qf9MI2ObKzqM',
    appId: '1:32610493328:android:a9bf042df5763d9e7b8915',
    messagingSenderId: '32610493328',
    projectId: 'swafe-app',
    databaseURL:
        'https://swafe-app-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'swafe-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeHjmsR2CYhkGsOer5NO2_eU1S_FoMbGo',
    appId: '1:32610493328:ios:31042fc4d18b28827b8915',
    messagingSenderId: '32610493328',
    projectId: 'swafe-app',
    databaseURL:
        'https://swafe-app-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'swafe-app.appspot.com',
    iosClientId:
        '32610493328-pipqs3e783dbfpkjgf8sr7c146mh55mq.apps.googleusercontent.com',
    iosBundleId: 'com.example.swafe',
  );
}
