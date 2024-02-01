import 'package:flutter/material.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';

class CheckingIdentity extends StatelessWidget {
  const CheckingIdentity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomAppBar(),
            ),
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
                    style: TitleXLargeMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Merci d'avoir effectué cette étape importante. Si nous avons besoin de plus d'informations, nous vous le ferons savoir dès que possible.",
                    style: BodyLargeMedium,
                  ),
                  const SizedBox(height: 20),
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
                  onPressed: () => Navigator.pushNamed(context, "/home"),
                  type: ButtonType.outlined,
                  fillColor: Colors.black,
                  strokeColor: Colors.black,
                  textColor: Colors.white),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
