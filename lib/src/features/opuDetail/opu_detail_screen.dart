import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/opu_detail.dart';
import 'package:fluttertest/src/core/configs/short_config.dart';
import 'package:fluttertest/src/core/router/router.dart';
import 'package:fluttertest/src/core/services/home_service.dart';
import 'package:fluttertest/src/core/services/shared_service.dart';
import 'package:fluttertest/src/core/widgets/custom_detail_list.dart';

@RoutePage()
class OpuDetailScreen extends StatefulWidget {
  final String accountId;

  const OpuDetailScreen({required this.accountId, super.key});

  @override
  State<OpuDetailScreen> createState() => _OpuDetailScreenState();
}

class _OpuDetailScreenState extends State<OpuDetailScreen>
    with TickerProviderStateMixin {
  late final SharedService _sharedService = SharedService();
  late final HomeService _homeService;
  OpuDetail? _opuDetail;
  bool _isLoading = false;
  late List<ShortEntityConfig> _details;

  @override
  void initState() {
    debugPrint('Ssdfgsdg: ${widget.accountId}');
    super.initState();
    _homeService = HomeService(context);
    _fetchOpuDetail();
  }

  void _fetchOpuDetail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _homeService.getOpuDetail(widget.accountId);
      setState(() {
        _opuDetail = OpuDetail.fromJson(response.data);
      });
      _details = [
        ShortEntityConfig(
            label: 'Город', value: _opuDetail?.locality, code: 'locality'),
        ShortEntityConfig(
            label: 'Наименование улицы',
            value: _opuDetail?.comment,
            code: 'comment'),
        ShortEntityConfig(
            label: 'Дом №',
            value: _opuDetail?.street,
            code: 'street',
            isDivider: true),
        ShortEntityConfig(
            label: 'Дата показаний',
            value: _opuDetail?.conduit_size,
            code: 'conduit_size'),
        ShortEntityConfig(
            label: 'Круг', value: _opuDetail?.is_active, code: 'is_active'),
        ShortEntityConfig(
            label: 'Значение',
            value: _opuDetail?.is_deleted,
            code: 'is_deleted'),
        ShortEntityConfig(
            label: 'Фото',
            value:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQihN_IRIXwi515XwNAEmtKw4vAmoUzoPJ7KA&s',
            code: 'photo'),
      ];
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
                color: _sharedService
                    .getBackgroundStatusColor(_opuDetail?.is_active),
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Text(
                _sharedService.getValue(_opuDetail?.is_active, 'is_active'),
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: _sharedService
                      .getStatusColor(_opuDetail?.is_active ?? ''),
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
                            details: _details,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        AutoRouter.of(context).push(
                          OpuAddReadingRoute(
                            accountId: _opuDetail!.id.toString(),
                          ),
                        );
                      },
                      extendedTextStyle: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C638B),
                      ),
                      backgroundColor: const Color(0xffE6E8EE),
                      label: const Text('Добавить показание'),
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
