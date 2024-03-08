import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';

class ConfirmDeleteModal extends StatelessWidget {
  const ConfirmDeleteModal({super.key});

  void confirmDelete(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(DeleteUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is DeleteUserSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                label: "Votre compte a bien été supprimé.",
              ),
            ),
          );
        }
        if (state is DeleteUserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                isError: true,
                label: "Une erreur s'est produite, veuillez réessayer.",
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barre visuel pour le BottomSheet
            Container(
              width: 160,
              height: 8,
              decoration: BoxDecoration(
                color: MyColors.neutral70,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Text(
                "Confirmer la Suppression du Compte",
                style: TitleLargeMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Êtes-vous sûr de vouloir supprimer définitivement votre compte ?",
              style: SubtitleLargeRegular,
            ),
            const SizedBox(height: 8),
            Text(
              "Cette action est irréversible et entraînera la perte de toutes vos données, y compris vos paramètres de compte, historique et informations personnelles.",
              style: SubtitleLargeRegular,
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text:
                      "Si vous êtes certain de vouloir procéder, veuillez confirmer votre choix",
                  style: SubtitleLargeRegular,
                ),
                TextSpan(
                  text: " ci-dessous.",
                  style: BodyLargeRegular.copyWith(color: MyColors.secondary40),
                ),
              ]),
            ),
            const SizedBox(height: 60),
            CustomButton(
              label: 'Supprimer mon compte',
              onPressed: () => confirmDelete(context),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  "Annuler",
                  style: BodyLargeMedium.copyWith(color: MyColors.secondary40),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
