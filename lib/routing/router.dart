import 'package:go_router/go_router.dart';

import '../screens/home_page.dart';
import '../screens/current_list.dart';
import '../screens/archived_list.dart';

final router = GoRouter(
  initialLocation: '/current',
  routes: [
    StatefulShellRoute.indexedStack(
      builder:(context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
             GoRoute(
              path: '/current',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CurrentPage(),
              ),
            ),
          ]
        ),
        StatefulShellBranch(
          routes: [
             GoRoute(
              path: '/archived',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ArchivedPage(),
              ),
            ),
          ]
        ),

      ]
    )
  ],
);
