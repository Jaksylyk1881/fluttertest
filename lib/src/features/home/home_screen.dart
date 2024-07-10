import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/router/router.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  final List<NavigationDestination> _destinations = [
    NavigationDestination(
      selectedIcon: const Icon(Icons.groups),
      icon: const Icon(Icons.groups_outlined),
      label: S.current.personal_accounts,
    ),
    NavigationDestination(
      selectedIcon: const Icon(Icons.view_list),
      icon: const Icon(Icons.view_list_outlined),
      label: S.current.journal_log,
    ),
    NavigationDestination(
      selectedIcon: const Icon(Icons.schema),
      icon: const Icon(Icons.schema_outlined),
      label: S.current.opu,
    ),
  ];

  void _onItemTapped(int index, TabsRouter tabsRouter) {
    tabsRouter.setActiveIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [BasePersonalAccountsTab(), BaseJournalLogsTab(), BaseOpuTab()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: child,
          bottomNavigationBar: NavigationBar(
            destinations: _destinations,
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: (index) => _onItemTapped(index, tabsRouter),
          ),
        );
      },
    );
  }
}
