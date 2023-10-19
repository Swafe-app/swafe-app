import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/firebase/firebase_auth_services.dart';
import 'package:swafe/views/LoginRegister/register.dart';
import 'package:swafe/views/MainView/home.dart';

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
            const CustomButton(
              label: "Mot de passe oublié ?",
              type: ButtonType.text,
              textColor: MyColors.secondary40,
            ),
            const SizedBox(height: Spacing.standard),
            // Utilisation de Spacing.standard pour l'espacement vertical
            Column(
              children: [
                CustomButton(
                  label: "Continuer",
                  fillColor: MyColors.secondary40,
                  textColor: MyColors.defaultWhite,
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
                ),
                const SizedBox(height: Spacing.small),
                CustomButton(
                  label: "Pas encore membre ? Rejoignez-nous !",
                  type: ButtonType.text,
                  fillColor: null,
                  // Set to the desired fill color
                  strokeColor: null,
                  // Set to the desired stroke color
                  textColor: MyColors.primary10,
                  // Set to the desired text color
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterView(),
                      ),
                    );
                  },
                  isLoading: false,
                  isDisabled: false,
                  icon: null,
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
