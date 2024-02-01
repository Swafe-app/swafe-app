import 'package:swafe/models/user/user_model.dart';

class UserTokenResponse {
  final UserModel user;
  final String token;

  UserTokenResponse({
    required this.user,
    required this.token,
  });

  factory UserTokenResponse.fromJson(Map<String, dynamic> json) {
    return UserTokenResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}
