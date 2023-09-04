import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/bloc/app_bloc.dart';
import 'package:swafe/views/home.dart';
import 'package:swafe/views/login_view/login_view.dart';
import 'package:swafe/views/register_view/register.dart';
import 'package:swafe/views/welcome_view/welcome_view.dart';
import 'package:firebase_core/firebase_core.dart'; // Importez Firebase Core

Future<void> main() async {
  // Initialisez Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

    FirebaseAuth _auth = FirebaseAuth.instance;
    Widget initialPage;

    if (_auth.currentUser != null) {
      initialPage =
          HomeView(welcomeMessage: "Bienvenue ${_auth.currentUser!.email} !");
    } else {
      initialPage = WelcomeView();
    }

    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: initialPage,
        routes: {
          '/login': (context) => LoginView(),
          '/register': (context) => RegisterView(),
        },
      ),
    );
  }
}
