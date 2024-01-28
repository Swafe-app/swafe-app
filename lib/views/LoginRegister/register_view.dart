import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/components/appbar/appbar.dart';
import 'package:swafe/helper/getFirebaseErrorMessage.dart';
import 'package:swafe/views/LoginRegister/camera_identity.dart';
import 'package:swafe/views/LoginRegister/checking_identity.dart';
import 'package:swafe/services/user_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool visiblePassword = false;
  bool visibleConfirmPassword = false;
  String phoneCountryCode = '33';
  String errorMessage = '';
  int activeStep = 1;
  int maxStep = 3;
  bool hasUpperCase = false;
  bool hasDigit = false;
  bool hasSpecialCharacter = false;
  bool hasMinLength = false;
  late File? _selfie = File('');
  String token = '';
  final storage = FlutterSecureStorage();

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
        final userServices = UserService();
        // Enregistrer le numéro de téléphone
        userServices
            .createUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
        )
            .then((value) async {
          token = value["token"];
          await storage.write(key: 'token', value: value['token']);
          await storage.write(key: 'emailVerified', value: value['user']['emailVerified'] ? 'true' : 'false');
          await storage.write(key: 'selfieStatus', value: value['user']['selfieStatus']);
        });
        userServices
            .updateUser(
                token,
                _emailController.text.trim(),
                _firstNameController.text.trim(),
                _lastNameController.text.trim(),
                phoneCountryCode,
                _phoneController.text.trim())
            .then((value) => print(value));

        // Passer a la prochaine étape
        setState(() {
          activeStep++;
        });
      } catch (e) {
        if (kDebugMode) {
          print("Firebase Error: $e");
        }
        setState(() {
          errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> uploadSelfie() async {
    setState(() {
      errorMessage = '';
    });
    if (_registerFormKey.currentState!.validate()) {
      try {
        // Reset errorMessage
        setState(() {
          errorMessage = '';
        });
        final userServices = UserService();
        print(_selfie!.path);
        userServices
            .uploadSelfie(
              token,
              _selfie!,
            )
            .then((value) => print(value));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CheckingIdentity()));
      } catch (e) {
        if (kDebugMode) {
          print("Firebase Error: $e");
        }
        setState(() {
          errorMessage = e.toString();
        });
      }
    }
  }

  Widget bodyBuilder() {
    switch (activeStep) {
      case 1:
        return registerForm();
      case 2:
        return nameForm();
      case 3:
        return identityForm();
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  onPressed: () {
                    setState(() {
                      activeStep++;
                    });
                  }),
            ],
          ),
        ));
  }

  Widget nameForm() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: _registerFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                placeholder: 'Nom',
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer votre nom.";
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                placeholder: 'Prénom',
                controller: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer votre prénom.";
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              const Spacer(),
              CustomButton(
                label: 'Continuer',
                onPressed: () => signUp(),
              ),
            ],
          ),
        ));
  }

  Widget identityForm() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: _registerFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppBar(iconButtonOnPressed: backPageLogic),
              const SizedBox(height: 24),
              Text(
                  textAlign: TextAlign.center,
                  "Vérification d'identité",
                  style: TitleLargeMedium),
              const SizedBox(height: 24),
              Text(
                  textAlign: TextAlign.center,
                  "Cette procédure nous permet de confirmer votre identité. La vérification d'identité est une des procédures que nous utilisons pour garantir la sécurité de Swafe.",
                  style: SubtitleLargeRegular),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.topLeft,
                child: CustomButton(
                  mainAxisSize: MainAxisSize.min,
                  label: "Prendre un selfie",
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CameraIdentity()));
                    if (result != null) {
                      setState(() {
                        _selfie = result;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "jpeg/png (5Mo maximum)",
                  style: TextStyle(
                    color: Color(0xFF71787E),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    height: 0.11,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                  textAlign: TextAlign.center,
                  "Les informations figurant sur votre pièces d’identité seront traitées conformément à notre Politique de confidentialité et ne seront pas communiquées aux autres.",
                  style: SubtitleLargeRegular),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Continuer',
                onPressed: () => (uploadSelfie()),
                isDisabled: _selfie!.path.isEmpty,
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
