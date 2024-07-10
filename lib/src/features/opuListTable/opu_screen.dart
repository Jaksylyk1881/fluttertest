import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/column_config.dart';
import 'package:fluttertest/src/core/models/utils/extensions/num_extensions.dart';
import 'package:fluttertest/src/core/router/router.dart';
import 'package:fluttertest/src/core/services/home_service.dart';
import 'package:fluttertest/src/core/widgets/custom_table.dart';

@RoutePage()
class OpuScreen extends StatefulWidget {
  const OpuScreen({super.key});

  @override
  State<OpuScreen> createState() => _OpuScreenState();
}

class _OpuScreenState extends State<OpuScreen> {
  late final HomeService _homeService;
  Map<String, dynamic>? selectedData;
  final List<ColumnConfig> _columns = const <ColumnConfig>[
    ColumnConfig(label: Text('Прибор учета №'), code: 'id'),
    ColumnConfig(label: Text('Статус'), code: 'status'),
    ColumnConfig(label: Text('Адрес'), code: 'location'),
    ColumnConfig(label: Text('Дата показаний'), code: 'date'),
  ];
  final UniqueKey _dataTableKey = UniqueKey();
  List<Map<String, dynamic>>? _opus;
  int _currentPage = 0;
  int _totalAccount = 0;
  bool _isLoadingDetail = false;
  bool _isLoading = false;

  @override
  void initState() {
    _homeService = HomeService(context);
    _fetchOpus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchOpus() async {
    setState(() => _isLoading = true);

    try {
      final response = await _homeService.getOpus(_currentPage + 1);
      final List<Map<String, dynamic>> newAccounts =
          (response.data['results'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();

      setState(() {
        _opus = _opus == null ? newAccounts : [..._opus!, ...newAccounts];
        _totalAccount = response.data['total_count'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error fetching personal accounts: $e');
    }
  }

  Future<void> handleRowSelect(Map<String, dynamic> data) async {
    debugPrint('Selected account: ${data['id']}');

    setState(() {
      _isLoadingDetail = true;
      selectedData = data;
      // _startProgressIndicator();
    });

    // await Future.delayed(const Duration(milliseconds: 300));

    await AutoRouter.of(context).push(
      OpuDetailRoute(accountId: data['id'].toString()),
    );

    setState(() {
      _isLoadingDetail = false;
      // _stopProgressIndicator();
    });
  }

  void _onPageChanged() {
    setState(() {
      _isLoading = true;
      _currentPage += 1;
      _fetchOpus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Общедомовые приборы учета',
            style: TextStyle(
                color: Color(0xFF181C20),
                fontSize: 22.0,
                fontWeight: FontWeight.w400)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () {
                AutoRouter.of(context).push(FilterRoute(filterType: 'opu'));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.filter_alt_outlined,
                        color: Color(0xff2C638B)),
                    const SizedBox(width: 8.0),
                    Text(
                      S.of(context).filter,
                      style: const TextStyle(
                          color: Color(0xff2C638B),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _opus == null
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: 16.p,
                          child: CustomDataTable(
                            key: _dataTableKey,
                            onRowSelect: handleRowSelect,
                            data: _opus!,
                            columns: _columns,
                            isLoading: _isLoading,
                            currentPage: _currentPage,
                            totalCount: _totalAccount,
                            onLoadMore: _onPageChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          // if (_isLoadingDetail)
          //   Positioned(
          //     top: 0,
          //     left: 0,
          //     right: 0,
          //     child: LinearProgressIndicator(
          //       value: _progressValue,
          //       valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
