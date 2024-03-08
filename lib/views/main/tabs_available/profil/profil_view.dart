import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/views/main/tabs_available/profil/confirm_delete_modal_view.dart';
import 'package:swafe/views/main/tabs_available/profil/update_password/update_password_view.dart';
import 'package:swafe/views/main/tabs_available/profil/user_info/user_info_view.dart';

class ProfilContent extends StatelessWidget {
  const ProfilContent({super.key});

  void signOut(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
  }

  void deleteUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: const ConfirmDeleteModal(),
        );
      },
    );
  }

  Widget _buildCategory(
    BuildContext context,
    String categoryName,
    List<String> items,
    List<IconData> icons,
    List<Widget?>? navigation,
    List<bool>? disabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: TitleSmallMedium,
        ),
        const SizedBox(height: 12),
        ...List.generate(
          items.length,
          (index) {
            bool isDisabled = disabled != null && disabled[index];
            return Opacity(
              opacity: isDisabled ? 0.4 : 1.0,
              child: IgnorePointer(
                ignoring: isDisabled,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyColors.neutral70,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    horizontalTitleGap: 12,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: Icon(
                      icons[index],
                      color: MyColors.primary10,
                      size: 24,
                    ),
                    title: Text(
                      items[index],
                      style: BodyLargeMedium,
                    ),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                      color: MyColors.secondary40,
                      size: 24,
                    ),
                    onTap: isDisabled
                        ? null
                        : () {
                            // Vérifiez s'il y a une page de navigation associée
                            if (navigation != null &&
                                navigation[index] != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => navigation[index]!,
                                ),
                              );
                            }
                          },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              // Catégorie "Paramètres"
              _buildCategory(context, 'Paramètres', [
                'Information personnelle',
                'Mot de passe',
                'Notifications',
                'Mentions légales',
              ], [
                Icons.person_outline,
                Icons.lock_outline,
                Icons.notifications_active_outlined,
                Icons.gavel_outlined,
              ], [
                const UserProfileScreen(),
                const UpdatePasswordView(),
                null,
                null,
              ], [
                false,
                false,
                true,
                true
              ]),
              // Catégorie "Nous contacter"
              _buildCategory(context, 'Nous contacter', [
                'FAQ / Aide',
              ], [
                Icons.help_outline,
              ], [
                null,
              ], [
                true
              ]),
              // Catégorie "Soutenir l'app"
              _buildCategory(context, 'Soutenir l\'app', [
                'Partager l\'application',
                'Noter l\'application',
                'Faire un don',
              ], [
                Icons.ios_share_outlined,
                Icons.star_outline,
                Icons.handshake_outlined,
              ], [
                null,
                null,
                null,
              ], [
                true,
                true,
                true,
              ]),
              const SizedBox(height: 24),
              SizedBox(
                child: CustomButton(
                  label: "Se déconnecter",
                  onPressed: () => signOut(context),
                ),
              ),
              const SizedBox(height: 24),
              Image.asset('assets/images/Swafe_Logo.png',
                  width: 40, height: 40),
              const SizedBox(height: 8),
              Text(
                'Version 1.1.0',
                style: BodyLargeMedium.copyWith(color: MyColors.neutral70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                child: CustomButton(
                  type: ButtonType.outlined,
                  label: "Supprimer le compte",
                  onPressed: () => deleteUser(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
