import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/core/services/currency_service.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/features/budget_management/presentation/cubit/budget_management_cubit.dart';
import 'package:cashflow/features/budget_management/presentation/cubit/budget_management_state.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class BudgetOverviewCard extends StatelessWidget {
  const BudgetOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetManagementCubit, BudgetManagementState>(
      builder: (context, state) {
        // Calculate totals
        double totalBudget = 0;
        double totalSpent = 0; // TODO: Calculate from actual transactions
        int activePlans = 0;
        
        if (state is BudgetManagementLoaded) {
          totalBudget = state.budgetPlans.fold(0, (sum, budget) => sum + budget.amount);
          activePlans = state.activeBudgetPlans.length;
        }
        
        final remaining = totalBudget - totalSpent;
        final spentPercentage = totalBudget > 0 ? (totalSpent / totalBudget) : 0.0;
        
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
                BlocBuilder<CurrencyService, CurrencyModel>(
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
                          '${currency.symbol}${totalBudget.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
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
      },
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
    return BlocBuilder<CurrencyService, CurrencyModel>(
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
                    '${currency.symbol}${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
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