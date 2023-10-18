import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/views/MainView/MainViewContent/profil/ModifierInformationPersonnelle.dart';
import 'package:swafe/views/MainView/MainViewContent/profil/ModifierMotdepasse.dart';
import 'package:swafe/views/MainView/MainViewContent/profil/ReauthenticationPage.dart';
import 'package:swafe/views/LoginRegister/welcome_view.dart';
import 'package:swafe/ds/spacing.dart';
import 'package:swafe/ds/typographies.dart';

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
          style: typographyList
              .firstWhere((info) => info.name == 'Title Large Medium')
              .style
              .copyWith(
                color: MyColors.primary10,
              ),
        ),
        backgroundColor: MyColors.defaultWhite,
        elevation: 0,
      ),
      backgroundColor: MyColors.defaultWhite,
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
                null,
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
            SizedBox(
                height:
                    Spacing.extraLarge), // Utilisation de l'espacement "small"
            // Bouton "Se déconnecter"
            SizedBox(
              height: 48, // Hauteur personnalisée
              child: CustomButton(
                label: "Se déconnecter",
                type: ButtonType.filled,
                fillColor:
                    MyColors.secondary40, // Set to the desired fill color
                textColor:
                    MyColors.defaultWhite, // Set to the desired text color
                onPressed: () => _signOut(context),
                isLoading: false,
                isDisabled: false,
              ),
            ),
            // Ajoutez une marge inférieure entre la carte "Partager l'application" et le bouton "Supprimer le compte"
            SizedBox(
                height:
                    Spacing.extraLarge), // Utilisation de l'espacement "medium"
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
            style: typographyList
                .firstWhere((info) => info.name == 'Title Small Medium')
                .style
                .copyWith(
                  color: MyColors.primary10, // Couleur de texte bleu
                ),
          ),
        ),
        ...List.generate(items.length, (index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: MyColors.neutral70,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 12, right: 12),
              leading: Icon(
                icons[index],
                color: MyColors.primary10,
              ),
              title: Text(
                items[index],
                style: typographyList
                    .firstWhere((info) => info.name == 'Body Large Medium')
                    .style
                    .copyWith(
                      color: MyColors.primary10,
                    ),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: MyColors.secondary40,
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
