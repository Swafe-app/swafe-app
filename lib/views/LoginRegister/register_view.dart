import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:swafe/helper/getFirebaseErrorMessage.dart';
import 'package:swafe/views/LoginRegister/valide_email_code.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool visiblePassword = false;
  bool visibleConfirmPassword = false;
  String phoneCountryCode = '33';
  String errorMessage = '';
  final _firebaseInstance = FirebaseAuth.instance;
  int activeStep = 1;
  int maxStep = 3;
  bool hasUpperCase = false;
  bool hasDigit = false;
  bool hasSpecialCharacter = false;
  bool hasMinLength = false;

  void _validatePassword(String value) {
    setState(() {
      hasUpperCase = value.contains(RegExp(r'[A-Z]'));
      hasDigit = value.contains(RegExp(r'[0-9]'));
      hasSpecialCharacter = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>+]'));
      hasMinLength = value.length >= 8;
    });
  }

  void onEmailVerified() {
    setState(() {
      activeStep++;
    });
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> signUp() async {
    setState(() {
      errorMessage = '';
    });
    if (_registerFormKey.currentState!.validate()) {
      try {
        // Reset errorMessage
        setState(() {
          errorMessage = '';
        });

        // Enregistrez l'utilisateur
        UserCredential userCredential =
            await _firebaseInstance.createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        // Envoyez l'email de vérification
        await userCredential.user?.sendEmailVerification();

        // Enregistrer le numéro de téléphone
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'email': _emailController.text.trim(),
          'firstName': "",
          'lastName': "",
          'phoneNumber': _phoneController.text.trim(),
          'phoneCountryCode': phoneCountryCode,
        });

        // Passer a la prochaine étape
        setState(() {
          activeStep++;
        });
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
          errorMessage = getFirebaseErrorMessage('');
        });
      }
    }
  }

  Widget bodyBuilder() {
    switch (activeStep) {
      case 1:
        return registerForm();
      case 2:
        return CodeValidationView(
          email: _emailController.text.trim(),
          onSuccess: onEmailVerified,
          customBackPageLogic: backPageLogic,
        );
      default:
        return const CustomAppBar();
    }
  }

  Widget _buildCriteriaRow(String criteria, bool isValid) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 5),
        Text(criteria, style: BodyLargeRegular),
      ],
    );
  }

  Widget registerForm() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
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
                      !RegExp(r'\b[\w.-]+@[\w.-]+\.\w{2,4}\b')
                          .hasMatch(value)) {
                    return "L'adresse e-mail n'est pas valide.";
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              IntlPhoneField(
                controller: _phoneController,
                invalidNumberMessage: 'Entrez un numéro de téléphone valide.',
                validator: (phone) {
                  if (phone == null || phone.number.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone.';
                  }
                  return null;
                },
                onCountryChanged: (newCountryCode) {
                  setState(() {
                    phoneCountryCode = newCountryCode.dialCode;
                  });
                },
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
                onChanged: (value) => _validatePassword(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe.';
                  }
                  RegExp regex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>+]).{8,}$');
                  if (!regex.hasMatch(value)) {
                    return 'Doit contenir au moins 8 caractères dont 1 majuscule, 1 chiffre et 1 caractère spécial.';
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Doit contenir au moins :', style: BodyLargeRegular),
                    _buildCriteriaRow('1 majuscule', hasUpperCase),
                    _buildCriteriaRow('1 chiffre', hasDigit),
                    _buildCriteriaRow(
                        '1 caractère spécial', hasSpecialCharacter),
                    _buildCriteriaRow('8 caractères', hasMinLength),
                  ],
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
        ));
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
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenSize.height),
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
