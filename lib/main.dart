import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swafe/firebase/firebase_options.dart';
import 'package:swafe/views/LoginRegister/login_view.dart';
import 'package:swafe/views/LoginRegister/register.dart';
import 'package:swafe/views/LoginRegister/welcome_view.dart';
import 'package:swafe/views/MainView/home.dart';

// CORRECTION/COMMENTAIRE : suivre, pour le nommage des fichiers le style de dart (chercher dart_effective_style).

// CORRECTION/COMMENTAIRE : KEY_1 : D'une manière générale, il faut faire en sorte de ne pas avoir d'appels réseaux directement dans les widgets, 
// mais au moins de mettre au meme endroit, pour une feature donnée, les appels réseau correspondants.

// CORRECTION/COMMENTAIRE : Ceci est la SEULE fonction main qui doit être présente dans le dossier lib ! 
// Il y en a une dans le dossier test (que j'ai supprimé car il ne comprenait pas de test) 
Future<void> main() async {
  // Initialisez Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
    Widget initialPage;

    final currentUser = auth.currentUser;
    if (currentUser != null) {
      initialPage =
          HomeView(welcomeMessage: "Bienvenue ${currentUser.email} !");
    } else {
      initialPage = const WelcomeView();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: initialPage,
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
      },
    );
  }
}
