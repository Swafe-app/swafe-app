import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/appbar/custom_appbar_page.dart';
import 'package:swafe/firebase/firebase_auth_services.dart';
import 'package:swafe/views/MainView/home.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecialCharacter = false;
  bool hasMinLength = false;

  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String confirmPasswordErrorMessage = '';

  bool arePasswordsMatching() {
    return passwordController.text == confirmPasswordController.text;
  }

  bool isButtonEnabled() {
    return emailController.text.isNotEmpty &&
        EmailValidator.validate(emailController.text) &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        hasUppercase &&
        hasNumber &&
        hasSpecialCharacter &&
        hasMinLength &&
        arePasswordsMatching();
  }

  void updateErrorMessages() {
    setState(() {
      if (emailController.text.isEmpty) {
        emailErrorMessage = '';
      } else if (!EmailValidator.validate(emailController.text)) {
        emailErrorMessage = 'Veuillez saisir une adresse e-mail valide';
      } else {
        emailErrorMessage = '';
      }

      if (passwordController.text.isEmpty) {
        passwordErrorMessage = '';
      } else if (!hasUppercase ||
          !hasNumber ||
          !hasSpecialCharacter ||
          !hasMinLength) {
        passwordErrorMessage = 'Le mot de passe ne respecte pas les critères';
      } else {
        passwordErrorMessage = '';
      }

      if (confirmPasswordController.text.isEmpty) {
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
        emailController.text,
        passwordController.text,
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
      appBar: const CustomAppBar(
        title: 'Inscription',
      ),
      body: MyContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(Spacing.small),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.standard),
                TextField(
                  controller: passwordController,
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
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(Spacing.small),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: Spacing.standard),
                Text(
                  "Doit contenir au moins :",
                  style: typographyList
                      .firstWhere(
                          (element) => element.name == 'Body Large Regular')
                      .style, // Utilisation du style typographique
                ),
                const SizedBox(height: Spacing.extraSmall),
                ValidationText(hasUppercase, "1 majuscule"),
                ValidationText(hasNumber, "1 chiffre"),
                ValidationText(hasSpecialCharacter, "1 caractère spécial"),
                ValidationText(hasMinLength, "8 caractères"),
                const SizedBox(height: Spacing.standard),
                TextField(
                  controller: confirmPasswordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirmation du mot de passe',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(Spacing.small),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: Spacing.standard),
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
                const SizedBox(height: Spacing.medium),
              ],
            ),
            const Spacer(),
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
                  const SizedBox(height: Spacing.standard),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: "Continuer",
                      fillColor: MyColors
                          .secondary40,
                      textColor: MyColors
                          .defaultWhite,
                      onPressed: signUp,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.extraHuge),
          ],
        ),
      ),
    );
  }
}

class ValidationText extends StatelessWidget {
  final bool isValid;
  final String label;

  const ValidationText(this.isValid, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Spacing.extraSmall),
      child: Row(
        children: [
          isValid
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: Spacing.standard,
                )
              : const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: Spacing.standard,
                ),
          const SizedBox(width: Spacing.extraSmall),
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

  const MyContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
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
