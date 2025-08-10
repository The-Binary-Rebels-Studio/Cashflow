import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/core/constants/app_constants.dart';
import 'package:cashflow/features/home/presentation/widgets/header_section.dart';
import 'package:cashflow/features/home/presentation/widgets/balance_card.dart';
import 'package:cashflow/features/home/presentation/widgets/quick_stats_row.dart';
import 'package:cashflow/features/home/presentation/widgets/quick_actions_section.dart';
import 'package:cashflow/features/home/presentation/widgets/spending_chart.dart';
import 'package:cashflow/features/home/presentation/widgets/recent_transactions.dart';
import 'package:cashflow/core/utils/navigation_helper.dart';
import 'package:cashflow/features/transaction/presentation/pages/add_transaction_page.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
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
              BalanceCard(
                isBalanceVisible: _isBalanceVisible,
                onVisibilityToggle: _toggleBalanceVisibility,
              ),
              const SizedBox(height: 24),
              const QuickStatsRow(),
              const SizedBox(height: 24),
              QuickActionsSection(
                onAddIncome: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionPage(
                        initialType: TransactionType.income,
                      ),
                    ),
                  );
                },
                onAddExpense: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionPage(
                        initialType: TransactionType.expense,
                      ),
                    ),
                  );
                },
                onBudget: () {
                  context.push(AppConstants.budgetManagementRoute);
                },
              ),
              const SizedBox(height: 24),
              const SpendingChart(),
              const SizedBox(height: 24),
              RecentTransactions(
                onSeeAll: () {
                  NavigationHelper.navigateToTransactions(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}