import 'package:swafe/models/user/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSelfieRedirect extends AuthState {}

class LoginSuccess extends AuthState {
  final UserModel user;

  LoginSuccess(this.user);
}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);
}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final UserModel user;

  RegisterSuccess(this.user);
}

class RegisterError extends AuthState {
  final String message;

  RegisterError(this.message);
}
