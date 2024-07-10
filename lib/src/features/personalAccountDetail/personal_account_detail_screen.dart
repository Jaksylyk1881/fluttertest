import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/configs/personal_account_detail.dart';
import 'package:fluttertest/src/core/configs/short_config.dart';
import 'package:fluttertest/src/core/configs/tab_config.dart';
import 'package:fluttertest/src/core/services/home_service.dart';
import 'package:fluttertest/src/core/widgets/custom_detail_list.dart';
import 'package:fluttertest/src/core/widgets/custom_photo_block.dart';

@RoutePage()
class PersonalAccountScreen extends StatefulWidget {
  final String accountId;

  const PersonalAccountScreen({required this.accountId, super.key});

  @override
  State<PersonalAccountScreen> createState() => _PersonalAccountScreenState();
}

class _PersonalAccountScreenState extends State<PersonalAccountScreen>
    with TickerProviderStateMixin {
  late final HomeService _homeService;
  late PersonalAccount? _personalAccount;
  late bool _isLoading = false;
  late final TabController _tabController;
  late List<TabConfig> _tabConfigs;
  late List<ShortEntityConfig> _details;

  @override
  void initState() {
    super.initState();
    _homeService = HomeService(context);
    debugPrint('Selected account: ${widget.accountId}');
    _tabController = TabController(length: 2, vsync: this);
    _initializeTabs();
    _fetchPersonalAccountDetail();
  }

  void _initializeTabs() {
    _tabConfigs = [
      TabConfig(label: 'Общие данные', builder: () => _buildGeneralDataTab()),
      TabConfig(label: 'ИПУ', builder: () => _buildIPUTab()),
    ];
  }

  void _fetchPersonalAccountDetail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _homeService.getPersonalAccount(widget.accountId);
      setState(() {
        _personalAccount = PersonalAccount.fromJson(response.data);
      });
      _details = [
        ShortEntityConfig(
            label: 'Address',
            value: _personalAccount?.birthday,
            code: 'birthday'),
        ShortEntityConfig(
            label: 'Balance', value: _personalAccount?.city, code: 'city'),
        ShortEntityConfig(
            label: 'Status', value: _personalAccount?.city, code: 'city'),
        ShortEntityConfig(
            label: 'Собственник',
            value: _personalAccount?.owner,
            code: 'owner'),
        ShortEntityConfig(
            label: 'Признак учета',
            value: _personalAccount?.city,
            code: 'city'),
        ShortEntityConfig(
            label: 'Площадь сада/огорода',
            value: _personalAccount?.city,
            code: 'city'),
        ShortEntityConfig(
            label: 'Тип потребления',
            value: _personalAccount?.city,
            code: 'city'),
        ShortEntityConfig(
            label: 'Кол-во проживающих',
            value: _personalAccount?.city,
            code: 'city'),
        ShortEntityConfig(
            label: 'Ст.Блог.', value: _personalAccount?.owner, code: 'owner'),
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: _fetchPersonalAccountDetail,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Text(
                  S.of(context).update,
                  style: const TextStyle(
                      color: Color(0xff2C638B),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Лицевой счет №${_personalAccount?.identifier}',
                        style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF181C20)),
                      ),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: const Color(0xff2C638B),
                        tabs: _tabConfigs
                            .map((config) => Tab(
                                  text: config.label,
                                ))
                            .toList(),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: _tabConfigs
                              .map((config) => config.builder())
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGeneralDataTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<void>(
            future: _fetchGeneralData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    DetailListWidget(
                      details: _details,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _fetchGeneralData() async {
    // await Future.delayed(const Duration(seconds: 2));
    debugPrint('Fetching general data...');
  }

  Widget _buildIPUTab() {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        DetailListWidget(
          details: _details,
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                debugPrint('Add indication');
              },
              extendedTextStyle: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C638B)),
              backgroundColor: const Color(0xffE6E8EE),
              label: const Text('Добавить показание'),
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
