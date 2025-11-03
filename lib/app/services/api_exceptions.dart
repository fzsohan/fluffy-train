import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String url;
  final String message;
  final int? statusCode;
  final Response? response;

  ApiException({
    required this.url,
    required this.message,
    this.response,
    this.statusCode,
  });

  /// IMPORTANT NOTE
  /// here you can take advantage of toString() method to display the error for user
  /// lets make an example
  /// so in onError method when you make api you can just user apiExceptionInstance.toString() to get the error message from api
  @override
  toString() {
    try {
      if (response != null && response!.data != null) {
        final dynamic data = response!.data;

        if (data is Map<String, dynamic>) {
          return data['message'] ?? message;
        } else if (data is String) {
          // Sometimes API might send a raw string message
          return data;
        }
      }
      return message;
    } catch (e) {
      return message;
    }
  }
}
