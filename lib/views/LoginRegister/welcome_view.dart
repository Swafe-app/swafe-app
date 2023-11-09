import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/views/LoginRegister/login_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  // Fonction pour afficher la modal de connexion
  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
        builder: (context) => const LoginBottomSheet());
  }

  // Fonction pour naviguer vers la page d'inscription
  void _showRegisterPage(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/gradient.png',
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 80),
            child: Column(
              children: [
                const CustomAppBar(
                  showIconButton: false,
                ),
                const SizedBox(height: 72),
                Text(
                  "Il n’a jamais été aussi\n simple d’aller d'un point A\n à un point B en toute\n sécurité",
                  style:
                      TitleXLargeMedium.copyWith(color: MyColors.defaultWhite),
                  textAlign: TextAlign.left,
                ),
                const Spacer(),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _showLoginBottomSheet(context);
                      },
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "Tu as déjà un compte ? ",
                              style: BodyXLargeRegular.copyWith(
                                  color: MyColors.defaultWhite)),
                          TextSpan(
                              text: "Se connecter",
                              style: BodyXLargeMedium.copyWith(
                                  color: MyColors.defaultWhite))
                        ]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      label: "S'inscrire",
                      fillColor: MyColors.defaultWhite,
                      textColor: MyColors.primary10,
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () {
                        _showRegisterPage(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
