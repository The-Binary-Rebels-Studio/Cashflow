import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/core/utils/currency_formatter.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity_extensions.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/budget_management/presentation/utils/budget_calculation_utils.dart';

class BudgetCategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final List<BudgetEntity> budgets;
  final VoidCallback onTap;

  const BudgetCategoryCard({
    super.key,
    required this.category,
    required this.budgets,
    required this.onTap,
  });

  Future<double> _calculateTotalSpent(BuildContext context) async {
    try {
      final transactionBloc = context.read<TransactionBloc>();
      double totalSpent = 0;

      // Calculate spent amount for each budget in this category
      for (final budget in budgets) {
        final periodStart = BudgetCalculationUtils.calculateBudgetPeriodStart(budget);
        final periodEnd = BudgetCalculationUtils.calculateBudgetPeriodEnd(budget);
        
        final result = await transactionBloc.transactionUsecases.getTotalByBudgetAndDateRange(
          budget.id,
          periodStart,
          periodEnd,
        );
        
        result.fold(
          onSuccess: (spentInBudget) {
            final absSpent = spentInBudget.abs();
            totalSpent += absSpent;
          },
          onFailure: (failure) {
          },
        );
      }

      return totalSpent;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalBudget = budgets.fold<double>(
      0,
      (sum, budget) => sum + budget.amount,
    );

    return FutureBuilder<double>(
      future: _calculateTotalSpent(context),
      builder: (context, snapshot) {
        final totalSpent = snapshot.data ?? 0.0;
        final remaining = totalBudget - totalSpent;
        final spentPercentage = totalBudget > 0 ? (totalSpent / totalBudget) : 0.0;

        return _buildCard(context, totalBudget, totalSpent, remaining, spentPercentage);
      },
    );
  }

  Widget _buildCard(BuildContext context, double totalBudget, double totalSpent, double remaining, double spentPercentage) {
    // Safe parsing of category color
    Color categoryColor;
    try {
      categoryColor = Color(int.parse(category.colorValue));
    } catch (e) {
      categoryColor = Colors.grey;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: categoryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoryColor.withValues(alpha: 0.05),
                categoryColor.withValues(alpha: 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Category Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          categoryColor.withValues(alpha: 0.8),
                          categoryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getIconData(category.iconCodePoint),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Category Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.localizedName(context),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: categoryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getCategoryTypeLabel(category.type),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: categoryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${budgets.length} plan${budgets.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Total Amount
                  BlocBuilder<CurrencyBloc, CurrencyModel>(
                    builder: (context, currency) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.formatWithSymbol(totalBudget, currency.symbol, context),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: category.type == CategoryType.expense 
                                ? Colors.red[600] 
                                : Colors.green[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Budget',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              if (budgets.isNotEmpty) ...[
                const SizedBox(height: 20),
                
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: spentPercentage.clamp(0.0, 1.0),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: spentPercentage < 0.8
                                  ? [Colors.green[400]!, Colors.green[600]!]
                                  : spentPercentage < 0.9
                                    ? [Colors.orange[400]!, Colors.orange[600]!]
                                    : [Colors.red[400]!, Colors.red[600]!],
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(spentPercentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: spentPercentage < 0.8
                          ? Colors.green[600]
                          : spentPercentage < 0.9
                            ? Colors.orange[600]
                            : Colors.red[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Spent vs Remaining
                BlocBuilder<CurrencyBloc, CurrencyModel>(
                  builder: (context, currency) {
                    return Row(
                      children: [
                        Expanded(
                          child: _StatChip(
                            label: 'Spent',
                            amount: CurrencyFormatter.formatWithSymbol(totalSpent, currency.symbol, context),
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatChip(
                            label: 'Remaining',
                            amount: CurrencyFormatter.formatWithSymbol(remaining, currency.symbol, context),
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Budget Plans List
                ...budgets.take(3).map((budget) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: categoryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          budget.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      BlocBuilder<CurrencyBloc, CurrencyModel>(
                        builder: (context, currency) {
                          return Text(
                            CurrencyFormatter.formatWithSymbol(budget.amount, currency.symbol, context),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: categoryColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )),
                
                if (budgets.length > 3) ...[
                  const SizedBox(height: 8),
                  Text(
                    '+${budgets.length - 3} more plans',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryTypeLabel(CategoryType type) {
    switch (type) {
      case CategoryType.income:
        return 'Income';
      case CategoryType.expense:
        return 'Expense';
    }
  }

  IconData _getIconData(String iconCodePoint) {
    try {
      return IconData(
        int.parse(iconCodePoint),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      return Icons.category;
    }
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _StatChip({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}