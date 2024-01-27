import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swafe/components/Button/button.dart';

class CheckingIdentity extends StatelessWidget {
  const CheckingIdentity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Text("Vérification d'identité"),
            Divider(thickness: 1.5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.access_time_outlined, size: 75),
                  Text(
                    "La vérification de votre pièce d'identité est en cours",
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Text(
                      "Merci d'avoir effectué cette étape importante. Si nous avons besoin de plus d'informations, nous vous le ferons savoir dès que possible."),
                  const SizedBox(height: 20),
                  Text(
                      "En attendant, vous pouvez reprendre là où vous en étiez."),
                ],
              ),
            ),
            const Spacer(),
            Divider(thickness: 1.5),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
