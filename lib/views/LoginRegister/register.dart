import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:swafe/views/MainView/home.dart';
import 'package:swafe/components/appbar/custom_appbar_page.dart';

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

  FirebaseAuthService _authService = FirebaseAuthService();

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

  Future<void> signUp() async {
    if (isButtonEnabled()) {
      User? user = await _authService.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              welcomeMessage: "Bienvenue ${user.email} !",
            ),
          ),
        );
      } else {
        // L'inscription a échoué
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    updateErrorMessages();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Inscription',
      ),
      body: MyContainer(
        child: Container(
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
                        borderRadius: BorderRadius.circular(Spacing.small),
                      ),
                    ),
                  ),
                  SizedBox(height: Spacing.standard),
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
                        borderRadius: BorderRadius.circular(Spacing.small),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: Spacing.standard),
                  Text(
                    "Doit contenir au moins :",
                    style: typographyList
                        .firstWhere(
                            (element) => element.name == 'Body Large Regular')
                        .style, // Utilisation du style typographique
                  ),
                  SizedBox(height: Spacing.extraSmall),
                  ValidationText(hasUppercase, "1 majuscule"),
                  ValidationText(hasNumber, "1 chiffre"),
                  ValidationText(hasSpecialCharacter, "1 caractère spécial"),
                  ValidationText(hasMinLength, "8 caractères"),
                  SizedBox(height: Spacing.standard),
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
                        borderRadius: BorderRadius.circular(Spacing.small),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: Spacing.standard),
                  if (emailErrorMessage.isNotEmpty)
                    Text(emailErrorMessage,
                        style: typographyList
                            .firstWhere((element) =>
                                element.name == 'Subtitle small Regular')
                            .style), // Utilisation du style typographique
                  if (passwordErrorMessage.isNotEmpty)
                    Text(passwordErrorMessage,
                        style: typographyList
                            .firstWhere((element) =>
                                element.name == 'Subtitle small Regular')
                            .style), // Utilisation du style typographique
                  if (confirmPasswordErrorMessage.isNotEmpty)
                    Text(
                      confirmPasswordErrorMessage,
                      style: typographyList
                          .firstWhere((element) =>
                              element.name == 'Subtitle small Regular')
                          .style, // Utilisation du style typographique
                    ),
                  SizedBox(height: Spacing.medium),
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
                      style: typographyList
                          .firstWhere((element) =>
                              element.name == 'Subtitle large Regular')
                          .style, // Utilisation du style typographique
                    ),
                    SizedBox(height: Spacing.standard),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: "Continuer",
                        type: ButtonType.filled,
                        fillColor: MyColors
                            .secondary40, // Set to the desired fill color
                        strokeColor: null, // Set to the desired stroke color
                        textColor: MyColors
                            .defaultWhite, // Set to the desired text color
                        onPressed: signUp,
                        isLoading: false,
                        isDisabled: false,
                        icon: null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Spacing.extraHuge),
            ],
          ),
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
      padding: const EdgeInsets.only(left: Spacing.extraSmall),
      child: Row(
        children: [
          isValid
              ? Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: Spacing.standard,
                )
              : Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: Spacing.standard,
                ),
          SizedBox(width: Spacing.extraSmall),
          Text(label,
              style: typographyList
                  .firstWhere(
                      (element) => element.name == 'Subtitle large Regular')
                  .style), // Utilisation du style typographique
        ],
      ),
    );
  }
}

class MyContainer extends StatelessWidget {
  final Widget child;

  MyContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          top: Spacing.standard,
          left: Spacing.standard,
          right: Spacing.standard,
        ),
        child: Container(
          child: child,
        ),
      ),
    );
  }
}
