import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/firebase/firebase_options.dart';
import 'package:swafe/views/auth/identity/checking_identity.dart';
import 'package:swafe/views/auth/identity/identity_form_view.dart';
import 'package:swafe/views/auth/register/register_view.dart';
import 'package:swafe/views/auth/valide_email_code_view.dart';
import 'package:swafe/views/auth/home_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(VerifyTokenEvent()),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Swafe',
          theme: ThemeData.light(),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is VerifyTokenSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/main');
                });
                return Container();
              }
              if (state is VerifyTokenError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/home');
                });
                return Container();
              }
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            },
          ),
          routes: {
            '/register': (context) => const RegisterView(),
            '/validate-email': (context) => const CodeValidationView(),
            '/upload-selfie': (context) => const IdentityForm(),
            '/checking-identity': (context) => const CheckingIdentity(),
            '/home': (context) => const HomeView(),
            '/main': (context) => const MainView(),
          },
        ),
      ),
    );
  }
}
