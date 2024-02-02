import 'package:swafe/models/signalement/signalement_model.dart';

abstract class SignalementEvent {}

class CreateSignalementEvent extends SignalementEvent {
  SignalementCoordinates coordinates;
  List<SignalementDangerItemsEnum> selectedDangerItems;

  CreateSignalementEvent({
    required this.coordinates,
    required this.selectedDangerItems,
  });
}

class GetSignalementsEvent extends SignalementEvent {}

class GetSignalementEvent extends SignalementEvent {
  int id;

  GetSignalementEvent({required this.id});
}

class GetUsersSignalementsEvent extends SignalementEvent {}

class UpdateSignalementEvent extends SignalementEvent {
  int id;
  SignalementCoordinates? coordinates;
  List<SignalementDangerItemsEnum>? selectedDangerItems;

  UpdateSignalementEvent({
    required this.id,
    this.coordinates,
    this.selectedDangerItems,
  });
}

class DeleteSignalementEvent extends SignalementEvent {
  int id;

  DeleteSignalementEvent({required this.id});
}
