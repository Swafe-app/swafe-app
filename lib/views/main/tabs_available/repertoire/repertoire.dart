import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../components/Repertory/repertory.dart';
import '../../../../models/repertory_category.dart';
import '../../../../models/repertory_data.dart';
import 'package:permission_handler/permission_handler.dart';

class RepertoireContent extends StatefulWidget {
  const RepertoireContent({super.key});

  @override
  State<RepertoireContent> createState() => RepertoireContentState();
}

class RepertoireContentState extends State<RepertoireContent> {
  final List<RepertoireCategory> repertoireData = [
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
  List<RepertoireCategory> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = repertoireData;
  }

  void _filterData(String query) {
    setState(() {
      filteredData = repertoireData
          .map((category) => RepertoireCategory(
                category.name,
                category.cards
                    .where((card) => card.name.toLowerCase().contains(query.toLowerCase()))
                    .toList(),
              ))
          .where((category) => category.cards.isNotEmpty)
          .toList();
    });
  }

  void callNumber(String phoneNumber) async {
    await requestPhonePermission();
    Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> requestPhonePermission() async {
    PermissionStatus status = await Permission.phone.status;

    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.phone.request();
      if (!newStatus.isGranted) {
        if (kDebugMode) {
          print('Phone permission was denied');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenSize.height),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              color: MyColors.defaultWhite,
              child: Text(
                "Numéros d'urgence",
                style: TitleLargeMedium,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: CustomTextField(
                  placeholder: 'Rechercher',
                  onChanged: _filterData,
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var category in filteredData)
                      Container(
                        color: MyColors.neutral80,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                category.name,
                                style: SubtitleLargeMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (RepertoireCardData card in category.cards)
                              Column(
                                children: [
                                  RepertoireCard(
                                    cardData: card,
                                    onCardTapped: callNumber,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 112),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
