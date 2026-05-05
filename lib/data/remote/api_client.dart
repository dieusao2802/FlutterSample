import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options
      ..baseUrl = 'https://api.example.com'
      ..connectTimeout = const Duration(seconds: 5);
  }

  Future<Response> get(String path) => _dio.get(path);

  Future<Response> post(String path, dynamic data) => _dio.post(path, data: data);
}