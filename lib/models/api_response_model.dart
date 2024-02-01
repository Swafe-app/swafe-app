enum Status { success, error }

class ApiResponse<T> {
  final Status status;
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
      status: json['status'] == "success" ? Status.success : Status.error,
      message: json['message'],
      data: json.containsKey('data') ? fromJsonData(json['data']) : null,
      errors:json.containsKey('errors') ? List<String>.from(json['errors']) : null
    );
  }
}
