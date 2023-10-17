import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:email_validator/email_validator.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:swafe/views/MainView/home.dart';
import 'package:swafe/views/LoginRegister/register.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isKeyboardVisible = false;
  bool isEmailValid = true;
  String email = '';
  String password = '';
  FirebaseAuthService _authService = FirebaseAuthService();

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
        padding: EdgeInsets.all(Spacing
            .standard), // Utilisation de Spacing.standard pour la marge globale
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Spacing
                      .standard), // Utilisation de Spacing.tripleExtraLarge pour la marge supérieure
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColors.neutral40,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      isEmailValid = EmailValidator.validate(email);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(Spacing
                        .medium), // Utilisation de Spacing.medium pour le rembourrage
                  ),
                ),
              ),
            ),
            SizedBox(
                height: Spacing
                    .extraLarge), // Utilisation de Spacing.small pour l'espacement vertical
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: MyColors.neutral40,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(Spacing.medium),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: Spacing.small),
            if (!isEmailValid)
              Padding(
                padding: EdgeInsets.only(
                    left: Spacing
                        .small), // Utilisation de Spacing.medium pour le padding
                child: Text(
                  "Veuillez saisir une adresse e-mail valide",
                  style: TextStyle(
                    color: MyColors.error40,
                    fontSize: 12,
                  ),
                ),
              ),
            SizedBox(height: Spacing.none),

            CustomButton(
              label: "Mot de passe oublié ?",
              type: ButtonType.text,
              fillColor: null, // Set to the desired fill color
              strokeColor: null, // Set to the desired stroke color
              textColor: MyColors.secondary40, // Set to the desired text color
              onPressed: () {},
              isLoading: false,
              isDisabled: false,
              icon: null,
            ),
            SizedBox(
                height: Spacing
                    .standard), // Utilisation de Spacing.standard pour l'espacement vertical
            Column(
              children: [
                CustomButton(
                  label: "Continuer",
                  type: ButtonType.filled,
                  fillColor:
                      MyColors.secondary40, // Set to the desired fill color
                  strokeColor: null, // Set to the desired stroke color
                  textColor:
                      MyColors.defaultWhite, // Set to the desired text color
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
                  isLoading: false,
                  isDisabled: false,
                  icon: null,
                ),
                SizedBox(height: Spacing.small),

                CustomButton(
                  label: "Pas encore membre ? Rejoignez-nous !",
                  type: ButtonType.text,
                  fillColor: null, // Set to the desired fill color
                  strokeColor: null, // Set to the desired stroke color
                  textColor:
                      MyColors.primary10, // Set to the desired text color
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterView(),
                      ),
                    );
                  },
                  isLoading: false,
                  isDisabled: false,
                  icon: null,
                ),

                SizedBox(
                    height: Spacing
                        .huge), // Utilisation de Spacing.huge pour l'espacement vertical
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginView(),
  ));
}
