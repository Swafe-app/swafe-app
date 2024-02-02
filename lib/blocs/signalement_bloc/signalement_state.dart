abstract class SignalementState {}

class SignalementInitial extends SignalementState {}

// Create signalement states
class CreateSignalementLoading extends SignalementState {}

class CreateSignalementSuccess extends SignalementState {}

class CreateSignalementError extends SignalementState {
  final String message;

  CreateSignalementError(this.message);
}

// Get signalements states
class GetSignalementsLoading extends SignalementState {}

class GetSignalementsSuccess extends SignalementState {}

class GetSignalementsError extends SignalementState {
  final String message;

  GetSignalementsError(this.message);
}

// Get signalement states
class GetSignalementLoading extends SignalementState {}

class GetSignalementSuccess extends SignalementState {}

class GetSignalementError extends SignalementState {
  final String message;

  GetSignalementError(this.message);
}

// Get users signalements states
class GetUsersSignalementsLoading extends SignalementState {}

class GetUsersSignalementsSuccess extends SignalementState {}

class GetUsersSignalementsError extends SignalementState {
  final String message;

  GetUsersSignalementsError(this.message);
}

// Update signalement states
class UpdateSignalementLoading extends SignalementState {}

class UpdateSignalementSuccess extends SignalementState {}

class UpdateSignalementError extends SignalementState {
  final String message;

  UpdateSignalementError(this.message);
}

// Delete signalement states
class DeleteSignalementLoading extends SignalementState {}

class DeleteSignalementSuccess extends SignalementState {}

class DeleteSignalementError extends SignalementState {
  final String message;

  DeleteSignalementError(this.message);
}
