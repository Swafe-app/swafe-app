import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:email_validator/email_validator.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
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
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mot de passe oublié ?",
                  style: TextStyle(
                    color: MyColors.secondary40,
                  ),
                ),
              ),
            ),
            SizedBox(
                height: Spacing
                    .standard), // Utilisation de Spacing.standard pour l'espacement vertical
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
                    padding: EdgeInsets.symmetric(
                      vertical: Spacing
                          .medium, // Utilisation de Spacing.medium pour le rembourrage vertical
                    ),
                    child: Center(
                      child: Text('Continuer'),
                    ),
                  ),
                ),
                SizedBox(height: Spacing.small),
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
                    padding: EdgeInsets.symmetric(
                      vertical: Spacing.medium,
                    ),
                    child: Center(
                      child: Text(
                        "Pas encore membre ? Rejoignez-nous !",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
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
