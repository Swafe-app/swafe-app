import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/DS/typographies.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double backButtonSize;
  final double backButtonMargin;

  const CustomAppBar({
    super.key,
    this.title,
    this.backButtonSize = 24.0,
    this.backButtonMargin = Spacing.small, // Utilisation de l'espacement small
  });

  @override
  Size get preferredSize => const Size.fromHeight(130.0); // Hauteur constante

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.standard), // Utilisation de l'espacement standard
      child: AppBar(
        automaticallyImplyLeading: false,
        // Désactive le bouton de retour par défaut
        backgroundColor: MyColors.defaultWhite,
        // Utilisation de la couleur defaultWhite
        elevation: 0,
        centerTitle: true,
        leading: Container(
          decoration: BoxDecoration(
            color:
                MyColors.defaultWhite, // Utilisation de la couleur secondary30
            borderRadius: BorderRadius.circular(8.0), // Coins arrondis de 8px
            border: Border.all(
              color: MyColors.primary10, // Couleur de la bordure en primary10
              width: 1.0, // Épaisseur de la bordure de 1 pixel
            ),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: MyColors.primary10, // Utilisation de la couleur primary10
              size: backButtonSize,
            ),
            padding: EdgeInsets.all(backButtonMargin),
            color:
                MyColors.defaultWhite, // Utilisation de la couleur defaultWhite
          ),
        ),
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  bottom:
                      Spacing.standard), // Utilisation de l'espacement standard
              child: Text(
                title ?? '',
                style: TitleLargeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
