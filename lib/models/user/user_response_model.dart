import 'package:swafe/models/user/user_model.dart';

class UserResponse {
  final UserModel user;

  UserResponse({
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user: UserModel.fromJson(json['user']),
    );
  }
}
