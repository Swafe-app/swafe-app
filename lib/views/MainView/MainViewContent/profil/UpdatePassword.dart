import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/helper/getFirebaseErrorMessage.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  UpdatePasswordViewState createState() => UpdatePasswordViewState();
}

class UpdatePasswordViewState extends State<UpdatePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool visibleCurrentPassword = false;
  bool visibleNewPassword = false;
  bool visibleConfirmNewPassword = false;
  String errorMessage = '';

  Future<void> updatePassword() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmNewPasswordController.text) {
        try {
          User? user = FirebaseAuth.instance.currentUser;

          // Reconnecter l'utilisateur
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: user?.email ?? '',
            password: _currentPasswordController.text,
          );

          // Mettre à jour le mot de passe
          await user?.updatePassword(_newPasswordController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Votre mot de passe a été mis à jour avec succès.")),
          );

          Navigator.of(context).pop();
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
      } else {
        setState(() {
          errorMessage = 'Les mots de passe ne correspondent pas.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CustomAppBar(),
              const SizedBox(height: 24),
              Text(
                'Modifier votre mot de passe',
                style: TitleLargeMedium,
              ),
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
                placeholder: 'Mot de passe actuel',
                controller: _currentPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe.';
                  }
                  return null;
                },
                obscureText: !visibleCurrentPassword,
                rightIcon: visibleCurrentPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onRightIconPressed: () => setState(
                    () => visibleCurrentPassword = !visibleCurrentPassword),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                placeholder: 'Confirmer le mot de passe',
                controller: _newPasswordController,
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
                obscureText: !visibleNewPassword,
                rightIcon: visibleNewPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onRightIconPressed: () =>
                    setState(() => visibleNewPassword = !visibleNewPassword),
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
                controller: _confirmNewPasswordController,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Les mots de passe ne correspondent pas.';
                  }
                  return null;
                },
                obscureText: !visibleConfirmNewPassword,
                rightIcon: visibleConfirmNewPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onRightIconPressed: () => setState(() =>
                    visibleConfirmNewPassword = !visibleConfirmNewPassword),
              ),
              const Spacer(),
              CustomButton(
                label: 'Continuer',
                onPressed: () => updatePassword(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
