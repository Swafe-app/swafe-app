import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swafe/firebase/firebase_options.dart';
import 'package:swafe/views/LoginRegister/login_view.dart';
import 'package:swafe/views/LoginRegister/register.dart';
import 'package:swafe/views/LoginRegister/welcome_view.dart';
import 'package:swafe/views/MainView/home.dart';

Future<void> main() async {
  // Initialisez Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));

    FirebaseAuth auth = FirebaseAuth.instance;
    String initialRoute;

    final currentUser = auth.currentUser;
    if (currentUser != null) {
      initialRoute = '/home';
    } else {
      initialRoute = '/welcome';
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
