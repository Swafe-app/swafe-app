
import 'package:flutter/material.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/IconButton/icon_button.dart';

class CheckingIdentity extends StatelessWidget {
  const CheckingIdentity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Text(
              "Vérification d'identité",
              style: TitleMediumMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1.5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.access_time_outlined, size: 50),
                  const SizedBox(height: 20),
                  Text(
                    "La vérification de votre pièce d'identité est en cours",
                    style:
                        TitleXLargeMedium.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),
                  Text(
                      "Merci d'avoir effectué cette étape importante. Si nous avons besoin de plus d'informations, nous vous le ferons savoir dès que possible.",
                      style: BodyLargeMedium),
                  SizedBox(height: 20),
                  Text(
                    "En attendant, vous pouvez reprendre là où vous en étiez.",
                    style: BodyLargeMedium,
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Divider(thickness: 1.5),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                  label: "Terminé",
                  onPressed: () => Navigator.pushNamed(context, "/welcome"),
                  type: ButtonType.outlined,
                  fillColor: Colors.black,
                  strokeColor: Colors.black,
                  textColor: Colors.white),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      Positioned(
      top: 60,
    left: 20,
    child: CustomIconButton(
    onPressed: () => Navigator.pop(context),
    type: IconButtonType.outlined,
    strokeColor: Colors.transparent,
    iconColor: Colors.black,
    icon: Icons.arrow_back_ios_new, size: IconButtonSize.M,)),
    ],
      ),
    );
  }
}
