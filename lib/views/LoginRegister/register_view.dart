import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/components/appbar/appbar.dart';
import 'package:swafe/firebase/firebase_auth_services.dart';
import 'package:swafe/views/MainView/home.dart';

class RegisterViewOld extends StatefulWidget {
  const RegisterViewOld({super.key});

  @override
  RegisterViewStateOld createState() => RegisterViewStateOld();
}

class RegisterViewStateOld extends State<RegisterView> {
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
            builder: (context) => HomeView(),
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
                  style: BodyLargeRegular,
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
                  Text(emailErrorMessage, style: SubtitleSmallRegular),
                if (passwordErrorMessage.isNotEmpty)
                  Text(passwordErrorMessage, style: SubtitleSmallRegular),
                if (confirmPasswordErrorMessage.isNotEmpty)
                  Text(confirmPasswordErrorMessage,
                      style: SubtitleSmallRegular),
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
                    style: SubtitleLargeRegular,
                  ),
                  const SizedBox(height: Spacing.standard),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: "Continuer",
                      fillColor: MyColors.secondary40,
                      textColor: MyColors.defaultWhite,
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
          Text(label, style: SubtitleLargeRegular),
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

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool visiblePassword = false;
  bool visibleConfirmPassword = false;
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
        return 'Trop de tentatives d\'inscription échouées. Veuillez réessayer plus tard.';
      default:
        return 'Une erreur est survenue lors de l\'inscription. Veuillez réessayer plus tard.';
    }
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Reset errorMessage
        setState(() {
          errorMessage = '';
        });

        final user = await _authInstance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
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
          errorMessage = "Une erreur est survenue lors de l'inscription.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const CustomAppBar(),
                const SizedBox(height: 24),
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
                  placeholder: 'N° de téléphone portable',
                  controller: _phoneController,
                  validator: (value) {
                    return null;
                  },
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
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                      "Doit contenir au moins :\n  • 1 majuscule\n  • 1 chiffre\n  • 1 caractère spécial\n  • 8 caractères",
                      style: BodyLargeRegular
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  placeholder: 'Confirmer le mot de passe',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas.';
                    }
                    return null;
                  },
                  obscureText: !visibleConfirmPassword,
                  rightIcon: visibleConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onRightIconPressed: () => setState(
                      () => visibleConfirmPassword = !visibleConfirmPassword),
                ),
                const Spacer(),
                Text(
                    textAlign: TextAlign.center,
                    "En cliquant sur “continuer”, vous acceptez les\n conditions générales d’utilisation",
                    style: SubtitleLargeRegular),
                const SizedBox(height: 20),
                CustomButton(
                  label: 'Continuer',
                  onPressed: () => signUp(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
