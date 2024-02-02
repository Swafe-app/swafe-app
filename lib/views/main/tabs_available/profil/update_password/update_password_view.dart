import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/helper/render_password_criteria.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  UpdatePasswordViewState createState() => UpdatePasswordViewState();
}

class UpdatePasswordViewState extends State<UpdatePasswordView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  bool visibleCurrentPassword = false;
  bool visibleNewPassword = false;
  bool visibleConfirmNewPassword = false;
  bool hasUpperCase = false;
  bool hasDigit = false;
  bool hasSpecialCharacter = false;
  bool hasMinLength = false;

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
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

  void updatePassword() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            UpdatePasswordEvent(
              currentPasswordController.text,
              newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdatePasswordSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                label: 'Votre mot de passe a été mis à jour avec succès.',
              ),
            ),
          );
        }
        if (state is UpdatePasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomSnackbar(
                label: state.message,
                isError: true,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const CustomAppBar(),
                const SizedBox(height: 24),
                Text(
                  'Modifier votre mot de passe',
                  style: TitleLargeMedium,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  placeholder: 'Mot de passe actuel',
                  controller: currentPasswordController,
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
                  placeholder: 'Nouveau mot de passe',
                  controller: newPasswordController,
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
                  obscureText: !visibleNewPassword,
                  rightIcon: visibleNewPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onRightIconPressed: () =>
                      setState(() => visibleNewPassword = !visibleNewPassword),
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
                      buildCriteriaRow(
                          '1 caractère spécial', hasSpecialCharacter),
                      buildCriteriaRow('8 caractères', hasMinLength),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  placeholder: 'Confirmer le mot de passe',
                  controller: confirmNewPasswordController,
                  validator: (value) {
                    if (value != newPasswordController.text) {
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
                  isLoading: context.watch<AuthBloc>().state is UpdatePasswordLoading,
                  label: 'Continuer',
                  onPressed: () => updatePassword(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
