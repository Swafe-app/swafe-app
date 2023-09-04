import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RepertoireContent extends StatefulWidget {
  const RepertoireContent({Key? key}) : super(key: key);

  @override
  State<RepertoireContent> createState() => _RepertoireContentState();
}

class _RepertoireContentState extends State<RepertoireContent> {
  List<RepertoireCategory> _repertoireData = [
    RepertoireCategory(
      "Catégorie Numéros d'Urgence",
      [
        RepertoireCardData(
          "Police - 17",
          "Pour signaler une infraction qui nécessite l’intervention immédiate des policiers.",
          "17",
        ),
        RepertoireCardData(
          "Pompiers - 18",
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
          "Si vous êtes témoin d’une situation qui présente un risque pour votre sécurité ou celle des autres voyageurs",
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
          "Si vous êtes victime ou temoin d’une situation qui présente un risque pour votre sécurité.",
          "115",
        ),
        RepertoireCardData(
          "Alerte attentat – alerte enlèvement : 197",
          "Répondre à une alerte diffusée grâce à des  informations pouvant aider les enquêteurs.",
          "197",
        ),
      ],
    ),
    // Ajoutez plus de catégories et de données de cartes ici
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
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    String url = "tel:$cleanedPhoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Impossible de lancer l'appel vers $cleanedPhoneNumber");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Répertoire',
          style: TextStyle(
            color: Color(0xFF002B5D),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor:
          Color(0xFFEDEDED), // Fond de couleur blanche pour le Scaffold
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterData,
              decoration: InputDecoration(
                hintText: "Rechercher",
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF002B5D),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(
                        0xFF002B5D), // Bordure bleue lorsque le champ est en focus
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(
                        0xFF71787E), // Bordure grise lorsque le champ n'est pas en focus
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                RepertoireCategory category = _filteredData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF002B5D), // Couleur de texte bleu
                        ),
                      ),
                    ),
                    for (RepertoireCardData card in category.cards)
                      RepertoireCard(
                        cardData: card,
                        onCardTapped: _callNumber,
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

class RepertoireCategory {
  final String name;
  final List<RepertoireCardData> cards;

  RepertoireCategory(this.name, this.cards);
}

class RepertoireCardData {
  final String name;
  final String description;
  final String phoneNumber;

  RepertoireCardData(this.name, this.description, this.phoneNumber);
}

class RepertoireCard extends StatelessWidget {
  final RepertoireCardData cardData;
  final Function(String) onCardTapped;

  RepertoireCard({required this.cardData, required this.onCardTapped});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          cardData.name,
          style: TextStyle(
            color: Color(0xFF002B5D), // Couleur de texte bleu
          ),
        ),
        subtitle:
            Text(cardData.description), // Afficher la description sous le nom
        trailing: IconButton(
          icon: Icon(Icons.phone),
          color: Color(0xFF714DD8), // Couleur de l'icône personnalisée
          onPressed: () {
            onCardTapped(cardData.phoneNumber);
          },
        ),
      ),
    );
  }
}
