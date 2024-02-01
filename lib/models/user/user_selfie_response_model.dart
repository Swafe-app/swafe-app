import 'package:swafe/models/user/user_model.dart';

class SelfieUserResponse {
  final String fileName;

  SelfieUserResponse({
    required this.fileName,
  });

  factory SelfieUserResponse.fromJson(Map<String, dynamic> json) {
    return SelfieUserResponse(
      fileName: json['fileName'],
    );
  }
}
