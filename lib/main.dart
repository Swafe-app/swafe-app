import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/firebase/firebase_options.dart';
import 'package:swafe/views/LoginRegister/register_view.dart';
import 'package:swafe/views/LoginRegister/welcome_view.dart';
import 'package:swafe/views/MainView/home.dart';

Future<void> main() async {
  // Initialisez Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  /*final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;

  String getInitialRoute() {
    User? user = _firebaseInstance.currentUser;
    if (user != null) {
      return user.emailVerified ? '/home' : '/welcome';
    }
    return '/welcome';
  }*/

  final storage = const FlutterSecureStorage();

  Future<String> getInitialRoute() async {
    String? emailVerified = await storage.read(key: 'emailVerified');
    String? token = await storage.read(key: 'token');
    String? selfieStatus = await storage.read(key: 'selfieStatus');
    if (emailVerified == 'true' && token != '' && selfieStatus == 'accepted')
      return '/home';
    else
      return '/welcome';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));


    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FutureBuilder<String>(
            future: getInitialRoute(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // or some other widget while waiting
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Swafe',
                  theme: ThemeData.light(),
                  initialRoute: snapshot.data,
                  routes: {
                    '/register': (context) => const RegisterView(),
                    '/welcome': (context) => const WelcomeView(),
                    '/home': (context) => const HomeView(),
                  },
                );
              }
            }
        )
    );
  }
}
