import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/column_config.dart';
import 'package:fluttertest/src/core/models/utils/extensions/num_extensions.dart';
import 'package:fluttertest/src/core/router/router.dart';
import 'package:fluttertest/src/core/services/auth_service.dart';
import 'package:fluttertest/src/core/services/home_service.dart';
import 'package:fluttertest/src/core/services/message_service.dart';
import 'package:fluttertest/src/core/widgets/custom_table.dart';

@RoutePage()
class PersonalAccountsScreen extends StatefulWidget {
  const PersonalAccountsScreen({super.key});

  @override
  State<PersonalAccountsScreen> createState() => _PersonalAccountsState();
}

class _PersonalAccountsState extends State<PersonalAccountsScreen> {
  final AuthService _authService = AuthService();
  final MessageService _messageService = MessageService();
  late final HomeService _homeService;
  final List<ColumnConfig> _columns = const <ColumnConfig>[
    ColumnConfig(label: Text('ID'), code: 'id'),
    ColumnConfig(label: Text('Лицевой счет'), code: 'identifier'),
    ColumnConfig(label: Text('ИИН'), code: 'iin'),
    ColumnConfig(label: Text('Собственник'), code: 'owner'),
    ColumnConfig(label: Text('Населенный пункт'), code: 'city'),
    ColumnConfig(label: Text('Дата рождения'), code: 'birthday'),
    ColumnConfig(label: Text('Моб. тел. №1'), code: 'home_phone_1'),
    ColumnConfig(label: Text('Моб. тел. №2'), code: 'home_phone_2'),
  ];

  List<Map<String, dynamic>>? _personalAccounts;
  Map<String, dynamic>? selectedData;
  bool _isLoadingDetail = false;
  bool _isLoading = false;
  int _currentPage = 0;
  int _totalAccount = 0;
  double _progressValue = 0.0;
  Timer? _timer;
  final UniqueKey _dataTableKey = UniqueKey();

  @override
  void initState() {
    _homeService = HomeService(context);
    _fetchPersonalAccounts();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchPersonalAccounts() async {
    setState(() => _isLoading = true);

    try {
      final response = await _homeService.getPersonalAccounts(_currentPage + 1);
      final List<Map<String, dynamic>> newAccounts =
          (response.data['results'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();

      setState(() {
        _personalAccounts = _personalAccounts == null
            ? newAccounts
            : [..._personalAccounts!, ...newAccounts];
        _totalAccount = response.data['total_count'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error fetching personal accounts: $e');
    }
  }

  Future<void> handleRowSelect(Map<String, dynamic> data) async {
    setState(() {
      _isLoadingDetail = true;
      selectedData = data;
      // _startProgressIndicator();
    });

    // await Future.delayed(const Duration(milliseconds: 300));

    await AutoRouter.of(context).push(
      PersonalAccountRoute(accountId: data['id'].toString()),
    );

    setState(() {
      _isLoadingDetail = false;
      // _stopProgressIndicator();
    });
  }

  // void _startProgressIndicator() {
  //   _progressValue = 0.0;
  //   _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
  //     setState(() {
  //       _progressValue += 0.3;
  //       if (_progressValue >= 1.0) {
  //         _progressValue = 0.0;
  //       }
  //     });
  //   });
  // }

  // void _stopProgressIndicator() {
  //   _timer?.cancel();
  //   _timer = null;
  // }

  void _onPageChanged() {
    setState(() {
      _isLoading = true;
      _currentPage += 1;
      _fetchPersonalAccounts();
    });
  }

  void logout() {
    _authService.logout(context);

    setState(() {
      _isLoadingDetail = false;
      _personalAccounts = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(S.of(context).personal_accounts,
            style: const TextStyle(
                color: Color(0xFF181C20),
                fontSize: 22.0,
                fontWeight: FontWeight.w400)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () {
                AutoRouter.of(context)
                    .push(FilterRoute(filterType: 'personal'));
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
          _personalAccounts == null
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
                            data: _personalAccounts!,
                            columns: _columns,
                            isLoading: _isLoading,
                            currentPage: _currentPage,
                            totalCount: _totalAccount,
                            onLoadMore: _onPageChanged,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
          // if (_isLoadingDetail)
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: ElevatedButton(
              onPressed: logout,
              child: const Text('Logout'),
            ),
          ),
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: LinearProgressIndicator(
          //     value: _progressValue,
          //     valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          //   ),
          // ),
        ],
      ),
    );
  }
}
