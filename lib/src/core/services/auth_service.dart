import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/user_data.dart';
import 'package:fluttertest/src/core/router/router.dart';
import 'package:fluttertest/src/core/services/message_service.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final MessageService _messageService = MessageService();

  Future<bool> isAuthenticated() async {
    final String? accessToken = await _storage.read(key: 'city_token');
    final String? refreshToken = await _storage.read(key: 'city_token_refresh');

    return accessToken != null && refreshToken != null;
  }

  void _showCitySelectionDialog(BuildContext context,
      List<Map<String, dynamic>> cityUsers, UserData userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).choose_city),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cityUsers.length,
              itemBuilder: (context, index) {
                final cityUser = cityUsers[index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    // boxShadow: const [
                    //   BoxShadow(
                    //     color: Colors.black12,
                    //     blurRadius: 4.0,
                    //     offset: Offset(0, 2),
                    //   ),
                    // ],
                  ),
                  child: ListTile(
                    title: Text(cityUser['city']['name']),
                    subtitle: Text('City ID: ${cityUser['city']['id']}'),
                    onTap: () {
                      _selectedCity(context, cityUser['city']['id'], userData);
                    },
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                logout(context);
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).close),
            ),
          ],
        );
      },
    );
  }

  Future recoveryRequest(BuildContext context, String username) async {
    final response = null;

    Dio().patch(
      '${dotenv.env['API_URL']}/user/forgot_password/?username=$username',
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Инструкции по восстановлению пароля отправлены на ваш email')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при восстановлении пароля')),
      );
    }
  }

  String _handleError(String responseBody) {
    final Map<String, String> errorMessages = {
      '"invalid_username"': 'Неправильное имя пользователя',
      '{"password":["This field may not be blank."]}':
          'Пароль не может быть пустым',
      '{"detail":"password_incorrect"}': 'Неправильный пароль',
      '{detail: No such user}': 'Неправильное имя пользователя',
    };

    return errorMessages[responseBody] ?? 'Ошибка авторизации';
  }

  Future<void> _selectedCity(
      BuildContext context, String city, UserData userData) async {
    try {
      final response = await Dio().post(
        '${dotenv.env['API_URL']}/auth/city_token/',
        data: {
          'username': userData.username,
          'password': userData.password,
          'city_id': city,
          'is_remember': true
        },
      );

      if (response.statusCode == 200) {
        final accessCityToken = response.data['access'];
        final refreshCityToken = response.data['refresh'];
        await _storage.write(key: 'city_token', value: accessCityToken);
        await _storage.write(
            key: 'city_token_refresh', value: refreshCityToken);

        AutoRouter.of(context).push(const MainRoute());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_handleError(response.data.body))),
        );
        debugPrint(
            'Failed to select city. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception during city selection: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _storage.delete(key: 'city_token');
      await _storage.delete(key: 'city_token_refresh');

      AutoRouter.of(context).push(const AuthRoute());
    } catch (e) {
      debugPrint('Error logging out: $e');
      AutoRouter.of(context).push(const AuthRoute());
    }
  }

  Future<void> login(BuildContext context, UserData userData) async {
    try {
      final response = await Dio().post(
        '${dotenv.env['API_URL']}/auth/get_user_cities/',
        data: {'username': userData.username, 'password': userData.password},
      );

      if (response.statusCode == 200) {
        _showCitySelectionDialog(
            context,
            List<Map<String, dynamic>>.from(response.data['city_user']),
            userData);
      } else {
        debugPrint('Error during login: ${response.data}');
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response != null) {
          final responseData = error.response?.data;
          debugPrint('Error logging in: $responseData');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(_handleError(responseData.toString()))),
          // );
          _messageService.showMessage(
            context: context,
            message: _handleError(responseData.toString()),
            isError: true,
          );
        } else {
          debugPrint('Error logging in: ${error.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      } else {
        debugPrint('Unexpected error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error occurred')),
        );
      }
    }
  }
}
