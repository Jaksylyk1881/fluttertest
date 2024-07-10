import 'package:flutter/material.dart';

class SharedService {
  get dateValues => [
        'date',
        'created_at',
        'updated_at',
        'start_date',
        'end_date',
        'planned_end_date'
      ];

  String getValue(dynamic value, String key) {
    if (value == null) return '';
    if (dateValues.contains(key)) {
      return DateTime.parse(value).toString();
    }

    if (key == 'is_active') {
      return value ? 'Активен' : 'Не активен';
    }

    if (value is bool) {
      return value ? 'Да' : 'Нет';
    }

    if (key == 'status') {
      switch (value) {
        case 'created':
          return 'Создан';
        case 'accepted':
          return 'Принят';
        case 'checked':
          return 'Проверен';
        case 'pending':
          return 'Ожидает обработки';
        case 'finish':
          return 'Завершено';
        case 'in_work':
          return 'В работе';
        case 'canceled':
          return 'Отклонено';
        // default:
        //   return 'Неизвестно';
      }
    }

    if (value is String) return value;

    if (value is Map) {
      switch (key) {
        case 'status':
        case 'location':
        case 'street':
        case 'locality':
          return value['name'] ?? '';
        case 'executor':
          return value['fio'] ?? '';
        case 'creator':
        case 'user':
          return value['username'] ?? '';
        default:
          return value.toString();
      }
    } else if (value is List) {
      return value.join(', ');
    } else {
      return value.toString();
    }
  }

  Color getStatusColorFromFilter(dynamic filter, {bool isBackground = false}) {
    if (isBackground) {
      switch (filter) {
        case 'checked':
        case 'active':
        case 'finish':
          return Color(0xffD1FADF);
        case 'created':
          return Color(0xffD1E9FF);
        case 'accepted':
        case 'inactive':
        case 'canceled':
          return Color(0xffE4E7EC);
        case 'pending':
          return Color(0xffF4DFFA);
        case 'in_work':
          return Color(0xffFFEAD5);
        default:
          return Colors.transparent;
      }
    } else {
      switch (filter) {
        case 'checked':
        case 'active':
        case 'finish':
          return Color(0xff027A48);
        case 'created':
          return Color(0xff175CD3);
        case 'inactive':
        case 'accepted':
        case 'canceled':
          return Color(0xff667085);
        case 'pending':
          return Color(0xff9736E2);
        case 'in_work':
          return Color(0xffEC4A0A);
        default:
          return Colors.transparent;
      }
    }
  }

  Color getStatusColor(dynamic status, {bool isBackground = false}) {
    if (status == null) return Colors.transparent;

    String filter;
    if (status is String) {
      filter = status;
    } else if (status is Map && status.containsKey('name')) {
      filter = status['name'];
    } else if (status is bool) {
      filter = status ? 'active' : 'inactive';
    } else {
      return Colors.transparent;
    }

    return getStatusColorFromFilter(filter, isBackground: isBackground);
  }

  Color getBackgroundStatusColor(dynamic status) {
    return getStatusColor(status, isBackground: true);
  }
}
