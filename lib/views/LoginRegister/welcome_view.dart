import 'package:flutter/material.dart'; // Importation du package Flutter pour créer des interfaces utilisateur.
import 'package:swafe/DS/colors.dart'; // Importation de couleurs personnalisées.
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/ds/typographies.dart'; // Importation de styles de texte personnalisés.
import 'package:swafe/views/LoginRegister/login_view.dart'; // Importation de la vue de connexion.
import 'package:swafe/views/LoginRegister/register.dart'; // Importation de la vue d'inscription.

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
            child: LoginView(), // Afficher la vue de connexion.
          ),
        ),
      );
    },
  );
}

// Fonction pour naviguer vers la page d'inscription
void _showRegisterPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => RegisterView()));
}

// Classe de la vue de bienvenue
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Couleur de fond de l'écran.
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Spacing
                .standard), // Utilisation de la constante Spacing.standard pour l'espacement horizontal.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Spacing
                      .XXHuge), // Utilisation de la constante Spacing.large pour la marge supérieure.
              child: Text(
                "Il n’a jamais été aussi simple d’aller d'un point A à un point B en toute sécurité",
                style: typographyList
                    .firstWhere((info) => info.name == 'Title XLarge Medium')
                    .style
                    .copyWith(
                      color: MyColors.defaultWhite,
                    ),
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(), // Espace flexible pour occuper l'espace entre le texte et les boutons.
            Column(
              children: [
                CustomButton(
                  label: "Tu as déjà un compte ? Se connecter",
                  type: ButtonType.text,
                  textColor:
                      MyColors.defaultWhite, // Set to the desired text color
                  onPressed: () {
                    _showLoginBottomSheet(context);
                  },
                  isLoading: false,
                  isDisabled: false,
                ),
                SizedBox(
                    height: Spacing
                        .medium), // Utilisation de la constante Spacing.medium pour l'espacement vertical.
                CustomButton(
                  label: "S’inscrire",
                  type: ButtonType.filled,
                  fillColor:
                      MyColors.defaultWhite, // Set to the desired fill color
                  textColor:
                      MyColors.primary10, // Set to the desired text color
                  onPressed: () {
                    _showRegisterPage(context);
                  },
                  isLoading: false,
                  isDisabled: false,
                ),
              ],
            ),
            SizedBox(
                height: Spacing
                    .huge), // Utilisation de la constante Spacing.huge pour l'espacement vertical depuis le bas.
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home:
        WelcomeView(), // Afficher la vue de bienvenue en tant qu'écran d'accueil.
  ));
}
