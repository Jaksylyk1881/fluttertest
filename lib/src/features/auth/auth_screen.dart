import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/user_data.dart';
import 'package:fluttertest/src/core/router/router.dart';

import 'package:fluttertest/src/core/models/utils/extensions/num_extensions.dart';
import 'package:fluttertest/src/core/services/auth_service.dart';
import 'package:fluttertest/src/core/widgets/custom_button.dart';
import 'package:fluttertest/src/core/widgets/custom_input.dart';
import 'package:fluttertest/src/features/auth/widgets/auth_header.dart';
import 'package:fluttertest/src/core/models/utils/validator.dart';

@RoutePage()
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final AuthService _authService = AuthService();
  bool isLoading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String username = _loginController.text;
    final String password = _passwordController.text;

    FocusScope.of(context).unfocus();

    try {
      setState(() {
        isLoading = true;
      });

      final userData = UserData(username: username, password: password);

      await _authService.login(context, userData);
    } catch (e) {
      debugPrint('Error during login: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const AuthHeader(),
          Expanded(
            child: Padding(
              padding: 16.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).welcome,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            8.h,
                            Text(S.of(context).please_enter_your_details),
                          ],
                        ),
                      ),
                      32.h,
                      CustomInput(
                        labelText: S.of(context).login,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _loginController,
                        focusNode: _loginFocusNode,
                        validator: NameValidator().call,
                      ),
                      16.h,
                      CustomInput(
                        labelText: S.of(context).password,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        validator: PasswordValidator().call,
                      ),
                    ]),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        AutoRouter.of(context)
                            .push(const PasswordRecoveryRoute());
                      },
                      child: Text(
                        S.of(context).forget_password,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      if (isLoading)
                        const CircularProgressIndicator(
                          backgroundColor: Color(0xFFD4E4F6),
                        ),
                      32.h,
                      CustomButton(
                        // isDisabled: isLoading ||
                        //     !(_formKey.currentState?.validate() ?? false),
                        text: 'Войти',
                        onPressed: () {
                          if ((_formKey.currentState?.validate() ?? false) ==
                              true) {
                            _login();
                          }
                        },
                      ),
                      32.h,
                      const Text(
                        'v 2.27\n ac75ed5169d1f91a',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
