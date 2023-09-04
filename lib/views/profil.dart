import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swafe/views/profil/ModifierInformationPersonnelle.dart';
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
      body: ListView(
        children: [
          // Photo de profil
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'URL_DE_LA_PHOTO_DE_PROFIL'), // Remplacez par l'URL de la photo de profil de l'utilisateur
            ),
          ),
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
            [ModifierInformationPersonnelle(), null, null, null],
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
          ),
          // Bouton "Se déconnecter"
          ElevatedButton(
            onPressed: () => _signOut(context),
            child: Text('Se déconnecter'),
          ),
          // Bouton "Supprimer le compte"
          ElevatedButton(
            onPressed: () {
              // Action à effectuer lors du clic sur "Supprimer le compte"
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text('Supprimer le compte'),
          ),
        ],
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
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(items.length, (index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(icons[index]),
              title: Text(items[index]),
              trailing: Icon(Icons.keyboard_arrow_right),
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
