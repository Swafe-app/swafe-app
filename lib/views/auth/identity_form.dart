import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../DS/typographies.dart';
import '../../components/AppBar/appbar.dart';
import '../../components/Button/button.dart';
import '../../services/user_service.dart';
import 'camera_identity.dart';
import 'checking_identity.dart';

class IdentityFormView extends StatefulWidget {
  const IdentityFormView({super.key});

  @override
    IdentityFormViewState createState() => IdentityFormViewState();

}

class IdentityFormViewState extends State<IdentityFormView> {
  File? _selfie = File('');
  final storage = const FlutterSecureStorage();

  Future<void> uploadSelfie() async {
      try {
        String? token = await storage.read(key: 'token');
        print("token: $token");
        final userServices = UserService();
        userServices
            .uploadSelfie(
          token! ,
          _selfie!,
        )
            .then((value) {
          print(value);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CheckingIdentity()));
        });
      } catch (e) {
        if (kDebugMode) {
          print("Firebase Error: $e");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppBar(iconButtonOnPressed: () => Navigator.pop(context)),
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
          _selfie!.path.isNotEmpty ?
          CustomButton(
            label: 'Continuer',
            onPressed: () => (uploadSelfie()),
          ) : Container(),
        ],
      ),
    ),);
  }
}

