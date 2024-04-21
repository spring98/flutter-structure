import 'package:dio/dio.dart';

class Session {
  static final Session _instance = Session._internal();
  factory Session() => _instance;

  static Dio _dio = Dio();
  Dio get dio => _dio;

  static const String _baseUrl = '';

  Session._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        sendTimeout: const Duration(milliseconds: 10000),
      ),
    );
  }
}
