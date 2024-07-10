import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/journal_log_detail.dart';
import 'package:fluttertest/src/core/configs/short_config.dart';
import 'package:fluttertest/src/core/router/router.dart';
import 'package:fluttertest/src/core/widgets/custom_button.dart';
import 'package:fluttertest/src/core/widgets/custom_detail_list.dart';

@RoutePage()
class CompleteApplicationScreen extends StatefulWidget {
  final String accountId;
  final JournalLog opuDetail;

  const CompleteApplicationScreen(
      {required this.accountId, required this.opuDetail, super.key});

  @override
  State<CompleteApplicationScreen> createState() =>
      _CompleteApplicationScreenState();
}

class _CompleteApplicationScreenState extends State<CompleteApplicationScreen>
    with TickerProviderStateMixin {
  late List<ShortEntityConfig> _details;
  bool _isLoading = false;
  JournalLog? _opuDetail;

  @override
  void initState() {
    _opuDetail = widget.opuDetail;

    debugPrint('Selected account: ${widget.accountId}');
    debugPrint('Selected account: ${_opuDetail}');

    super.initState();
    _details = [
      ShortEntityConfig(
          label: 'Класс ИПУ',
          value: _opuDetail?.created_at,
          code: 'created_at'),
      ShortEntityConfig(
          label: 'Расположение ИПУ',
          value: _opuDetail?.description,
          code: 'location_ipu'),
      ShortEntityConfig(
          label: 'Тип ИПУ',
          value: _opuDetail?.comment,
          code: 'type_ipu',
          isDivider: true),
      ShortEntityConfig(
          label: 'Дата изготовления',
          value: _opuDetail?.duration,
          code: 'manufacture_date'),
      ShortEntityConfig(
          label: 'План. пов.', value: _opuDetail?.executor, code: 'executor'),
      ShortEntityConfig(
          label: 'Зав. №',
          value: _opuDetail?.comment,
          code: 'head_no',
          isDivider: true),
      ShortEntityConfig(
          label: 'Калибр', value: _opuDetail?.comment, code: 'caliber'),
      ShortEntityConfig(
          label: 'Приз. суб.', value: _opuDetail?.comment, code: 'prize_sub'),
      ShortEntityConfig(
          label: 'Код счетчика',
          value: _opuDetail?.comment,
          code: 'counter_code'),
      ShortEntityConfig(
          label: 'Статус ПУ',
          value: _opuDetail?.comment,
          code: 'status_ipu',
          isDivider: true),
      ShortEntityConfig(
          label: 'Дата показания',
          value: _opuDetail?.comment,
          code: 'date_of_indication'),
      ShortEntityConfig(
          label: 'Показание', value: _opuDetail?.creator, code: 'creator'),
    ];
  }

  void _saveData() {
    // final formData = {
    //   'dateOfDeposition': _controllers['dateOfDeposition']!.text,
    // };
    AutoRouter.of(context).push(
      JournalAddReadingRoute(
        accountId: widget.accountId,
      ),
    );
    debugPrint('Save data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Завершить заявку",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF181C20),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailListWidget(
                      title: 'Снять показание ИПУ х.в. и г.в.',
                      details: _details,
                      // whiteBlockContent: _whiteBlockContent,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
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
                onPressed: () {
                  debugPrint('Cancel button pressed');
                  // if (_commentController.text.isNotEmpty) {
                  _saveData();
                  // }
                },
                text: 'Добавить показания',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
