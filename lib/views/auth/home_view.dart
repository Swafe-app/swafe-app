import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/views/auth/login/login_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Show the login bottom sheet
  void _showLoginBottomSheet(BuildContext context) {
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
          child: const LoginBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/gradient.png',
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 80),
            child: Column(
              children: [
                const CustomAppBar(showIconButton: false),
                const SizedBox(height: 72),
                Text(
                  "Il n’a jamais été aussi\nsimple d’aller d'un point A\nà un point B en toute\nsécurité",
                  style:
                      TitleXLargeMedium.copyWith(color: MyColors.defaultWhite),
                  textAlign: TextAlign.left,
                ),
                const Spacer(),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _showLoginBottomSheet(context);
                      },
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "Tu as déjà un compte ? ",
                              style: BodyXLargeRegular.copyWith(
                                  color: MyColors.defaultWhite)),
                          TextSpan(
                              text: "Se connecter",
                              style: BodyXLargeMedium.copyWith(
                                  color: MyColors.defaultWhite))
                        ]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      label: "S'inscrire",
                      fillColor: MyColors.defaultWhite,
                      textColor: MyColors.primary10,
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
