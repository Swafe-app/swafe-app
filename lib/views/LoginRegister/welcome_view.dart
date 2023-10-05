import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/ds/typographies.dart';
import 'package:swafe/views/LoginRegister/login_view.dart';
import 'package:swafe/views/LoginRegister/register.dart';

// Classe de la vue de bienvenue
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  // Fonction pour afficher la feuille de bas de connexion
  void showLoginBottomSheet(BuildContext context) {
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
                      Spacing.standard),
              child: const LoginView(), // Afficher la vue de connexion.
            ),
          ),
        );
      },
    );
  }

  // Fonction pour naviguer vers la page d'inscription
  void showRegisterPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Couleur de fond de l'écran.
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.standard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(top: Spacing.xxHuge),
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
            const Spacer(),
            // Espace flexible pour occuper l'espace entre le texte et les boutons.
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showLoginBottomSheet(
                        context); // Afficher la feuille de bas de connexion.
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: const Color.fromARGB(255, 0, 0,
                        0), // Couleur de fond du bouton de connexion.
                  ),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: Spacing.standard),
                    // Utilisation de la constante Spacing.standard pour l'espacement vertical.
                    child: const Center(
                      child: Text(
                        "Tu as déjà un compte ? Se connecter",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.medium),
                // Utilisation de la constante Spacing.medium pour l'espacement vertical.
                ElevatedButton(
                  onPressed: () {
                    showRegisterPage(
                        context); // Naviguer vers la page d'inscription.
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors
                        .white, // Couleur de fond du bouton d'inscription.
                  ),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: Spacing.standard),
                    // Utilisation de la constante Spacing.standard pour l'espacement vertical.
                    child: const Center(
                      child: Text(
                        "S’inscrire",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.huge),
          ],
        ),
      ),
    );
  }
}
