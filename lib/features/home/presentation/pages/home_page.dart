import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/core/constants/app_constants.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/core/services/simple_analytics_service.dart';
import 'package:cashflow/features/home/presentation/widgets/header_section.dart';
import 'package:cashflow/features/home/presentation/widgets/balance_card.dart';
import 'package:cashflow/features/home/presentation/widgets/quick_stats_row.dart';
import 'package:cashflow/features/home/presentation/widgets/quick_actions_section.dart';
import 'package:cashflow/features/home/presentation/widgets/spending_chart.dart';
import 'package:cashflow/features/home/presentation/widgets/recent_transactions.dart';
import 'package:cashflow/core/utils/navigation_helper.dart';
import 'package:cashflow/features/transaction/presentation/pages/add_transaction_page.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_budget.dart';
import 'package:cashflow/shared/widgets/banner_ad_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;
  late final SimpleAnalyticsService _analyticsService;
  DateTime? _screenStartTime;

  @override
  void initState() {
    super.initState();
    _analyticsService = getIt<SimpleAnalyticsService>();
    _screenStartTime = DateTime.now();

    context.read<TransactionBloc>().add(const TransactionDataRequested());

    // Log screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _analyticsService.logScreenView('home_page');
      _analyticsService.logAppOpen();
    });
  }

  @override
  void dispose() {
    // Log time spent on screen
    if (_screenStartTime != null) {
      final timeSpent = DateTime.now().difference(_screenStartTime!).inSeconds;
      _analyticsService.logScreenTimeSpent('home_page', timeSpent);
    }
    super.dispose();
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });

    // Analytics tracking
    _analyticsService.logButtonPress('toggle_balance_visibility', 'home_page');

    _analyticsService.logFeatureUsage('balance_visibility_toggle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const SizedBox(height: 24),
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  return BalanceCard(
                    balance: state is TransactionLoaded ? state.balance : 0.0,
                    isBalanceVisible: _isBalanceVisible,
                    onVisibilityToggle: _toggleBalanceVisibility,
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  return QuickStatsRow(
                    income: state is TransactionLoaded
                        ? state.totalIncome
                        : 0.0,
                    expenses: state is TransactionLoaded
                        ? state.totalExpense
                        : 0.0,
                  );
                },
              ),
              BannerAdWidget(),
              QuickActionsSection(
                onAddIncome: () {
                  _analyticsService.logButtonPress('add_income', 'home_page');
                  _analyticsService.logNavigation(
                    'home_page',
                    'add_transaction_income',
                  );
                  _analyticsService.logFeatureUsage('quick_add_income');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionPage(
                        initialType: TransactionType.income,
                      ),
                    ),
                  );
                },
                onAddExpense: () {
                  _analyticsService.logButtonPress('add_expense', 'home_page');
                  _analyticsService.logNavigation(
                    'home_page',
                    'add_transaction_expense',
                  );
                  _analyticsService.logFeatureUsage('quick_add_expense');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionPage(
                        initialType: TransactionType.expense,
                      ),
                    ),
                  );
                },
                onBudget: () {
                  _analyticsService.logButtonPress(
                    'budget_management',
                    'home_page',
                  );
                  _analyticsService.logNavigation(
                    'home_page',
                    'budget_management',
                  );
                  _analyticsService.logFeatureUsage('budget_access');
                  context.push(AppConstants.budgetManagementRoute);
                },
              ),
              const SizedBox(height: 24),
              const SpendingChart(),
              const SizedBox(height: 24),

              const BannerAdWidget(
                maxHeight: 90,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              const SizedBox(height: 16),
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  final transactions = state is TransactionLoaded
                      ? state.transactions.take(6).toList()
                      : <TransactionWithBudget>[];

                  return RecentTransactions(
                    transactions: transactions,
                    onSeeAll: () {
                      _analyticsService.logButtonPress(
                        'see_all_transactions',
                        'home_page',
                      );
                      _analyticsService.logNavigation(
                        'home_page',
                        'transaction_list',
                      );
                      _analyticsService.logFeatureUsage(
                        'view_all_transactions',
                      );
                      NavigationHelper.navigateToTransactions(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
