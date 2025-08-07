import 'package:flutter/material.dart';
import '../widgets/header_section.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_stats_row.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/spending_chart.dart';
import '../widgets/recent_transactions.dart';
import '../../../../core/utils/navigation_helper.dart';

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
                  // TODO: Navigate to add income screen
                },
                onAddExpense: () {
                  // TODO: Navigate to add expense screen
                },
                onBudget: () {
                  // TODO: Navigate to budget screen
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