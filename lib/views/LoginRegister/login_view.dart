import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  LoginBottomSheetState createState() => LoginBottomSheetState();
}

class LoginBottomSheetState extends State<LoginBottomSheet> {
  String email = '';
  String password = '';
  bool visiblePassword = false;
  String errorMessage = '';
  final _authInstance = FirebaseAuth.instance;

  String getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé pour cet e-mail.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'L\'adresse e-mail n\'est pas valide.';
      case 'user-disabled':
        return 'Le compte utilisateur a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives de connexion échouées. Veuillez réessayer plus tard.';
      default:
        return 'Une erreur est survenue lors de la connexion. Veuillez réessayer plus tard.';
    }
  }

  Future<void> signIn() async {
    try {
      // Reset errorMessage
      setState(() {
        errorMessage = '';
      });

      final user = await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Firebase Error: $e");
      }
      setState(() {
        errorMessage = getFirebaseErrorMessage(e.code);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      setState(() {
        errorMessage = "Une erreur est survenue lors de la connexion.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barre visuel pour le BottomSheet
            Container(
              width: 160,
              height: 8,
              decoration: BoxDecoration(
                color: MyColors.neutral70,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  errorMessage,
                  style: typographyList
                      .firstWhere((info) => info.name == 'Body Large Medium')
                      .style
                      .copyWith(color: MyColors.error40),
                ),
              ),
            CustomTextField(
              placeholder: 'E-mail',
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              placeholder: 'Mot de passe',
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: !visiblePassword,
              rightIcon: visiblePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onRightIconPressed: () =>
                  setState(() => visiblePassword = !visiblePassword),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {},
                child: Text(
                  'Mot de passe oublié ?',
                  style: typographyList
                      .firstWhere((info) => info.name == 'Body Large Medium')
                      .style
                      .copyWith(color: MyColors.secondary40),
                ),
              ),
            ),
            const SizedBox(height: 60),
            CustomButton(
              label: 'Continuer',
              onPressed: () => signIn(),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/register'),
              child: RichText(
                text: TextSpan(
                  style: typographyList
                      .firstWhere((info) => info.name == 'Body Large Medium')
                      .style
                      .copyWith(color: MyColors.primary10),
                  children: const <TextSpan>[
                    TextSpan(text: 'Pas encore membre ? '),
                    TextSpan(
                      text: 'Rejoignez-nous !',
                      style: TextStyle(color: MyColors.secondary40),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
