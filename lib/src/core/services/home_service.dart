import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertest/src/core/interceptors/auth_interceptor.dart';

class HomeService {
  final AuthInterceptor _authInterceptor;

  HomeService(BuildContext context)
      : _authInterceptor = AuthInterceptor(context);

  Future<Dio> get _dio async => await _authInterceptor.dio;

// personal accounts
  Future<Response> getPersonalAccounts(int page) async {
    try {
      Dio dio = await _dio;
      Response response = await dio.get(
        '${dotenv.env['API_URL']}/multi_appartment/client/personal_account/',
        queryParameters: {'size': 20, 'page': page},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPersonalAccount(String accountId) async {
    try {
      Dio dio = await _dio;
      Response response = await dio.get(
        '${dotenv.env['API_URL']}/multi_appartment/client/personal_account/$accountId/',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

// journal logs
  Future<Response> getJournalLogs(int page) async {
    try {
      Dio dio = await _dio;
      Response response = await dio.get(
        '${dotenv.env['API_URL']}/control_room/application/',
        queryParameters: {'size': 20, 'page': page},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getJournalLog(String accountId) async {
    try {
      Dio dio = await _dio;
      Response response = await dio.get(
        '${dotenv.env['API_URL']}/control_room/application/$accountId/',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

// opu
  Future<Response> getOpus(int page) async {
    try {
      Dio dio = await _dio;
      Response response = await dio.get(
        '${dotenv.env['API_URL']}/multi_appartment/meter/opu/',
        queryParameters: {'size': 20, 'page': page},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getOpuDetail(String accountId) async {
    try {
      Dio dio = await _dio;
      Response response = await dio.get(
        '${dotenv.env['API_URL']}/multi_appartment/meter/opu/$accountId/',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  void handleError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
