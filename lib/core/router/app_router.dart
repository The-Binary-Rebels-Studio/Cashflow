import 'package:go_router/go_router.dart';
import 'package:cashflow/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:cashflow/features/profile/presentation/pages/bug_report_page.dart';
import 'package:cashflow/features/settings/presentation/pages/settings_page.dart';
import 'package:cashflow/shared/widgets/main_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) {
          final indexString = state.uri.queryParameters['tab'];
          final index = int.tryParse(indexString ?? '0') ?? 0;
          return MainNavigation(initialIndex: index);
        },
      ),
      GoRoute(
        path: '/bug-report',
        name: 'bug_report',
        builder: (context, state) => const BugReportPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}