import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/components/appbar/appbar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _valideCodeFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool visiblePassword = false;
  bool visibleConfirmPassword = false;
  String errorMessage = '';
  final _firebaseInstance = FirebaseAuth.instance;
  int activeStep = 1;
  int maxStep = 3;

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
    if (_registerFormKey.currentState!.validate()) {
      try {
        // Reset errorMessage
        setState(() {
          errorMessage = '';
        });

        // Enregistrez l'utilisateur
        UserCredential userCredential =
            await _firebaseInstance.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        // Passer a la prochaine étape
        setState(() {
          activeStep++;
        });

        // Envoyez l'email de vérification
        await userCredential.user?.sendEmailVerification();

        // Commencez à vérifier si l'utilisateur a vérifié son email dans un intervalle de temps
        Timer.periodic(
          const Duration(seconds: 3),
          (timer) async {
            // Vérifiez si l'utilisateur a validé son email
            await _firebaseInstance.currentUser!.reload();
            var user = _firebaseInstance.currentUser;
            if (user!.emailVerified) {
              timer.cancel();
              setState(() {
                activeStep++;
                Navigator.of(context).pushReplacementNamed('/home');
              });
            }
          },
        );
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

  Widget bodyBuilder() {
    switch (activeStep) {
      case 1:
        return registerForm();
      case 2:
        return codeValidationForm();
      default:
        return const CustomAppBar();
    }
  }

  Widget registerForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          CustomAppBar(iconButtonOnPressed: backPageLogic),
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
                  !RegExp(r'\b[\w.-]+@[\w.-]+\.\w{2,4}\b').hasMatch(value)) {
                return "L'adresse e-mail n'est pas valide.";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          IntlPhoneField(
            controller: _phoneController,
            decoration: customTextFieldDecoration.copyWith(
                label: const Text("N° de téléphone portable")),
            initialCountryCode: 'FR',
            countries: List<Country>.of(
                countries.where((ct) => ['FR'].contains(ct.code))),
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
                style: BodyLargeRegular),
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
    );
  }

  Widget codeValidationForm() {
    return Form(
      key: _valideCodeFormKey,
      child: Column(
        children: [
          CustomAppBar(iconButtonOnPressed: backPageLogic),
          const SizedBox(height: 24),
          Text(
              textAlign: TextAlign.center,
              "Nous vous avons envoyé un code de vérification sur boite mail :\n ${_emailController.text}",
              style: TitleLargeMedium),
          const SizedBox(height: 32),
          const CustomTextField(placeholder: 'Code de vérification'),
          const SizedBox(height: 32),
          InkWell(
            onTap: resendVerificationEmail,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'Vous ne l’avez pas reçu ? ',
                      style: BodyLargeRegular),
                  TextSpan(
                    text: 'Renvoyer le code',
                    style:
                        BodyLargeMedium.copyWith(color: MyColors.secondary40),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          CustomButton(
            label: 'Continuer',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void backPageLogic() async {
    if (activeStep > 1) {
      setState(() {
        activeStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  // Fonction pour renvoyer l'email de vérification
  void resendVerificationEmail() async {
    User? user = _firebaseInstance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: LinearProgressIndicator(
        color: MyColors.secondary40,
        backgroundColor: MyColors.neutral90,
        value: activeStep / maxStep,
        minHeight: 18,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenSize.height - 120),
            child: WillPopScope(
              onWillPop: () async {
                backPageLogic();
                return false;
              },
              child: bodyBuilder(),
            ),
          ),
        ),
      ),
    );
  }
}
