import 'package:flutter/material.dart'; // Importation du package Flutter pour créer des interfaces utilisateur.
import 'package:swafe/DS/colors.dart'; // Importation de couleurs personnalisées.
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/ds/typographies.dart'; // Importation de styles de texte personnalisés.
import 'package:swafe/views/LoginRegister/login_view.dart'; // Importation de la vue de connexion.
import 'package:swafe/views/LoginRegister/register.dart'; // Importation de la vue d'inscription.

void main() {
  runApp(const MaterialApp(
    home:
        WelcomeView(), // Afficher la vue de bienvenue en tant qu'écran d'accueil.
  ));
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

// Fonction pour afficher la feuille de bas de connexion
  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // Fermer le clavier lorsque l'utilisateur clique en dehors de la feuille.
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    Spacing
                        .standard, // Utilisation de la constante Spacing.standard pour l'espacement.
              ),
              child: const LoginView(), // Afficher la vue de connexion.
            ),
          ),
        );
      },
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
                horizontal: Spacing.doubleExtraLarge),
            // Utilisation de la constante Spacing.standard pour l'espacement horizontal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
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
                const Spacer(),
                // Espace flexible pour occuper l'espace entre le texte et les boutons.
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
                            fillColor: null,
                            // Set to the desired fill color
                            strokeColor: null,
                            // Set to the desired stroke color
                            textColor: MyColors.defaultWhite,
                            // Set to the desired text color
                            onPressed: () {
                              _showLoginBottomSheet(
                                  context); // Afficher la feuille de bas de connexion.
                            },
                            isLoading: false,
                            isDisabled: false),
                        CustomButton(
                          label: "S'inscrire",
                          fillColor: MyColors.defaultWhite,
                          // Set to the desired fill color
                          strokeColor: null,
                          // Set to the desired stroke color
                          textColor: MyColors.primary10,
                          // Set to the desired text color
                          onPressed: () {
                            _showRegisterPage(
                                context); // Naviguer vers la page d'inscription.
                          },
                          isLoading: false,
                          isDisabled: false,
                          icon: null, // Set to the desired icon
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
