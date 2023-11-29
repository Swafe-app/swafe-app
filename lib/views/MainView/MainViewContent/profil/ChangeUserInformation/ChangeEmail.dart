import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/helper/getFirebaseErrorMessage.dart';
import 'package:swafe/views/LoginRegister/valide_email_code.dart';

class ChangeEmail extends StatefulWidget {
  final String? email;

  const ChangeEmail({super.key, required this.email});

  @override
  ChangeEmailState createState() => ChangeEmailState();
}

class ChangeEmailState extends State<ChangeEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? '';
  }

  void onEmailVerified() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<void> updateUserEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await user?.updateEmail(_emailController.text.trim());
        if (!user!.emailVerified) {
          user.sendEmailVerification();
        }
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CodeValidationView(
            email: _emailController.text.trim(),
            onSuccess: onEmailVerified,
          ),
        ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CustomAppBar(),
              const SizedBox(height: 24),
              Text(
                'Modifier votre e-mail',
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
              ),
              const Spacer(),
              CustomButton(
                label: "Modifier",
                onPressed: () => updateUserEmail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
