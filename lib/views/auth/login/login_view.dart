import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/components/TextField/textfield.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  LoginBottomSheetState createState() => LoginBottomSheetState();
}

class LoginBottomSheetState extends State<LoginBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool visiblePassword = false;

  void signIn() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginEvent(
          emailController.text.trim(),
          passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacementNamed('/main');
        }
        if (state is LoginEmailNotVerified) {
          Navigator.of(context).pushNamed('/validate-email');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                isError: true,
                label: "Veuillez vérifier votre email pour continuer.",
              ),
            ),
          );
        }
        if (state is LoginSelfieRedirect) {
          Navigator.of(context).pushNamed('/upload-selfie');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                isError: true,
                label: "Une photo de vous est requise pour continuer.",
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barre visuel pour le BottomSheet
              Container(
                width: 160,
                height: 8,
                decoration: BoxDecoration(
                  color: MyColors.neutral70,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is LoginError) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        state.message,
                        style:
                            BodyLargeMedium.copyWith(color: MyColors.error40),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              CustomTextField(
                placeholder: 'E-mail',
                controller: emailController,
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
                placeholder: 'Mot de passe',
                controller: passwordController,
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    'Mot de passe oublié ?',
                    style:
                        BodyLargeMedium.copyWith(color: MyColors.secondary40),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              CustomButton(
                label: 'Continuer',
                onPressed: () => signIn(),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Pas encore membre ? ', style: BodyLargeMedium),
                      TextSpan(
                        text: 'Rejoignez-nous !',
                        style: BodyLargeMedium.copyWith(
                            color: MyColors.secondary40),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
