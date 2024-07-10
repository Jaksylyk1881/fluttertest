import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/field_config.dart';
import 'package:fluttertest/src/core/configs/personal_account_detail.dart';
import 'package:fluttertest/src/core/configs/short_config.dart';
import 'package:fluttertest/src/core/configs/tab_config.dart';
import 'package:fluttertest/src/core/services/home_service.dart';
import 'package:fluttertest/src/core/widgets/custom_button.dart';
import 'package:fluttertest/src/core/widgets/custom_detail_list.dart';
import 'package:fluttertest/src/core/widgets/custom_dynamic_fileds.dart';
import 'package:fluttertest/src/core/widgets/custom_photo_block.dart';

@RoutePage()
class JournalAddReadingScreen extends StatefulWidget {
  final String accountId;

  const JournalAddReadingScreen({required this.accountId, super.key});

  @override
  State<JournalAddReadingScreen> createState() =>
      _JournalAddReadingScreenState();
}

class _JournalAddReadingScreenState extends State<JournalAddReadingScreen>
    with TickerProviderStateMixin {
  final List<FieldConfig> _fields = [
    FieldConfig(
      labelText: 'Дата снятия показаний',
      key: 'dateOfDeposition',
      fieldType: FieldType.date,
    ),
    FieldConfig(
      labelText: 'Расположение ИПУ',
      key: 'ipu_location',
      fieldType: FieldType.select,
      selectItems: [
        'В колодце во дворе',
        'В колодце на врезке',
        'В подвале дома',
        'В помещении',
        'В помещении по гарантийному письму',
        'В помещении по проекту',
        'Нет сведений',
        'Прочее',
        'Субсчетчик'
      ],
    ),
    FieldConfig(
      labelText: 'Показание',
      key: 'indication',
      fieldType: FieldType.text,
    ),
    FieldConfig(
      labelText: 'Номер пломбы',
      key: 'circle',
      fieldType: FieldType.text,
    ),
    FieldConfig(
      labelText: 'Типичная ситуация',
      key: 'meaning',
      fieldType: FieldType.select,
      selectItems: [
        'Акт вывода из расчета ИПУ Х.В.',
        'Дистанционный съем показаний',
        'Закрыта подача воды (опломбирован или види…)',
        'Количество приборов не соответствует',
        'Магнит',
        'Нарушена герметичность счетчика',
        'Нарушена пломба привязки',
        'Не впускают',
        'Нет гос. пломбы',
        'Нет доступа',
        'Номер счётчика не совпадает',
        'Отказ от ИПУ',
        'Перепроверка показаний (верно)',
        'Плановая проверка',
        'Подключение минуя счётчик',
        'Подтверждаем превышение ср. сут. объема',
        'Показание со слов абонента',
        'Показания для верного абонента',
        'Проверка ССППУ',
        'Разбито стекло',
        'Следы механического воздействия',
        'Среднесуточные показания',
        'Стекло запотевшее (конденсат, показание видно)',
        'Счетчик не работает',
        'Счетчик отсутствует',
        'Счетчик замурован (установка ИПУ не соответствует…)',
        'Юридическое лицо',
        'Дом снесён',
        'Счетчик крутит в обратную сторону',
      ],
    ),
  ];
  final List<FieldConfig> _fieldsDoc = [
    FieldConfig(
      labelText: 'Номер',
      key: 'number',
      fieldType: FieldType.text,
    ),
    FieldConfig(
      labelText: 'Дата',
      key: 'date',
      fieldType: FieldType.date,
    ),
    FieldConfig(
      labelText: 'Типичная ситуация',
      key: 'meaning',
      fieldType: FieldType.select,
      selectItems: [
        'Акт вывода и расчета ПУ',
        'Акт допуска в эксплуатацию узла учета воды',
        'Акт обнаружения выявленных нарушений при осмотре',
        'Акт обследования',
        'Акт обследования/нарушения услуг',
        'Акт прекращения подачи холодной воды',
        'Акт регистрации',
        'Акт уведомление нет доступа',
        'Акт уведомление о дебиторской задолженности',
        'Акт уведомление/прекращения услуг',
      ],
    ),
  ];

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  late final HomeService _homeService;
  bool _isLoading = false;
  late final TabController _tabController;
  late List<TabConfig> _tabConfigs;
  double _progressValue = 0.5;
  bool _isSecondTabEnabled = false;

  @override
  void initState() {
    super.initState();
    _homeService = HomeService(context);
    debugPrint('Selected account: ${widget.accountId}');
    _tabController = TabController(length: 2, vsync: this);
    _initializeTabs();
    _tabController.addListener(_handleTabSelection);
    for (var field in _fields) {
      _controllers[field.key] = TextEditingController();
      _focusNodes[field.key] = FocusNode();
    }
  }

  void _initializeTabs() {
    _tabConfigs = [
      TabConfig(label: 'Показания', builder: () => _buildIndicationsTab()),
      TabConfig(
        label: 'Документ-основание',
        builder: () => _buildFoundationDocTab(),
      ),
    ];
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging &&
        _tabController.index == 1 &&
        !_isSecondTabEnabled) {
      _tabController.index = 0;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _graduallyIncreaseProgress() {
    setState(() {
      _progressValue += 0.5;
    });
    _isSecondTabEnabled = true;
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавить показание',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF181C20),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicator: const BoxDecoration(),
                        tabs: _tabConfigs
                            .map((config) => Tab(
                                  text: config.label,
                                ))
                            .toList(),
                        onTap: (index) {
                          if (index == 1 && !_isSecondTabEnabled) {
                            _tabController.index = 0;
                          }
                        },
                      ),
                      LinearProgressIndicator(
                        value: _progressValue,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2C638B)),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (!_isSecondTabEnabled &&
                                _tabController.index == 0 &&
                                details.delta.dx < 0) {
                              return;
                            }
                            _tabController.animateTo(_tabController.index);
                          },
                          child: TabBarView(
                            controller: _tabController,
                            physics: _isSecondTabEnabled
                                ? const AlwaysScrollableScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            children: _tabConfigs
                                .map((config) => config.builder())
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildIndicationsTab() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0),
                DynamicFormFields(
                  title: 'Показания прибора учета',
                  fields: _fields,
                  controllers: _controllers,
                  focusNodes: _focusNodes,
                ),
                const SizedBox(height: 16.0),
                PhotoBlock(
                  title: 'Фото прибора учета',
                  onPhotoChanged: (event) {
                    debugPrint('Photo changed $event');
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            )

            //     }
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                isPrimary: false,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Отмена',
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: CustomButton(
                onPressed: () => _graduallyIncreaseProgress(),
                text: 'Далее',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoundationDocTab() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0),
                DynamicFormFields(
                  title: 'Данные акта',
                  fields: _fields,
                  controllers: _controllers,
                  focusNodes: _focusNodes,
                ),
                const SizedBox(height: 16.0),
                PhotoBlock(
                  title: 'Фото акта',
                  onPhotoChanged: (event) {
                    debugPrint('Photo changed $event');
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                isPrimary: false,
                onPressed: () {
                  debugPrint('Отменить');
                  Navigator.of(context).pop();
                },
                text: 'Отмена',
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: CustomButton(
                onPressed: () {
                  // _isSecondTabEnabled = true;
                  // setState(() {
                  //   _progressValue = 1.0;
                  // });
                  // debugPrint('Далее$_progressValue');
                  // _tabController.animateTo(1);
                  // debugPrint('Сохранить');
                },
                text: 'Далее',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
