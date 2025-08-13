import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/core/utils/currency_formatter.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_bloc.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_state.dart';
import 'package:cashflow/features/budget_management/presentation/utils/budget_calculation_utils.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class BudgetOverviewCard extends StatelessWidget {
  const BudgetOverviewCard({super.key});

  // Calculate total spent across all budget plans using Result pattern
  Future<double> _calculateTotalSpent(BuildContext context, BudgetManagementLoaded state) async {
    try {
      final transactionBloc = context.read<TransactionBloc>();
      double totalSpent = 0;

      // Calculate spent amount for each budget plan using budget-specific period
      for (final budget in state.budgetPlans) {
        // Use budget creation date as the period start to ensure only relevant transactions are counted
        final periodStart = BudgetCalculationUtils.calculateBudgetPeriodStart(budget);
        final periodEnd = BudgetCalculationUtils.calculateBudgetPeriodEnd(budget);
        
        debugPrint('🎯 Budget "${budget.name}" period: $periodStart to $periodEnd');
        
        final result = await transactionBloc.transactionUsecases.getTotalByBudgetAndDateRange(
          budget.id,
          periodStart,
          periodEnd,
        );
        
        result.fold(
          onSuccess: (spentInBudget) {
            totalSpent += spentInBudget.abs(); // Add absolute value (expenses are negative)
          },
          onFailure: (failure) {
            debugPrint('🚨 Error calculating spent for budget ${budget.name}: ${failure.message}');
            // Continue with 0 for this budget instead of failing completely
          },
        );
      }

      debugPrint('🎯 TOTAL SPENT CALCULATION: $totalSpent across ${state.budgetPlans.length} budgets');
      return totalSpent;
    } catch (e) {
      debugPrint('🚨 Unexpected error calculating total spent: $e');
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetManagementBloc, BudgetManagementState>(
      builder: (context, state) {
        if (state is! BudgetManagementLoaded) {
          // Loading or error state - show placeholder
          return _buildOverviewCard(context, 0, 0, 0, 0, 0);
        }

        return FutureBuilder<double>(
          future: _calculateTotalSpent(context, state),
          builder: (context, snapshot) {
            // Calculate totals
            final totalBudget = state.budgetPlans.fold(0.0, (sum, budget) => sum + budget.amount);
            final activePlans = state.activeBudgetPlans.length;
            final totalSpent = snapshot.data ?? 0.0;
            final remaining = totalBudget - totalSpent;
            final spentPercentage = totalBudget > 0 ? (totalSpent / totalBudget) : 0.0;

            return _buildOverviewCard(context, totalBudget, totalSpent, remaining, spentPercentage, activePlans);
          },
        );
      },
    );
  }

  Widget _buildOverviewCard(BuildContext context, double totalBudget, double totalSpent, double remaining, double spentPercentage, int activePlans) {
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.budgetOverview,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$activePlans ${AppLocalizations.of(context)!.activePlans}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Total Budget Amount
                BlocBuilder<CurrencyBloc, CurrencyModel>(
                  builder: (context, currency) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.totalBudget,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.formatWithSymbol(totalBudget, currency.symbol, context),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Progress Bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: spentPercentage.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: spentPercentage < 0.8 ? Colors.greenAccent : Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        label: AppLocalizations.of(context)!.spent,
                        value: totalSpent,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _StatItem(
                        label: AppLocalizations.of(context)!.remaining,
                        value: remaining,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyModel>(
      builder: (context, currency) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    CurrencyFormatter.formatWithSymbol(value, currency.symbol, context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}