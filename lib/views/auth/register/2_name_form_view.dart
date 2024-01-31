import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/views/auth/register_view.dart';

class NameForm extends StatefulWidget {
  final RegistrationData registrationData;
  final VoidCallback backPageLogic;
  final VoidCallback nextStep;

  const NameForm({
    super.key,
    required this.registrationData,
    required this.backPageLogic,
    required this.nextStep,
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
            const SizedBox(height: 24),
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
            const Spacer(),
            CustomButton(
              isLoading: context.read<AuthBloc>().state is RegisterLoading,
              label: 'Continuer',
              onPressed: () => signUp(),
            ),
          ],
        ),
      ),
    );
  }
}
