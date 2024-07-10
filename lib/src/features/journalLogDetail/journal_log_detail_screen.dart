import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/journal_log_detail.dart';
import 'package:fluttertest/src/core/configs/opu_detail.dart';
import 'package:fluttertest/src/core/configs/short_config.dart';
import 'package:fluttertest/src/core/router/router.dart';
import 'package:fluttertest/src/core/services/home_service.dart';
import 'package:fluttertest/src/core/services/shared_service.dart';
import 'package:fluttertest/src/core/widgets/custom_button.dart';
import 'package:fluttertest/src/core/widgets/custom_detail_list.dart';

@RoutePage()
class JournalLogScreen extends StatefulWidget {
  final String accountId;

  const JournalLogScreen({required this.accountId, super.key});

  @override
  State<JournalLogScreen> createState() => _JournalLogScreenState();
}

class _JournalLogScreenState extends State<JournalLogScreen>
    with TickerProviderStateMixin {
  late final SharedService _sharedService = SharedService();
  late final HomeService _homeService;
  JournalLog? _opuDetail;
  bool _isLoading = false;
  late List<ShortEntityConfig> _details;
  late List<ShortEntityConfig> _detailsCanceled;
  late BlockEntityConfig _whiteBlockContent;
  late BlockEntityConfig _whiteBlockContentCanceled;

  @override
  void initState() {
    debugPrint('Selected account: ${widget.accountId}');
    super.initState();
    _homeService = HomeService(context);
    _fetchJournalLog();
  }

  void _fetchJournalLog() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _homeService.getJournalLog(widget.accountId);
      setState(() {
        _opuDetail = JournalLog.fromJson(response.data);
      });
      _details = [
        ShortEntityConfig(
            label: 'Лицевой счет',
            value: _opuDetail?.content_type,
            code: 'content_type',
            isDivider: true),
        ShortEntityConfig(
            label: 'Дата регистрации',
            value: _opuDetail?.comment,
            code: 'comment'),
        ShortEntityConfig(
            label: 'Дата закрытия',
            value: _opuDetail?.created_at,
            code: 'created_at',
            isDivider: true),
        ShortEntityConfig(
            label: 'Адрес',
            value: _opuDetail?.description,
            code: 'description'),
        ShortEntityConfig(
            label: 'Собственник',
            value: _opuDetail?.duration,
            code: 'duration',
            isDivider: true),
        ShortEntityConfig(
            label: 'Городской телефон',
            value: _opuDetail?.planned_end_date,
            code: 'planned_end_date'),
        ShortEntityConfig(
            label: 'Мобильный телефон',
            value: _opuDetail?.comment,
            code: 'comment'),
      ];

      _whiteBlockContent = const BlockEntityConfig(
        label: 'Описание заявки',
        description: 'По просьбе собственника провести поверку прибора учета.',
      );
      //
      _detailsCanceled = [
        ShortEntityConfig(
            label: 'Дата закрытия заявки',
            value: _opuDetail?.content_type,
            code: 'content_type'),
        ShortEntityConfig(
            label: 'Исполнитель', value: _opuDetail?.comment, code: 'comment'),
      ];

      _whiteBlockContentCanceled = BlockEntityConfig(
        label: 'Комментарий исполнителя',
        description: _opuDetail?.comment ?? '',
      );
    } catch (e) {
      _homeService.handleError(
          context, 'Error fetching personal account detail');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "ОПУ №${_opuDetail?.id ?? ''}",
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFF181C20),
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color:
                    _sharedService.getBackgroundStatusColor(_opuDetail?.status),
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Text(
                _sharedService.getValue(_opuDetail?.status, 'status'),
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color:
                      _sharedService.getStatusColor(_opuDetail?.status ?? ''),
                ),
              ),
            )
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16.0),
                          DetailListWidget(
                            title: 'Снять показание ИПУ х.в. и г.в.',
                            details: _details,
                            whiteBlockContent: _whiteBlockContent,
                          ),
                          const SizedBox(height: 16.0),
                          if (_opuDetail?.status == 'canceled')
                            DetailListWidget(
                              title: 'Отклонение заявки №${_opuDetail?.id}',
                              details: _detailsCanceled,
                              whiteBlockContent: _whiteBlockContentCanceled,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_opuDetail?.status == 'in_work')
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomButton(
                      text: "Завершить",
                      onPressed: () {
                        AutoRouter.of(context).push(CompleteApplicationRoute(
                            accountId: _opuDetail!.id.toString(),
                            opuDetail: _opuDetail!));
                        debugPrint('Add indication');
                      },
                    ),
                  )
                else if (_opuDetail?.status == 'pending')
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CustomButton(
                          text: 'Принять в работу',
                          onPressed: () {
                            debugPrint('Add indication for first button');
                          },
                        ),
                        const SizedBox(height: 8.0),
                        CustomButton(
                          text: 'Отклонить',
                          isPrimary: false,
                          onPressed: () {
                            AutoRouter.of(context).push(ReasonFailureRoute(
                                accountId: _opuDetail?.id.toString() ?? ''));
                            debugPrint('Add indication for second button');
                          },
                        ),
                      ],
                    ),
                  )
              ],
            ),
    );
  }
}
