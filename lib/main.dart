import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;

  String getInitialRoute() {
    User? user = _firebaseInstance.currentUser;
    if (user != null) {
      return user.emailVerified ? '/home' : '/welcome';
    }
    return '/welcome';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));

    String initialRoute = getInitialRoute();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swafe',
      theme: ThemeData.light(),
      initialRoute: initialRoute,
      routes: {
        '/register': (context) => const RegisterView(),
        '/welcome': (context) => const WelcomeView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
