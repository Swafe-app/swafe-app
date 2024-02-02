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
  jeMeFaisSuivre, // 'Je me fais suivre'
}

String signalementDangerItemEnumToString(SignalementDangerItemsEnum item) {
  return item.toString().split('.').last;
}

SignalementDangerItemsEnum stringToSignalementDangerItemEnum(String item) {
  return SignalementDangerItemsEnum.values.firstWhere(
      (e) => e.toString().split('.').last == item,
      orElse: () => SignalementDangerItemsEnum.autre);
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
