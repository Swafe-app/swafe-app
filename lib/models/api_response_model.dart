class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final List<String>? errors;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function fromJsonData) {
    return ApiResponse<T>(
      status: json['status'],
      message: json['message'],
      data: json.containsKey('data') ? fromJsonData(json['data']) : null,
      errors: json['errors']?.cast<String>(),
    );
  }
}
