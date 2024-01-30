import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/helper/render_password_criteria.dart';
import 'package:swafe/services/user_service.dart';
import 'package:swafe/views/auth/register_view.dart';

class NameForm extends StatefulWidget {
  final RegistrationData registrationData;
  final VoidCallback backPageLogic;
  final VoidCallback nextStep;
  final FlutterSecureStorage storage;

  const NameForm({
    super.key,
    required this.registrationData,
    required this.backPageLogic,
    required this.nextStep,
    required this.storage,
  });

  @override
  NameFormState createState() => NameFormState();
}

class NameFormState extends State<NameForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void signUp() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpEvent(
          widget.registrationData.email.trim(),
          widget.registrationData.password.trim(),
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          widget.registrationData.phoneCountryCode,
          widget.registrationData.phoneNumber.trim(),
        ),
      );
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
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is RegisterError) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    state.message ?? 'Une erreur est survenu',
                    style: BodyLargeMedium.copyWith(color: MyColors.error40),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            CustomTextField(
              placeholder: 'Nom',
              controller: lastNameController,
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
              controller: firstNameController,
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
      ),
    );
  }
}
