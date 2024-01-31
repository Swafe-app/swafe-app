import 'package:swafe/models/user/user_model.dart';

class LoginUserResponse {
  final UserModel user;
  final String token;

  LoginUserResponse({
    required this.user,
    required this.token,
  });

  factory LoginUserResponse.fromJson(Map<String, dynamic> json) {
    return LoginUserResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}
