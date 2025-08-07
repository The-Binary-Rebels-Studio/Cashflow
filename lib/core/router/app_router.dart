import 'package:go_router/go_router.dart';
import 'package:cashflow/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:cashflow/features/profile/presentation/pages/bug_report_page.dart';
import 'package:cashflow/features/settings/presentation/pages/settings_page.dart';
import 'package:cashflow/shared/widgets/main_navigation.dart';
import 'package:cashflow/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:cashflow/core/di/injection.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Check if we're already on the right path to avoid infinite redirects
      final isOnOnboarding = state.fullPath == '/onboarding';
      
      // Check onboarding status
      final getOnboardingStatus = getIt<GetOnboardingStatus>();
      final status = await getOnboardingStatus();
      final isOnboardingCompleted = status.isCompleted;
      
      // If onboarding is not completed and user is not on onboarding page
      if (!isOnboardingCompleted && !isOnOnboarding) {
        return '/onboarding';
      }
      
      // If onboarding is completed and user is on onboarding page
      if (isOnboardingCompleted && isOnOnboarding) {
        return '/main';
      }
      
      // If user is on root path, redirect based on onboarding status
      if (state.fullPath == '/') {
        return isOnboardingCompleted ? '/main' : '/onboarding';
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainNavigation(initialIndex: 0),
      ),
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