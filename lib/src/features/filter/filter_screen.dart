import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/widgets/custom_button.dart';
import 'package:fluttertest/src/core/widgets/custom_input.dart';
import 'package:fluttertest/src/core/widgets/custom_select.dart';

@RoutePage()
class FilterScreen extends StatefulWidget {
  final String filterType;

  const FilterScreen({required this.filterType, super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

const List<String> _listSelect = <String>[
  '1-й месяц',
  '2-й месяц',
  '3-й месяц',
  'Все месяца'
];
const List<String> _listSelect2 = <String>[
  'ИПУ не снятые',
  'ИПУ снятые',
  'Без ИПУ',
  'Все'
];
const List<String> _statusListSelect = <String>[
  'Установлен',
  'Заменен',
  'Снят'
];
const List<String> _journalStatusListSelect = <String>[
  'Ожидает обработки',
  'В работе',
  'Завершено',
  'Отклонено',
];

class _FilterScreenState extends State<FilterScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  String dropdownValue = '';
  String dropdownValue2 = '';
  String statusDropdownValue = '';
  String journalStatusDropdownValue = '';
  int _count = 1;

  @override
  void initState() {
    super.initState();
    final fields = [
      'personalAccount',
      'lsAlseko',
      'area',
      'street',
      'house',
      'appartment',
      'fio',
      'iup'
    ];
    for (var field in fields) {
      _controllers[field] = TextEditingController();
      _focusNodes[field] = FocusNode();
    }
  }

  void _clearFilters() {
    for (var controller in _controllers.values) {
      controller.clear();
    }

    for (var focusNode in _focusNodes.values) {
      focusNode.unfocus();
    }

    setState(() {
      dropdownValue = '';
      dropdownValue2 = '';
      statusDropdownValue = '';
      journalStatusDropdownValue = '';
    });
    final query = _collectFilterValues();
    debugPrint('Filter values: $query');
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Widget _buildCustomInput(
      String labelText, String controllerKey, FocusNode focusNode) {
    return CustomInput(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      labelText: labelText,
      controller: _controllers[controllerKey]!,
      focusNode: focusNode,
    );
  }

  Widget _buildCustomSelect(String labelText, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return CustomSelect(
      key: UniqueKey(),
      labelText: labelText,
      value: value.isEmpty ? null : value,
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildPersonalFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: _buildCustomInput('Лицевой счет', 'personalAccount',
                    _focusNodes['personalAccount']!)),
            const SizedBox(width: 16.0),
            Expanded(
                child: _buildCustomInput(
                    'ЛС Алсеко', 'lsAlseko', _focusNodes['lsAlseko']!)),
          ],
        ),
        const SizedBox(height: 16.0),
        const Divider(),
        const SizedBox(height: 16.0),
        _buildCustomInput('Район', 'area', _focusNodes['area']!),
        const SizedBox(height: 16.0),
        _buildCustomInput(
            'Наименование улицы', 'street', _focusNodes['street']!),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
                child:
                    _buildCustomInput('Дом', 'house', _focusNodes['house']!)),
            const SizedBox(width: 16.0),
            Expanded(
                child: _buildCustomInput(
                    'Квартира', 'appartment', _focusNodes['appartment']!)),
          ],
        ),
        const SizedBox(height: 16.0),
        const Divider(),
        const SizedBox(height: 16.0),
        _buildCustomInput('ФИО владельца', 'fio', _focusNodes['fio']!),
        const SizedBox(height: 16.0),
        _buildCustomInput('Заводской номер ИПУ', 'iup', _focusNodes['iup']!),
        const SizedBox(height: 16.0),
        _buildCustomSelect('Период', dropdownValue2, _listSelect2,
            (String? value) {
          setState(() {
            dropdownValue2 = value ?? '';
          });
        }),
        const SizedBox(height: 16.0),
        _buildCustomSelect('Условие ИПУ', dropdownValue, _listSelect,
            (String? value) {
          setState(() {
            dropdownValue = value ?? '';
          });
        }),
      ],
    );
  }

  Widget _buildOpuFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomInput('Прибор учета №', 'personalAccount',
            _focusNodes['personalAccount']!),
        const SizedBox(height: 16.0),
        _buildCustomSelect('Статус', statusDropdownValue, _statusListSelect,
            (String? value) {
          setState(() {
            statusDropdownValue = value ?? '';
          });
        }),
        const SizedBox(height: 16.0),
        const Divider(),
        const SizedBox(height: 16.0),
        _buildCustomInput('Город', 'lsAlseko', _focusNodes['lsAlseko']!),
        const SizedBox(height: 16.0),
        _buildCustomInput('Наименование улицы', 'area', _focusNodes['area']!),
        const SizedBox(height: 16.0),
        _buildCustomInput('Дом №', 'street', _focusNodes['street']!),
      ],
    );
  }

  Widget _buildJournalFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomInput(
            'Лицевой счет', 'personalAccount', _focusNodes['personalAccount']!),
        const SizedBox(height: 16.0),
        _buildCustomInput('ФИО собственника', 'personalAccount',
            _focusNodes['personalAccount']!),
        const SizedBox(height: 16.0),
        _buildCustomSelect('Статус заявки', journalStatusDropdownValue,
            _journalStatusListSelect, (String? value) {
          setState(() {
            journalStatusDropdownValue = value ?? '';
          });
        }),
        const SizedBox(height: 16.0),
        const Divider(),
        const SizedBox(height: 16.0),
        _buildCustomInput('Район', 'lsAlseko', _focusNodes['lsAlseko']!),
        const SizedBox(height: 16.0),
        _buildCustomInput('Наименование улицы', 'area', _focusNodes['area']!),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
                child:
                    _buildCustomInput('Дом', 'house', _focusNodes['house']!)),
            const SizedBox(width: 16.0),
            Expanded(
                child: _buildCustomInput(
                    'Квартира', 'appartment', _focusNodes['appartment']!)),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildFilterContent() {
    switch (widget.filterType) {
      case 'opu':
        return _buildOpuFilter();
      case 'personal':
        return _buildPersonalFilter();
      case 'journal':
        return _buildJournalFilter();
      default:
        return const SizedBox.shrink();
    }
  }

  Map<String, dynamic> _collectFilterValues() {
    final filterValues = <String, dynamic>{};

    _controllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        filterValues[key] = controller.text;
      }
    });

    if (dropdownValue.isNotEmpty) {
      filterValues['dropdownValue'] = dropdownValue;
    }
    if (dropdownValue2.isNotEmpty) {
      filterValues['dropdownValue2'] = dropdownValue2;
    }
    if (statusDropdownValue.isNotEmpty) {
      filterValues['statusDropdownValue'] = statusDropdownValue;
    }
    if (journalStatusDropdownValue.isNotEmpty) {
      filterValues['journalStatusDropdownValue'] = journalStatusDropdownValue;
    }
    return filterValues;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).filter,
          style: const TextStyle(
            color: Color(0xFF181C20),
            fontSize: 22.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: _clearFilters,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Text(
                  S.of(context).reset,
                  style: const TextStyle(
                    color: Color(0xff2C638B),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            _buildFilterContent(),
            const Spacer(),
            CustomButton(
              onPressed: () {
                final query = _collectFilterValues();

                debugPrint('Filter values: $query');
              },
              text: 'Показать результаты',
            ),
          ],
        ),
      ),
    );
  }
}
