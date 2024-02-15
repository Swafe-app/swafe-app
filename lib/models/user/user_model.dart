class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneCountryCode;
  final String? phoneNumber;
  final bool emailVerified;
  final bool phoneVerified;
  final String role;
  final String? selfie;
  final String selfieStatus;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneCountryCode,
    this.phoneNumber,
    required this.emailVerified,
    required this.phoneVerified,
    required this.role,
    this.selfie,
    required this.selfieStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneCountryCode: json['phoneCountryCode'],
      phoneNumber: json['phoneNumber'],
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      role: json['role'] ?? 'user',
      selfie: json['selfie'],
      selfieStatus: json['selfieStatus'] ?? 'not_defined',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneCountryCode': phoneCountryCode,
      'phoneNumber': phoneNumber,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'role': role,
      'selfie': selfie,
      'selfieStatus': selfieStatus,
    };
  }
}
