import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/views/main/tabs_available/profil/confirm_delete_modal_view.dart';
import 'package:swafe/views/main/tabs_available/profil/update_password/update_password_view.dart';
import 'package:swafe/views/main/tabs_available/profil/user_info/user_info_view.dart';
import 'package:url_launcher/url_launcher.dart';

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
    List<VoidCallback?>? navigation,
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
                              navigation[index]!();
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
                'Mentions légales',
              ], [
                Icons.person_outline,
                Icons.lock_outline,
                Icons.notifications_active_outlined,
                Icons.gavel_outlined,
              ], [
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserProfileScreen(),
                    ),
                  );
                },
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UpdatePasswordView(),
                    ),
                  );
                },
                () async {
                  String url =
                      "https://www.privacypolicies.com/live/acd686f6-2e03-4928-b9e1-292e868a2713";
                  Uri uri = Uri.parse(url);
                  await launchUrl(uri);
                },
              ], [
                false,
                false,
                false
              ]),
              // Catégorie "Soutenir l'app"
              _buildCategory(context, 'Soutenir l\'app', [
                'Partager l\'application',
                'Noter l\'application',
              ], [
                Icons.ios_share_outlined,
                Icons.star_outline,
              ], [
                () {
                  Share.share(
                    'Invitez vos amis à télécharger Swafe !${Platform.isAndroid ? 'https://play.google.com/store/apps/details?id=com.owl.swafe' : 'https://apps.apple.com/us/app/swafe/6476942292'}',
                  );
                },
                () async {
                  final InAppReview inAppReview = InAppReview.instance;

                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  } else {
                    if (Platform.isAndroid) {
                      await launchUrl(
                        'https://play.google.com/store/apps/details?id=com.owl.swafe'
                            as Uri,
                      );
                    } else {
                      await launchUrl(
                        'https://apps.apple.com/us/app/swafe/6476942292' as Uri,
                      );
                    }
                  }
                },
              ], [
                false,
                false,
              ]),
              const SizedBox(height: 24),
              SizedBox(
                child: CustomButton(
                  label: "Se déconnecter",
                  onPressed: () => signOut(context),
                ),
              ),
              const SizedBox(height: 24),
              SvgPicture.asset('assets/images/Swafe_Logo.svg',
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
