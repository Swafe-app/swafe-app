import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/helper/render_password_criteria.dart';
import 'package:swafe/views/auth/register_view.dart';

class RegisterForm extends StatefulWidget {
  final RegistrationData registrationData;
  final VoidCallback backPageLogic;
  final VoidCallback nextStep;
  final FlutterSecureStorage storage;

  const RegisterForm({
    super.key,
    required this.registrationData,
    required this.backPageLogic,
    required this.nextStep,
    required this.storage,
  });

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool visiblePassword = false;
  bool visibleConfirmPassword = false;
  bool hasUpperCase = false;
  bool hasDigit = false;
  bool hasSpecialCharacter = false;
  bool hasMinLength = false;

  @override
  void initState() {
    super.initState();
    emailController =
        TextEditingController(text: widget.registrationData.email);
    phoneNumberController =
        TextEditingController(text: widget.registrationData.phoneNumber);
    passwordController =
        TextEditingController(text: widget.registrationData.password);
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword(String value) {
    setState(() {
      hasUpperCase = value.contains(RegExp(r'[A-Z]'));
      hasDigit = value.contains(RegExp(r'[0-9]'));
      hasSpecialCharacter = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>+]'));
      hasMinLength = value.length >= 8;
    });
  }

  void formSubmit() {
    if (formKey.currentState!.validate()) {
      widget.registrationData.email = emailController.text.trim();
      widget.registrationData.password = passwordController.text.trim();
      widget.registrationData.phoneNumber = phoneNumberController.text.trim();
      widget.nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomAppBar(iconButtonOnPressed: widget.backPageLogic),
            const SizedBox(height: 24),
            CustomTextField(
              placeholder: 'E-mail',
              controller: emailController,
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
              controller: phoneNumberController,
              invalidNumberMessage: 'Entrez un numéro de téléphone valide.',
              validator: (phone) {
                if (phone == null || phone.number.isEmpty) {
                  return 'Veuillez entrer un numéro de téléphone.';
                }
                return null;
              },
              onCountryChanged: (newCountryCode) {
                widget.registrationData.phoneCountryCode =
                    newCountryCode.dialCode;
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
              controller: passwordController,
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
                  buildCriteriaRow('1 majuscule', hasUpperCase),
                  buildCriteriaRow('1 chiffre', hasDigit),
                  buildCriteriaRow('1 caractère spécial', hasSpecialCharacter),
                  buildCriteriaRow('8 caractères', hasMinLength),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              placeholder: 'Confirmer le mot de passe',
              controller: confirmPasswordController,
              validator: (value) {
                if (value != passwordController.text) {
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
              onPressed: () => formSubmit(),
            ),
          ],
        ),
      ),
    );
  }
}
