import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:email_validator/email_validator.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:swafe/views/MainView/home.dart';
import 'package:swafe/views/LoginRegister/register.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginView(),
  ));
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  bool isKeyboardVisible = false;
  bool isEmailValid = true;
  bool visiblePassword = false;
  String email = '';
  String password = '';
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isKeyboardVisible) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(Spacing
            .standard), // Utilisation de Spacing.standard pour la marge globale
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: Spacing.standard),
              // Utilisation de Spacing.tripleExtraLarge pour la marge supérieure
              child: Container(
                decoration: const BoxDecoration(),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.all(Spacing
                        .medium), // Utilisation de Spacing.medium pour le rembourrage
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      isEmailValid = EmailValidator.validate(email);
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),
            const SizedBox(height: Spacing.extraLarge),
            // Utilisation de Spacing.small pour l'espacement vertical
            TextField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.all(Spacing.medium),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => visiblePassword = !visiblePassword),
                  icon: Icon(!visiblePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  color: Colors.black,
                ),
              ),
              obscureText: !visiblePassword,
            ),
            const SizedBox(height: Spacing.small),
            if (!isEmailValid)
              const Padding(
                padding: EdgeInsets.only(left: Spacing.small),
                // Utilisation de Spacing.medium pour le padding
                child: Text(
                  "Veuillez saisir une adresse e-mail valide",
                  style: TextStyle(
                    color: MyColors.error40,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: Spacing.none),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mot de passe oublié ?",
                  style: TextStyle(
                    color: MyColors.secondary40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.standard),
            // Utilisation de Spacing.standard pour l'espacement vertical
            Column(
              children: [
                ElevatedButton(
                  onPressed: isEmailValid
                      ? () async {
                          User? user =
                              await _authService.signInWithEmailAndPassword(
                            email,
                            password,
                          );

                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeView(
                                  welcomeMessage: "Bienvenue ${user.email} !",
                                ),
                              ),
                            );
                          } else {
                            // Gérer la connexion échouée
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    backgroundColor: isEmailValid
                        ? MyColors.secondary40
                        : MyColors.neutral70,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing
                          .medium, // Utilisation de Spacing.medium pour le rembourrage vertical
                    ),
                    child: const Center(
                      child: Text('Continuer'),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.small),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterView(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing.medium,
                    ),
                    child: Center(
                      child: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text: "Pas encore membre ? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            text: "Rejoignez-nous !",
                            style: TextStyle(
                              color: MyColors.secondary40,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.huge),
                // Utilisation de Spacing.huge pour l'espacement vertical
              ],
            ),
          ],
        ),
      ),
    );
  }
}

