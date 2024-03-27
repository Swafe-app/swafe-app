import 'package:swafe/models/user/user_model.dart';

class CreateUserResponse {
  final UserModel user;
  final String token;

  CreateUserResponse({
    required this.user,
    required this.token,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}
