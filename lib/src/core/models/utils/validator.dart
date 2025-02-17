import 'package:flutter/material.dart';

/// An abstract interface for input validation.
///
/// This interface defines a contract for validation logic that can be implemented
/// by various validators for different types of inputs such as email, name, password, etc.
abstract class IValidator {
  /// Validates the given input [value].
  ///
  /// Implementers should return a string representing an error message if the validation
  /// fails, or null if the input passes the validation.
  String? call(String? value);
}

/// A validator for email input.
///
/// This class implements the [IValidator] interface to provide email validation logic.
final class EmailValidator implements IValidator {
  @override
  String? call(String? value) {
    if (value == null ||
        value.isEmpty ||
        !value.contains('@') ||
        !value.contains('.')) {
      return 'Введите действительный адрес электронной почты';
    }
    if (value.length < 6 || value.length > 50) {
      return 'Email должен быть не менее 6 и не более 50 символов';
    }
    return null;
  }
}

/// A validator for name input.
///
/// This class implements the [IValidator] interface to provide validation for names,
/// ensuring that the input only contains letters.
final class NameValidator implements IValidator {
  @override
  String? call(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите имя';
    }
    if (!RegExp(r'^[a-zA-Zа0-9]+$').hasMatch(value)) {
      return 'Имя должно содержать только буквы и цифры';
    }
    if (value.length < 2 || value.length > 50) {
      return 'Имя должно быть не менее 2 и не более 50 символов';
    }
    return null;
  }
}

/// A validator for password input.
///
/// This class implements the [IValidator] interface to provide password validation,
/// enforcing a minimum length and a mix of letters and numbers.
final class PasswordValidator implements IValidator {
  @override
  String? call(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 3) {
      return 'Пароль должен быть не менее 3 символов';
    }
    if (value.length > 20) {
      return 'Пароль должен быть не более 20 символов';
    }

    return null;
  }
}

/// A validator for phone number input.
///
/// This class implements the [IValidator] interface to validate phone numbers,
/// ensuring that the input matches a specific format.
final class PhoneNumberValidator implements IValidator {
  @override
  String? call(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите номер телефона';
    }
    if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
      return 'Некорректный номер телефона';
    }
    return null;
  }
}

class PasswordMatchValidator {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  PasswordMatchValidator(
      {required this.passwordController,
      required this.confirmPasswordController});

  String? validate() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (password != confirmPassword) {
      return 'Пароли не совпадают';
    }
    return null;
  }
}
