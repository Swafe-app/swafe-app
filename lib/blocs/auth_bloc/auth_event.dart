abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneCountryCode;
  final String phoneNumber;

  SignUpEvent(this.email, this.password, this.firstName, this.lastName, this.phoneCountryCode, this.phoneNumber);
}

class UpdateEvent extends AuthEvent {
  final String token;
  final Map<String, dynamic> userData;

  UpdateEvent(this.token, this.userData);
}

class UploadSelfieEvent extends AuthEvent {
  final String token;
  final String selfie;

  UploadSelfieEvent(this.token, this.selfie);
}
