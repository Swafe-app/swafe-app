import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/services/user_service.dart';

class CodeValidationView extends StatefulWidget {
  final String? email;

  const CodeValidationView({
    super.key,
    this.email,
  });

  @override
  CodeValidationViewState createState() => CodeValidationViewState();
}

class CodeValidationViewState extends State<CodeValidationView> {
  final GlobalKey<FormState> _valideCodeFormKey = GlobalKey<FormState>();
  String errorMessage = '';
  final userServices = UserService();
  final storage = const FlutterSecureStorage();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Commencez à vérifier si l'utilisateur a vérifié son email dans un intervalle de temps
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        // Vérifiez si l'utilisateur a validé son email
        String token = (await storage.read(key: 'token'))!;
        await userServices.verifyEmail(token).then((value) {
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                  label: "Votre e-mail a été vérifié avec succès."),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await userServices
        .verifyEmail(await storage.read(key: 'token') ?? '')
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomSnackbar(
            label: "Votre e-mail a été vérifié avec succès.",
          ),
        ),
      );
    }).catchError((error) {
      setState(() {
        errorMessage = "Veuillez vérifier votre email pour continuer.";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Form(
          key: _valideCodeFormKey,
          child: Column(
            children: [
              const CustomAppBar(),
              const SizedBox(height: 24),
              Text(
                  textAlign: TextAlign.center,
                  "Nous vous avons envoyé un lien de vérification sur ${widget.email != null ? 'votre email :\n' : 'l\'email que vous avez fourni'}",
                  style: TitleLargeMedium),
              const SizedBox(height: 32),
              // const CustomTextField(placeholder: 'Code de vérification'),
              // const SizedBox(height: 32),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    errorMessage,
                    style: BodyLargeMedium.copyWith(color: MyColors.error40),
                  ),
                ),
              const Spacer(),
              CustomButton(
                label: 'Continuer',
                onPressed: checkEmailVerified,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
