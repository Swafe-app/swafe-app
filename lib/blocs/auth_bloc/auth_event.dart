import 'dart:io';

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
  final String? phoneCountryCode;
  final String? phoneNumber;

  SignUpEvent(
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.phoneCountryCode,
    this.phoneNumber,
  );
}

class UploadSelfieEvent extends AuthEvent {
  final File file;

  UploadSelfieEvent(this.file);
}

class VerifyTokenEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class DeleteUserEvent extends AuthEvent {}

class UpdateUserEvent extends AuthEvent {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? phoneCountryCode;

  UpdateUserEvent({
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.phoneCountryCode,
  });
}

class UpdatePasswordEvent extends AuthEvent {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordEvent(this.oldPassword, this.newPassword);
}
