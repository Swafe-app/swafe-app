import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/firebase/firebase_options.dart';
import 'package:swafe/services/user_service.dart';
import 'package:swafe/views/auth/register_view.dart';
import 'package:swafe/views/home_view.dart';
import 'package:swafe/views/main/main_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: dotenv.env['ENVIRONMENT'] == 'dev' ? 'swafe_dev' : 'swafe_prod',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final storage = const FlutterSecureStorage();

  Future<String> getInitialRoute() async {
    String? token = await storage.read(key: 'token');
    if (token != '') {
      return '/main';
    } else {
      return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FutureBuilder<String>(
        future: getInitialRoute(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            return BlocProvider(
              create: (context) => AuthBloc(),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Swafe',
                theme: ThemeData.light(),
                initialRoute: snapshot.data,
                routes: {
                  '/register': (context) => const RegisterView(),
                  '/home': (context) => const HomeView(),
                  '/main': (context) => const MainView(),
                },
              ),
            );
          }
        },
      ),
    );
  }
}
