import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertest/src/core/services/auth_service.dart';

class AuthInterceptor {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();
  final BuildContext context;

  AuthInterceptor(this.context) {
    _dio = Dio();
  }

  Future<Dio> get dio async {
    await _initializeInterceptors();
    return _dio;
  }

  Future<void> _initializeInterceptors() async {
    final interceptor = await _createInterceptor();
    _dio.interceptors.add(interceptor);
  }

  Future<Interceptor> _createInterceptor() async {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final String? accessToken = await _storage.read(key: 'access');
        final String? refreshToken = await _storage.read(key: 'refresh');
        final String? cityToken = await _storage.read(key: 'city_token');

        options.headers.addAll({
          // 'Authorization': 'Bearer $accessToken',
          // 'Refresh-Token': refreshToken,
          'City-Token': cityToken,
        });

        handler.next(options);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        debugPrint('Error: ${error.response.toString()}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${error.response?.statusMessage.toString()}')),
        );

        if (error.response?.statusCode == 401) {
          _authService.logout(context);
        }

        return handler.next(error);
      },
    );
  }
}
