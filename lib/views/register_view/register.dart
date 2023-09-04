import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:swafe/firebase_auth_implementation%20/firebase_auth_services.dart';
import 'package:swafe/views/home.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterView(),
  ));
}

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  FirebaseAuthService _authService =
      FirebaseAuthService(); // Instance du service d'authentification

  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecialCharacter = false;
  bool hasMinLength = false;

  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String confirmPasswordErrorMessage = '';

  bool arePasswordsMatching() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  bool isButtonEnabled() {
    return _emailController.text.isNotEmpty &&
        EmailValidator.validate(_emailController.text) &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        hasUppercase &&
        hasNumber &&
        hasSpecialCharacter &&
        hasMinLength &&
        arePasswordsMatching();
  }

  void updateErrorMessages() {
    setState(() {
      if (_emailController.text.isEmpty) {
        emailErrorMessage = '';
      } else if (!EmailValidator.validate(_emailController.text)) {
        emailErrorMessage = 'Veuillez saisir une adresse e-mail valide';
      } else {
        emailErrorMessage = '';
      }

      if (_passwordController.text.isEmpty) {
        passwordErrorMessage = '';
      } else if (!hasUppercase ||
          !hasNumber ||
          !hasSpecialCharacter ||
          !hasMinLength) {
        passwordErrorMessage = 'Le mot de passe ne respecte pas les critères';
      } else {
        passwordErrorMessage = '';
      }

      if (_confirmPasswordController.text.isEmpty) {
        confirmPasswordErrorMessage = '';
      } else if (!arePasswordsMatching()) {
        confirmPasswordErrorMessage = 'Les mots de passe ne correspondent pas';
      } else {
        confirmPasswordErrorMessage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    updateErrorMessages();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Row(
          children: [
            SizedBox(width: 5),
            IconButton(
              icon: Icon(Icons.arrow_back,
                  color: const Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  onChanged: (value) {
                    setState(() {
                      hasUppercase = value.contains(RegExp(r'[A-Z]'));
                      hasNumber = value.contains(RegExp(r'[0-9]'));
                      hasSpecialCharacter =
                          value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                      hasMinLength = value.length >= 8;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 8),
                Text(
                  "Doit contenir au moins :",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                ValidationText(hasUppercase, "1 majuscule"),
                ValidationText(hasNumber, "1 chiffre"),
                ValidationText(hasSpecialCharacter, "1 caractère spécial"),
                ValidationText(hasMinLength, "8 caractères"),
                SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirmation du mot de passe',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                if (emailErrorMessage.isNotEmpty)
                  Text(emailErrorMessage, style: TextStyle(color: Colors.red)),
                if (passwordErrorMessage.isNotEmpty)
                  Text(passwordErrorMessage,
                      style: TextStyle(color: Colors.red)),
                if (confirmPasswordErrorMessage.isNotEmpty)
                  Text(
                    confirmPasswordErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Text(
                    "En cliquant sur “continuer”, vous acceptez les conditions générales d’utilisation",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled()
                          ? () async {
                              User? user =
                                  await _authService.signUpWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                              );

                              if (user != null) {
                                // Inscription réussie, faites ce que vous devez faire après l'inscription
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
                                // L'inscription a échoué, vous pouvez afficher un message d'erreur
                              }
                            }
                          : null,
                      child: Text('Continuer'),
                      style: ElevatedButton.styleFrom(
                        primary: isButtonEnabled()
                            ? const Color(0xFF714DD8)
                            : Colors.grey,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class ValidationText extends StatelessWidget {
  final bool isValid;
  final String label;

  ValidationText(this.isValid, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        children: [
          isValid
              ? Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                )
              : Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 16,
                ),
          SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}
