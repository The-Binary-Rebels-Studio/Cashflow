import 'package:go_router/go_router.dart';
import 'package:cashflow/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:cashflow/features/profile/presentation/pages/bug_report_page.dart';
import 'package:cashflow/features/profile/presentation/pages/feature_request_page.dart';
import 'package:cashflow/features/profile/presentation/pages/privacy_policy_page.dart';
import 'package:cashflow/features/profile/presentation/pages/about_page.dart';
import 'package:cashflow/features/settings/presentation/pages/settings_page.dart';
import 'package:cashflow/features/budget_management/presentation/pages/budget_management_page.dart';
import 'package:cashflow/features/budget_management/presentation/pages/create_budget_page.dart';
import 'package:cashflow/features/transaction/presentation/pages/transaction_detail_page.dart';
import 'package:cashflow/shared/widgets/main_navigation.dart';
import 'package:cashflow/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:cashflow/core/di/injection.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      
      final isOnOnboarding = state.fullPath == '/onboarding';
      
      
      final getOnboardingStatus = getIt<GetOnboardingStatus>();
      final status = await getOnboardingStatus();
      final isOnboardingCompleted = status.isCompleted;
      
      
      if (!isOnboardingCompleted && !isOnOnboarding) {
        return '/onboarding';
      }
      
      
      if (isOnboardingCompleted && isOnOnboarding) {
        return '/main';
      }
      
      
      if (state.fullPath == '/') {
        return isOnboardingCompleted ? '/main' : '/onboarding';
      }
      
      
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
        builder: (context, state) => const BugReportPageWrapper(),
      ),
      GoRoute(
        path: '/feature-request',
        name: 'feature_request',
        builder: (context, state) => const FeatureRequestPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/privacy-policy',
        name: 'privacy_policy',
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/budget-management',
        name: 'budget_management',
        builder: (context, state) => const BudgetManagementPage(),
      ),
      GoRoute(
        path: '/create-budget',
        name: 'create_budget',
        builder: (context, state) {
          final budgetData = state.extra as Map<String, dynamic>?;
          final budget = budgetData?['budget'];
          return CreateBudgetPage(budget: budget);
        },
      ),
      GoRoute(
        path: '/transaction-detail/:transactionId',
        name: 'transaction_detail',
        builder: (context, state) {
          final transactionId = state.pathParameters['transactionId']!;
          return TransactionDetailPage(transactionId: transactionId);
        },
      ),
    ],
  );
}