import 'package:swafe/models/user/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

// Login states
class LoginLoading extends AuthState {}

class LoginEmailNotVerified extends AuthState {}

class LoginSelfieRedirect extends AuthState {}

class LoginSuccess extends AuthState {}

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

class VerifyTokenSuccess extends AuthState {}

class VerifyTokenError extends AuthState {}

// Delete user states
class DeleteUserLoading extends AuthState {}

class DeleteUserSuccess extends AuthState {}

class DeleteUserError extends AuthState {
  final String message;

  DeleteUserError(this.message);
}

// Update user states
class UpdateUserLoading extends AuthState {}

class UpdateUserSuccess extends AuthState {}

class UpdateUserError extends AuthState {
  final String message;

  UpdateUserError(this.message);
}

// Update password states
class UpdatePasswordLoading extends AuthState {}

class UpdatePasswordSuccess extends AuthState {}

class UpdatePasswordError extends AuthState {
  final String message;

  UpdatePasswordError(this.message);
}
