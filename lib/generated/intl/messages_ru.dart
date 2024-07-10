// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(value) => "Тестовое значение в локальном файле ${value}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Добавить"),
        "choose_city": MessageLookupByLibrary.simpleMessage("Выберите город"),
        "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
        "comment": MessageLookupByLibrary.simpleMessage("Комментарий"),
        "filter": MessageLookupByLibrary.simpleMessage("Фильтр"),
        "forget_password":
            MessageLookupByLibrary.simpleMessage("Забыли пароль?"),
        "go_back_auth":
            MessageLookupByLibrary.simpleMessage("Вернуться к авторизации"),
        "journal_log": MessageLookupByLibrary.simpleMessage("Журнал событий"),
        "loading": MessageLookupByLibrary.simpleMessage("Загрузка..."),
        "login": MessageLookupByLibrary.simpleMessage("Логин"),
        "no_data": MessageLookupByLibrary.simpleMessage("Нет данных"),
        "opu": MessageLookupByLibrary.simpleMessage("ОПУ"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "personal_accounts":
            MessageLookupByLibrary.simpleMessage("Лицевые счета"),
        "please_enter_your_details": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите свои данные."),
        "recover_password":
            MessageLookupByLibrary.simpleMessage("Восстановить пароль"),
        "reset": MessageLookupByLibrary.simpleMessage("Сбросить"),
        "testing_value_in_local": m0,
        "update": MessageLookupByLibrary.simpleMessage("Обновить"),
        "welcome": MessageLookupByLibrary.simpleMessage("Добро пожаловать!")
      };
}
