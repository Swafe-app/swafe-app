class SignalementModel {
  final double latitude;
  final double longitude;
  final List<String> selectedDangerItems;
  final String userId;

  SignalementModel({
    required this.latitude,
    required this.longitude,
    required this.selectedDangerItems,
    required this.userId,
  });
}
