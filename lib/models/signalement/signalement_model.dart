class SignalementCoordinates {
  final double latitude;
  final double longitude;

  SignalementCoordinates({required this.latitude, required this.longitude});

  factory SignalementCoordinates.fromJson(Map<String, dynamic> json) {
    return SignalementCoordinates(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

enum SignalementDangerItemsEnum {
  autre, // 'Autre'
  vol, // 'Vol'
  harcelement, // 'Harcèlement'
  agressionSexuelle, // 'Agression sexuelle'
  agressionPhysique, // 'Agression physique'
  agressionVerbale, // 'Agression verbale'
  jeMeFaisSuivre, // 'Je me fais suivre'
  incendie, // 'Incendie'
  meteo, // 'Météo'
  travaux, // 'Travaux'
  manqueAccessibilite, // 'Manque d\'accessibilité'
  voiture, // 'Accident de voiture'
  inondation, // 'Inondation'
  trouSurLaChaussee, // 'Trou sur la chaussée'
  obstacleSurLaChaussee, // 'Obstacle sur la chaussée'
  personneIvre, // 'Personne ivre'
  conduiteDangereuse, // 'Conduite dangereuse'
  feuDePietonDysfonctionnel, // 'Feu de piéton dysfonctionnel'
  mauvaisEclairage, // 'Mauvais éclairage'
}

String signalementDangerItemEnumToString(SignalementDangerItemsEnum item) {
  switch (item) {
    case SignalementDangerItemsEnum.autre:
      return 'Autre';
    case SignalementDangerItemsEnum.vol:
      return 'Vol';
    case SignalementDangerItemsEnum.harcelement:
      return 'Harcèlement';
    case SignalementDangerItemsEnum.agressionSexuelle:
      return 'Agression sexuelle';
    case SignalementDangerItemsEnum.agressionPhysique:
      return 'Agression physique';
    case SignalementDangerItemsEnum.agressionVerbale:
      return 'Agression verbale';
    case SignalementDangerItemsEnum.jeMeFaisSuivre:
      return 'Je me fais suivre';
    case SignalementDangerItemsEnum.incendie:
      return 'Incendie';
    case SignalementDangerItemsEnum.meteo:
      return 'Météo';
    case SignalementDangerItemsEnum.travaux:
      return 'Travaux';
    case SignalementDangerItemsEnum.manqueAccessibilite:
      return 'Manque d\'accessibilité';
    case SignalementDangerItemsEnum.voiture:
      return 'Voiture';
    case SignalementDangerItemsEnum.inondation:
      return 'Inondation';
    case SignalementDangerItemsEnum.trouSurLaChaussee:
      return 'Trou sur la chaussée';
    case SignalementDangerItemsEnum.obstacleSurLaChaussee:
      return 'Obstacle sur la chaussée';
    case SignalementDangerItemsEnum.personneIvre:
      return 'Personne ivre';
    case SignalementDangerItemsEnum.conduiteDangereuse:
      return 'Conduite dangereuse';
    case SignalementDangerItemsEnum.feuDePietonDysfonctionnel:
      return 'Feu de piéton dysfonctionnel';
    case SignalementDangerItemsEnum.mauvaisEclairage:
      return 'Mauvais éclairage';
  }
}

SignalementDangerItemsEnum stringToSignalementDangerItemEnum(String item) {
  switch (item) {
    case 'Vol':
      return SignalementDangerItemsEnum.vol;
    case 'Harcèlement':
      return SignalementDangerItemsEnum.harcelement;
    case 'Agression sexuelle':
      return SignalementDangerItemsEnum.agressionSexuelle;
    case 'Agression physique':
      return SignalementDangerItemsEnum.agressionPhysique;
    case 'Agression verbale':
      return SignalementDangerItemsEnum.agressionVerbale;
    case 'Je me fais suivre':
      return SignalementDangerItemsEnum.jeMeFaisSuivre;
    case 'Incendie':
      return SignalementDangerItemsEnum.incendie;
    case 'Météo':
      return SignalementDangerItemsEnum.meteo;
    case 'Travaux':
      return SignalementDangerItemsEnum.travaux;
    case 'Manque d\'accessibilité':
      return SignalementDangerItemsEnum.manqueAccessibilite;
    case 'Voiture':
      return SignalementDangerItemsEnum.voiture;
    case 'Inondation':
      return SignalementDangerItemsEnum.inondation;
    case 'Trou sur la chaussée':
      return SignalementDangerItemsEnum.trouSurLaChaussee;
    case 'Obstacle sur la chaussée':
      return SignalementDangerItemsEnum.obstacleSurLaChaussee;
    case 'Personne ivre':
      return SignalementDangerItemsEnum.personneIvre;
    case 'Conduite dangereuse':
      return SignalementDangerItemsEnum.conduiteDangereuse;
    case 'Feu de piéton dysfonctionnel':
      return SignalementDangerItemsEnum.feuDePietonDysfonctionnel;
    case 'Mauvais éclairage':
      return SignalementDangerItemsEnum.mauvaisEclairage;
    default:
      throw SignalementDangerItemsEnum.autre;
  }
}

class SignalementModel {
  final int id;
  final String userId;
  final SignalementCoordinates coordinates;
  final List<SignalementDangerItemsEnum> selectedDangerItems;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SignalementModel({
    required this.id,
    required this.userId,
    required this.coordinates,
    required this.selectedDangerItems,
    this.createdAt,
    this.updatedAt,
  });

  factory SignalementModel.fromJson(Map<String, dynamic> json) {
    var itemsJson = List<String>.from(json['selectedDangerItems']);
    var items = itemsJson
        .map((item) => stringToSignalementDangerItemEnum(item))
        .toList();

    return SignalementModel(
      id: json['id'],
      userId: json['userId'],
      coordinates: SignalementCoordinates.fromJson(json['coordinates']),
      selectedDangerItems: items,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude
      },
      'selectedDangerItems': selectedDangerItems
          .map((item) => signalementDangerItemEnumToString(item))
          .toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
