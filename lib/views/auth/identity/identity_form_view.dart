import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/services/user_service.dart';
import 'package:swafe/views/auth/camera_identity.dart';
import 'package:swafe/views/auth/checking_identity.dart';

class IdentityForm extends StatefulWidget {
  final VoidCallback? backPageLogic;

  const IdentityForm({
    super.key,
    this.backPageLogic,
  });

  @override
  IdentityFormState createState() => IdentityFormState();
}

class IdentityFormState extends State<IdentityForm> {
  final storage = const FlutterSecureStorage();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late File? _selfie = File('');

  void uploadSelfie() async {
    if (formKey.currentState!.validate()) {
      final userServices = UserService();
      print(_selfie!.path);
      userServices
          .uploadSelfie(
            await storage.read(key: 'token') ?? '',
            _selfie!,
          )
          .then((value) => print(value));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CheckingIdentity()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppBar(iconButtonOnPressed: widget.backPageLogic),
              const SizedBox(height: 24),
              Text(
                  textAlign: TextAlign.center,
                  "Vérification d'identité",
                  style: TitleLargeMedium),
              const SizedBox(height: 24),
              Text(
                  textAlign: TextAlign.center,
                  "Cette procédure nous permet de confirmer votre identité. La vérification d'identité est une des procédures que nous utilisons pour garantir la sécurité de Swafe.",
                  style: SubtitleLargeRegular),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.topLeft,
                child: CustomButton(
                  mainAxisSize: MainAxisSize.min,
                  label: "Prendre un selfie",
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CameraIdentity()));
                    if (result != null) {
                      setState(() {
                        _selfie = result;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "jpeg/png (5Mo maximum)",
                  style: TextStyle(
                    color: Color(0xFF71787E),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    height: 0.11,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                  textAlign: TextAlign.center,
                  "Les informations figurant sur votre pièces d’identité seront traitées conformément à notre Politique de confidentialité et ne seront pas communiquées aux autres.",
                  style: SubtitleLargeRegular),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Continuer',
                onPressed: () => (uploadSelfie()),
                isDisabled: _selfie!.path.isEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
