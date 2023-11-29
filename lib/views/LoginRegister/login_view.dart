import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/helper/getFirebaseErrorMessage.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  LoginBottomSheetState createState() => LoginBottomSheetState();
}

class LoginBottomSheetState extends State<LoginBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visiblePassword = false;
  String errorMessage = '';
  final _authInstance = FirebaseAuth.instance;

  Future<void> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user?.emailVerified ?? false) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      user?.sendEmailVerification();
      setState(() {
        errorMessage = "Veuillez vérifier votre email pour continuer.";
      });
    }
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Reset errorMessage
        setState(() {
          errorMessage = '';
        });

        await _authInstance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        checkEmailVerified();
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
          errorMessage = getFirebaseErrorMessage('');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
      child: Form(
        key: _formKey,
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
                  style: BodyLargeMedium.copyWith(color: MyColors.error40),
                ),
              ),
            CustomTextField(
              placeholder: 'E-mail',
              controller: _emailController,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                        .hasMatch(value)) {
                  return "L'adresse e-mail n'est pas valide.";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              placeholder: 'Mot de passe',
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le mot de passe ne peut pas être vide.';
                }
                return null;
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
                  style: BodyLargeMedium.copyWith(color: MyColors.secondary40),
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
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Pas encore membre ? ', style: BodyLargeMedium),
                    TextSpan(
                      text: 'Rejoignez-nous !',
                      style:
                          BodyLargeMedium.copyWith(color: MyColors.secondary40),
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
