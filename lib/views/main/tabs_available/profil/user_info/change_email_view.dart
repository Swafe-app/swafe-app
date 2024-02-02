import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';

class ChangeEmail extends StatefulWidget {
  final String? email;

  const ChangeEmail({super.key, required this.email});

  @override
  ChangeEmailState createState() => ChangeEmailState();
}

class ChangeEmailState extends State<ChangeEmail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email ?? '';
  }

  void updateUserEmail() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        UpdateUserEvent(
          email: emailController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const CustomAppBar(),
                const SizedBox(height: 24),
                Text(
                  'Modifier votre e-mail',
                  style: TitleLargeMedium,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  placeholder: 'E-mail',
                  controller: emailController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r'\b[\w.-]+@[\w.-]+\.\w{2,4}\b')
                            .hasMatch(value)) {
                      return "L'adresse e-mail n'est pas valide.";
                    }
                    return null;
                  },
                ),
                const Spacer(),
                CustomButton(
                  isLoading:
                      context.watch<AuthBloc>().state is UpdateUserLoading,
                  label: "Modifier",
                  onPressed: () => updateUserEmail(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
