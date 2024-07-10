import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/router/router.dart';

import 'package:fluttertest/src/core/models/utils/validator.dart';
import 'package:fluttertest/src/core/services/auth_service.dart';
import 'package:fluttertest/src/core/models/utils/extensions/num_extensions.dart';
import 'package:fluttertest/src/core/widgets/custom_button.dart';
import 'package:fluttertest/src/core/widgets/custom_input.dart';
import 'package:fluttertest/src/features/auth/widgets/auth_header.dart';

@RoutePage()
class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecoveryScreen> {
  final TextEditingController _loginController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _loginFocusNode = FocusNode();
  final AuthService _authService = AuthService();

  bool _isFormValid = false;
  // final int _number = 3;

  @override
  void dispose() {
    _loginFocusNode.dispose();
    _loginController.dispose();
    super.dispose();
  }

  Future<void> recoveryRequest() async {
    await _authService.recoveryRequest(context, _loginController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        // child: Column(
        children: [
          const AuthHeader(),
          Expanded(
            child: Padding(
              padding: 16.p,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Восстановление пароля',
                      // S.of(context).testing_value_in_local(_number),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                    8.h,
                    const Text(
                        'Введите логин вашего аккаунта для получения письма с новым паролем.'),
                    32.h,
                    CustomInput(
                      labelText: 'Логин',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _loginController,
                      focusNode: _loginFocusNode,
                      validator: NameValidator().call,
                    ),
                    // 24.h,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          AutoRouter.of(context).push(const AuthRoute());
                        },
                        child: Text(
                          S.of(context).go_back_auth,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        CustomButton(
                          text: S.of(context).recover_password,
                          onPressed: _isFormValid ? recoveryRequest : null,
                        ),
                        32.h,
                        Text(
                          'v 2.27\n ac75ed5169d1f91a',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
        // ),
      ),
    );
  }
}
