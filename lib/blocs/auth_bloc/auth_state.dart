import 'package:swafe/models/user/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  Authenticated(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final UserModel user;

  RegisterSuccess(this.user);
}

class RegisterError extends AuthState {
  final String? message;

  RegisterError(this.message);
}