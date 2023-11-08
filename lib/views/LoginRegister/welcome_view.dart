import 'package:flutter/material.dart'; // Importation du package Flutter pour créer des interfaces utilisateur.
import 'package:swafe/DS/colors.dart'; // Importation de couleurs personnalisées.
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/ds/typographies.dart'; // Importation de styles de texte personnalisés.
import 'package:swafe/views/LoginRegister/login_view.dart';
import 'package:swafe/views/LoginRegister/register.dart'; // Importation de la vue d'inscription.

void main() {
  runApp(const MaterialApp(
    home: WelcomeView(),
  ));
}

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
      builder: (context) => const LoginBottomSheet()
    );
  }

  // Fonction pour naviguer vers la page d'inscription
  void _showRegisterPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Make the stack take up the entire screen
        children: <Widget>[
          Image.asset(
            'assets/images/gradient.png',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.tripleExtraLarge),
            // Utilisation de la constante Spacing.standard pour l'espacement horizontal.
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 295),
                  child: Container(
                    margin: const EdgeInsets.only(top: Spacing.xxHuge),
                    // Utilisation de la constante Spacing.large pour la marge supérieure.
                    child: Text(
                      "Il n’a jamais été aussi simple d’aller d'un point A à un point B en toute sécurité",
                      style: typographyList
                          .firstWhere(
                              (info) => info.name == 'Title XLarge Medium')
                          .style
                          .copyWith(
                            color: MyColors.defaultWhite,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                // Espace flexible pour occuper l'espace entre le texte et les boutons
                const Spacer(),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: Spacing.standard),
                    // Utilisation de la constante Spacing.standard pour l'espacement vertical.
                    child: Column(
                      children: [
                        CustomButton(
                          label: "Tu as déjà un compte ? Se connecter",
                          type: ButtonType.text,
                          textColor: MyColors.defaultWhite,
                          mainAxisSize: MainAxisSize.max,
                          onPressed: () {
                            _showLoginBottomSheet(context);
                          },
                        ),
                        const SizedBox(height: Spacing.small),
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
                    )),
                const SizedBox(height: Spacing.huge),
                // Utilisation de la constante Spacing.huge pour l'espacement vertical depuis le bas.
              ],
            ),
          ),
        ],
      ),
    );
  }
}
