import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:email_validator/email_validator.dart';
import 'package:swafe/firebase_auth_implementation%20/firebase_auth_services.dart';
import 'package:swafe/views/home.dart';
import 'package:swafe/views/register_view/register.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isKeyboardVisible = false;
  bool isEmailValid = true;
  String email = ''; // Nouvelle variable pour stocker l'adresse e-mail
  String password = ''; // Nouvelle variable pour stocker le mot de passe
  FirebaseAuthService _authService =
      FirebaseAuthService(); // Instance du service d'authentification

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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      email = value; // Mettez à jour l'adresse e-mail
                      isEmailValid = EmailValidator.validate(email);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    password = value; // Mettez à jour le mot de passe
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 10),
            if (!isEmailValid)
              Padding(
                padding:
                    EdgeInsets.only(left: 12), // Adjust the padding as needed
                child: Text(
                  "Veuillez saisir une adresse e-mail valide",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            SizedBox(height: 10),
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
                    color: Color(0xFF714DD8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                            // Connexion réussie, faites ce que vous devez faire après la connexion
                            // Par exemple, naviguez vers une nouvelle page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeView(
                                  welcomeMessage:
                                      "Bienvenue ${user.email} !", // Message de bienvenue
                                ),
                              ),
                            );
                          } else {
                            // La connexion a échoué, vous pouvez afficher un message d'erreur
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    backgroundColor:
                        isEmailValid ? const Color(0xFF714DD8) : Colors.grey,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text('Continuer'),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                    padding: EdgeInsets.symmetric(vertical: 15),
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
                SizedBox(height: 70),
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
