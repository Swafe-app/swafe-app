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
  final String email;
  final VoidCallback onSuccess;
  final VoidCallback? customBackPageLogic;

  const CodeValidationView(
      {super.key,
      required this.email,
      required this.onSuccess,
      this.customBackPageLogic});

  @override
  CodeValidationViewState createState() => CodeValidationViewState();
}

class CodeValidationViewState extends State<CodeValidationView> {
  final GlobalKey<FormState> _valideCodeFormKey = GlobalKey<FormState>();
  String errorMessage = '';
  final userServices= UserService();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // Commencez à vérifier si l'utilisateur a vérifié son email dans un intervalle de temps
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        // Vérifiez si l'utilisateur a validé son email
        /*await FirebaseAuth.instance.currentUser!.reload();
        var user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(label: "Votre e-mail a été vérifié avec succès.")
            ),
          );
          widget.onSuccess();
        }*/
        String token = (await storage.read(key: 'token'))!;
        print("token $token");
        await userServices.verifyEmail(token).then((value) {
          print(value);
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: CustomSnackbar(label: "Votre e-mail a été vérifié avec succès.")
            ),
          );
          widget.onSuccess();
        });
      },
    );
  }

  Future<void> checkEmailVerified() async {
    /*User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user?.emailVerified ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomSnackbar(label: "Votre e-mail a été vérifié avec succès."),
        ),
      );
      widget.onSuccess();
    } else {
      setState(() {
        errorMessage = "Veuillez vérifier votre email pour continuer.";
      });
    }*/
    String token = (await storage.read(key: 'token'))!;
    print("token $token");
    await userServices.verifyEmail(token).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: CustomSnackbar(label: "Votre e-mail a été vérifié avec succès.")
        ),
      );
      widget.onSuccess();
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
              widget.customBackPageLogic != null
                  ? CustomAppBar(
                      iconButtonOnPressed: widget.customBackPageLogic)
                  : const CustomAppBar(),
              const SizedBox(height: 24),
              Text(
                  textAlign: TextAlign.center,
                  "Nous vous avons envoyé un lien de vérification sur la boite mail :\n ${widget.email}",
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
