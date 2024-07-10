import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/configs/journal_log_detail.dart';
import 'package:fluttertest/src/core/guards/auth_guard.dart';
import 'package:fluttertest/src/core/services/auth_service.dart';
import 'package:fluttertest/src/features/journalLogDetail/journal_log_detail_screen.dart';
import 'package:fluttertest/src/features/journalLogDetail/screens/journal_add_reading_screen.dart';
import 'package:fluttertest/src/features/journalLogDetail/screens/complete_application.dart';
import 'package:fluttertest/src/features/journalLogDetail/screens/reason_failure.dart';
import 'package:fluttertest/src/features/opuListTable/opu_screen.dart';
import 'package:fluttertest/src/features/auth/auth_screen.dart';
import 'package:fluttertest/src/features/auth/password_recovery_screen.dart';
import 'package:fluttertest/src/features/filter/filter_screen.dart';
import 'package:fluttertest/src/features/journalLogs/journal_logs_screen.dart';
import 'package:fluttertest/src/features/home/home_screen.dart';
import 'package:fluttertest/src/features/opuDetail/screens/opu_add_reading_screen.dart';
import 'package:fluttertest/src/features/opuDetail/opu_detail_screen.dart';
import 'package:fluttertest/src/features/personalAccountDetail/personal_account_detail_screen.dart';
import 'package:fluttertest/src/features/personalAccounts/personal_accounts_screen.dart';

part 'router.gr.dart';

final AuthService _authService = AuthService();

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final AuthGuard authGuard = AuthGuard(_authService);

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: AuthRoute.page,
          path: '/login',
          initial: true,
          guards: [authGuard],
        ),
        AutoRoute(page: PasswordRecoveryRoute.page, path: '/password_recovery'),
        AutoRoute(page: MainRoute.page, path: '/main', children: [
          ///
          /// BasePersonalAccountsTab
          ///
          AutoRoute(page: BasePersonalAccountsTab.page, children: [
            AutoRoute(
              page: PersonalAccountsRoute.page,
              path: 'personal-accounts',
              initial: true,
            ),
            RedirectRoute(path: '', redirectTo: 'personal-accounts'),
          ]),

          ///
          /// BaseJournalLogsTab
          ///
          AutoRoute(page: BaseJournalLogsTab.page, children: [
            AutoRoute(
              page: JournalLogsRoute.page,
              path: 'journal-logs',
              initial: true,
            ),
          ]),

          ///
          /// BaseOpuTab
          ///
          AutoRoute(page: BaseOpuTab.page, children: [
            AutoRoute(
              page: OpuRoute.page,
              path: 'opu',
              initial: true,
            ),
          ]),
        ]),

        // opu
        AutoRoute(page: OpuDetailRoute.page, path: '/opu/:id'),
        AutoRoute(page: ReasonFailureRoute.page, path: '/opu/reason-failure/:id'),
        AutoRoute(page: OpuAddReadingRoute.page, path: '/opu/add-reading/:id'),

        //
        AutoRoute(page: FilterRoute.page, path: '/filter/:filterType'),

        // journal log
        AutoRoute(page: JournalLogRoute.page, path: '/journal-logs/:id'),
        AutoRoute(page: CompleteApplicationRoute.page, path: '/journal-logs/complete-application/:id'),
        AutoRoute(page: JournalAddReadingRoute.page, path: '/journal-logs/add-reading/:id'),

        // personal account
        AutoRoute(page: PersonalAccountRoute.page, path: '/personal-accounts/:id'),
      ];
}

@RoutePage(name: 'BasePersonalAccountsTab')
class BasePersonalAccountsPage extends AutoRouter {
  const BasePersonalAccountsPage({super.key});
}

@RoutePage(name: 'BaseJournalLogsTab')
class BaseJournalLogsPage extends AutoRouter {
  const BaseJournalLogsPage({super.key});
}

@RoutePage(name: 'BaseOpuTab')
class BaseOpuPage extends AutoRouter {
  const BaseOpuPage({super.key});
}
