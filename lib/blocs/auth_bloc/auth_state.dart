import 'package:swafe/models/user/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

// Login states
class LoginLoading extends AuthState {}

class LoginEmailNotVerified extends AuthState {}

class LoginSelfieRedirect extends AuthState {}

class LoginSuccess extends AuthState {
  final UserModel user;

  LoginSuccess(this.user);
}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);
}

// Register states
class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterError extends AuthState {
  final String message;

  RegisterError(this.message);
}

// Upload selfie states
class UploadSelfieLoading extends AuthState {}

class UploadSelfieSuccess extends AuthState {}

class UploadSelfieError extends AuthState {
  final String message;

  UploadSelfieError(this.message);
}

// Verify token states
class VerifyTokenLoading extends AuthState {}

class VerifyTokenError extends AuthState {}

// Delete user states
class DeleteUserLoading extends AuthState {}

class DeleteUserSuccess extends AuthState {}

class DeleteUserError extends AuthState {
  final String message;

  DeleteUserError(this.message);
}
