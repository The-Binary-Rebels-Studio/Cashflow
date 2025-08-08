// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/core/localization/locale_manager.dart';
import 'package:cashflow/core/services/currency_service.dart';
import 'package:cashflow/features/category/presentation/cubit/category_cubit.dart';
import 'package:cashflow/features/financial/presentation/cubit/budget_management_cubit.dart';

import 'package:cashflow/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Setup dependencies
    await configureDependencies();
    
    // Build our app and trigger a frame.
    final localeManager = getIt<LocaleManager>();
    final currencyService = getIt<CurrencyService>();
    await currencyService.initializeService();
    
    final categoryCubit = getIt<CategoryCubit>();
    await categoryCubit.initializeCategories();
    
    final budgetManagementCubit = getIt<BudgetManagementCubit>();
    await budgetManagementCubit.initializeBudgetManagement();
    
    await tester.pumpWidget(CashFlowApp(
      localeManager: localeManager,
      currencyService: currencyService,
      categoryCubit: categoryCubit,
      budgetManagementCubit: budgetManagementCubit,
    ));

    // Verify that the onboarding screen loads.
    expect(find.text('Welcome to CashFlow'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
