import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swafe/views/profil/ModifierInformationPersonnelle.dart';
import 'package:swafe/views/profil/ModifierMotdepasse.dart';
import 'package:swafe/views/profil/ReauthenticationPage.dart';
import 'package:swafe/views/welcome_view/welcome_view.dart';

class ProfilContent extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeView()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF002B5D),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(
          255, 255, 255, 255), // Fond de couleur comme dans la page Répertoire
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16), // Ajustement des marges gauche et droite
        child: ListView(
          children: [
            // Catégorie "Paramètres"
            _buildCategory(
              context,
              'Paramètres',
              [
                'Information personnelle',
                'Coordonnées',
                'Mot de passe',
                'Mentions légales',
              ],
              [
                Icons.person,
                Icons.location_on,
                Icons.lock,
                Icons.book,
              ],
              // Navigation vers la page de modification d'informations personnelles
              [
                ModifierInformationPersonnelle(),
                ReauthenticationPage(),
                ModifierMotDePasseView(),
                null
              ],
              FontWeight.normal, // Définir le poids de police à normal
            ),
            // Catégorie "Nous contacter"
            _buildCategory(
              context,
              'Nous contacter',
              [
                'FAQ / Aide',
              ],
              [
                Icons.help,
                Icons.help,
              ],
              // Ajoutez ici la navigation vers les pages correspondantes (FAQ, Aide)
              [null, null],
              FontWeight.normal, // Définir le poids de police à normal
            ),
            // Catégorie "Soutenir l'app"
            _buildCategory(
              context,
              'Soutenir l\'app',
              [
                'Partager l\'application',
              ],
              [
                Icons.share,
              ],
              // Ajoutez ici la navigation vers la page de partage de l'application
              [null],
              FontWeight.normal, // Définir le poids de police à normal
            ),
            // Ajoutez une marge inférieure entre le bouton "Supprimer le compte" et le bouton "Se déconnecter"
            SizedBox(height: 24),
            // Bouton "Se déconnecter"
            SizedBox(
              height: 48, // Hauteur personnalisée
              child: ElevatedButton(
                onPressed: () => _signOut(context),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF714DD8), // Couleur 714DD8
                  elevation: 0, // Supprimer l'ombre
                ),
                child: Text('Se déconnecter'),
              ),
            ),
            // Ajoutez une marge inférieure entre la carte "Partager l'application" et le bouton "Supprimer le compte"
            SizedBox(height: 12),
            // Bouton "Supprimer le compte"
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    String categoryName,
    List<String> items,
    List<IconData> icons,
    List<Widget?>?
        navigation, // Liste de pages à naviguer (ou null si pas de navigation)
    FontWeight fontWeight, // Poids de police pour le texte
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF002B5D), // Couleur de texte bleu
            ),
          ),
        ),
        ...List.generate(items.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFB8BBBE),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 12, right: 12),
              leading: Icon(
                icons[index],
                color: Color(0xFF002B5D),
              ),
              title: Text(
                items[index],
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF002B5D),
                ),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Color(0xFF714DD8),
              ),
              onTap: () {
                // Vérifiez s'il y a une page de navigation associée
                if (navigation != null && navigation[index] != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => navigation[index]!,
                    ),
                  );
                }
              },
            ),
          );
        }),
      ],
    );
  }
}
