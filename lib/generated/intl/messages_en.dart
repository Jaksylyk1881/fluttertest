// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(value) => "This is a test value in local.json \$${value}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "choose_city": MessageLookupByLibrary.simpleMessage("Choose a city"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "comment": MessageLookupByLibrary.simpleMessage("Comment"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "forget_password":
            MessageLookupByLibrary.simpleMessage("Forget password?"),
        "go_back_auth":
            MessageLookupByLibrary.simpleMessage("Вернуться к авторизации"),
        "journal_log": MessageLookupByLibrary.simpleMessage("Журнал событий"),
        "loading": MessageLookupByLibrary.simpleMessage("Загрузка..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "no_data": MessageLookupByLibrary.simpleMessage("Нет данных"),
        "opu": MessageLookupByLibrary.simpleMessage("ОПУ"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "personal_accounts":
            MessageLookupByLibrary.simpleMessage("Personal accounts"),
        "please_enter_your_details":
            MessageLookupByLibrary.simpleMessage("Please enter your details"),
        "recover_password":
            MessageLookupByLibrary.simpleMessage("Восстановить пароль"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "testing_value_in_local": m0,
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome!")
      };
}
