import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DS/colors.dart';
import '../../DS/typographies.dart';
import '../../models/repertory_data.dart';

class RepertoireCard extends StatelessWidget {
  final RepertoireCardData cardData;
  final Function(String) onCardTapped;
  final EdgeInsetsGeometry? margin;

  const RepertoireCard(
      {super.key,
        required this.cardData,
        required this.onCardTapped,
        this.margin});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardData.name,
              style: BodyXLargeMedium,
            ),
            const SizedBox(height: 4),
          ],
        ),
        subtitle: Text(cardData.description),
        trailing: IconButton(
          icon: const Icon(size: 32, Icons.phone_in_talk_outlined),
          color: MyColors.secondary40,
          onPressed: () {
            onCardTapped(cardData.phoneNumber);
          },
        ),
      ),
    );
  }
}