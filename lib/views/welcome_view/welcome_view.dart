import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart'; // Assurez-vous que le chemin vers votre fichier colors.dart est correct.
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/views/login_view/login_view.dart';
import 'package:swafe/views/register_view/register.dart';

void _showLoginBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Fermer le clavier
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: LoginView(),
          ),
        ),
      );
    },
  );
}

void _showRegisterPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => RegisterView()));
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 172),
              child: Text(
                "Il n’a jamais été aussi simple d’aller d'un point A à un point B en toute sécurité",
                style: typographyList
                    .firstWhere((info) => info.name == 'Title XXLarge Medium')
                    .style
                    .copyWith(
                      color:
                          MyColors.defaultWhite, // Utilisez la couleur warn40
                      // Autres propriétés de style comme fontSize, fontWeight, etc. si nécessaire
                    ),
                textAlign: TextAlign.left,
              ),
            ),
            const Spacer(),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showLoginBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: const Color.fromARGB(
                        255, 0, 0, 0), // Couleur de fond du bouton
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showRegisterPage(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.white, // Couleur de fond du bouton
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
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
                const SizedBox(height: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: WelcomeView(),
  ));
}
