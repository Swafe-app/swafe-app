import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../DS/typographies.dart';
import '../../components/Repertory/repertory.dart';
import '../../models/repertory_category.dart';
import '../../models/repertory_data.dart';

class RepertoireContent extends StatefulWidget {
  const RepertoireContent({super.key});

  @override
  State<RepertoireContent> createState() => _RepertoireContentState();
}

class _RepertoireContentState extends State<RepertoireContent> {
  final List<RepertoireCategory> _repertoireData = [
    RepertoireCategory(
      "Numéro en cas d’urgence - Par téléphone",
      [
        RepertoireCardData(
          "Police Secours - 17",
          "Pour signaler une infraction qui nécessite l’intervention immédiate des policiers.",
          "17",
        ),
        RepertoireCardData(
          "Sapeur-Pompiers - 18",
          "Pour signaler une situation de péril ou un accident concernant des biens ou des personnes et obtenir leur intervention rapide.",
          "18",
        ),
        RepertoireCardData(
          "Samu - 15",
          "Pour obtenir l’intervention d’une équipe médicale lors d’une situation de détresse vitale, ainsi que pour être redirigé vers un organisme de permanence de soin.",
          "15",
        ),
        RepertoireCardData(
          "Numéro d’urgence pour personne sourde et malentendante - 114",
          "Si vous êtes victime ou témoin d’une situation d’urgence qui nécessite l’intervention des services de secours. Numéro accessible par fax et SMS",
          "114",
        ),
        RepertoireCardData(
          "Numéro d’urgence européen - 112",
          "Si vous êtes victime ou témoin d’un accident dans un pays de l’Union Européenne.",
          "112",
        ),
        RepertoireCardData(
          "Sécurité RATP / SNCF - 3117",
          "Si vous êtes témoin d’une situation qui présente un risque pour votre sécurité ou celle des autres voyageurs.",
          "3117",
        ),
      ],
    ),
    RepertoireCategory(
      "Numéros en cas d’urgence - Par SMS",
      [
        RepertoireCardData(
          "Numéro d’urgence par SMS - 114",
          "Si vous êtes victime ou témoin d’une situation d’urgence qui nécessite l’intervention des services de secours.",
          "114",
        ),
        RepertoireCardData(
          "Sécurité RATP / SNCF - 31177",
          "Si vous êtes témoin d’une situation qui présente un risque pour votre sécurité ou celle des autres voyageurs.",
          "31177",
        ),
      ],
    ),
    RepertoireCategory(
      "Lignes d’aide",
      [
        RepertoireCardData(
          "Violences femmes info - 3919",
          "Si vous êtes victimes ou témoins de violences sexistes et sexuelles.",
          "3919",
        ),
        RepertoireCardData(
          "Numéro d'aide aux victimes - 116 006",
          "Écoute, informe et conseille les victimes d'infractions ainsi que leurs proches.",
          "116006",
        ),
        RepertoireCardData(
          "Allô enfance en danger - 119",
          "Pour signaler une situation d'un enfant en danger, prévention et à la protection des enfants en danger ou en risque de l’être.",
          "119",
        ),
        RepertoireCardData(
          "Non au harcèlement - 3020",
          "Pour signaler une situation d’harcèlement entre élèves.",
          "3020",
        ),
        RepertoireCardData(
          "Stop homophobie - 07 71 80 08 71",
          "Si vous êtes victimes ou témoins d’homophobie.",
          "0771800871",
        ),
        RepertoireCardData(
          "SOS homophobie - 01 48 06 42 41",
          "Si vous êtes victimes ou témoins d’homophobie, de biphobie et de transphobie.",
          "0148064241",
        ),
        RepertoireCardData(
          "SOS racisme - 01 40 35 36 55",
          "Si vous êtes victimes ou témoins de racisme (menaces, agressions, insultes, discriminations etc.).",
          "0140353655",
        ),
        RepertoireCardData(
          "Assistance aux sans domicile fixe (SDF) - 115",
          "Si vous êtes victime ou témoin d’une situation qui présente un risque pour votre sécurité.",
          "115",
        ),
        RepertoireCardData(
          "Alerte attentat – alerte enlèvement : 197",
          "Répondre à une alerte diffusée grâce à des  informations pouvant aider les enquêteurs.",
          "197",
        ),
      ],
    ),
  ];

  List<RepertoireCategory> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(_repertoireData);
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _repertoireData
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()) ||
              category.cards.any((card) =>
                  card.name.toLowerCase().contains(query.toLowerCase()) ||
                  card.description
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  card.phoneNumber.contains(query)))
          .toList();
    });
  }

  void _callNumber(String phoneNumber) async {
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    String url = "tel:$cleanedPhoneNumber";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (kDebugMode) {
        if (kDebugMode) {
          print("Impossible de lancer l'appel vers $cleanedPhoneNumber");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            color: MyColors.defaultWhite,
            child: const Text(
              "Numéros d'urgence",
              style: TextStyle(
                color: Color(0xFF021F40),
                fontSize: 20,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
                height: 0.07,
              ),
            ),
          ),
          const SizedBox(height: Spacing.extraLarge),
          Container(
            color: MyColors.defaultWhite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // Reduced padding to 0
            child: TextField(
              onChanged: _filterData,
              decoration: const InputDecoration(
                hintText: "Rechercher",
                suffixIcon: Icon(
                  Icons.search,
                  color: MyColors.primary10,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: MyColors.primary10,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: MyColors.neutral40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.extraLarge),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                RepertoireCategory category = _filteredData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index != 0) const SizedBox(height: 24),
                    // Add spacing if not the first category
                    Container(
                      color: const Color(0xFFECECEC),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            category.name,
                            style: const TextStyle(
                              color: Color(0xFF021F40),
                              fontSize: 14,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w500,
                              height: 0.10,
                              letterSpacing: 0.06,
                            ),
                          ),
                          const SizedBox(height: 8),
                          for (RepertoireCardData card in category.cards)
                            RepertoireCard(
                              cardData: card,
                              onCardTapped: _callNumber,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



