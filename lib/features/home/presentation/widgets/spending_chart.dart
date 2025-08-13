import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_budget.dart';
import 'package:cashflow/core/utils/currency_formatter.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  // Group expenses by budget and calculate spending vs budget
  List<BudgetSpendingData> _calculateBudgetSpending(List<TransactionWithBudget> expenseTransactions) {
    final Map<String, BudgetSpendingData> budgetMap = {};
    
    for (final txn in expenseTransactions) {
      final budgetId = txn.budget.id;
      final amount = txn.transaction.amount.abs(); // Convert to positive for spending
      
      if (budgetMap.containsKey(budgetId)) {
        budgetMap[budgetId] = budgetMap[budgetId]!.copyWith(
          spent: budgetMap[budgetId]!.spent + amount,
        );
      } else {
        budgetMap[budgetId] = BudgetSpendingData(
          budgetId: budgetId,
          budgetName: txn.budget.name,
          budgetAmount: txn.budget.amount,
          spent: amount,
          color: _getBudgetColor(txn.budget.name),
        );
      }
    }
    
    return budgetMap.values.toList()..sort((a, b) => b.spent.compareTo(a.spent));
  }
  
  Color _getBudgetColor(String budgetName) {
    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.pink,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.teal,
      Colors.indigo,
    ];
    
    // Simple hash to get consistent color for same budget name
    final hash = budgetName.hashCode.abs();
    return colors[hash % colors.length];
  }

  List<PieChartSectionData> _createPieChartSections(List<BudgetSpendingData> budgetData) {
    if (budgetData.isEmpty) return [];
    
    final total = budgetData.fold<double>(0, (sum, data) => sum + data.spent);
    if (total == 0) return [];

    return budgetData.map((data) {
      final percentage = (data.spent / total) * 100;
      
      return PieChartSectionData(
        color: data.color,
        value: percentage,
        title: percentage >= 10 ? '${percentage.toStringAsFixed(0)}%' : '', // Only show percentage if >= 10%
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardSpendingCategories,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoaded) {
                  final budgetSpendingData = _calculateBudgetSpending(state.expenseTransactions);
                  
                  if (budgetSpendingData.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  
                  return Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 120,
                          child: PieChart(
                            PieChartData(
                              sections: _createPieChartSections(budgetSpendingData),
                              centerSpaceRadius: 30,
                              sectionsSpace: 2,
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: budgetSpendingData
                              .take(4) // Show max 4 categories to fit
                              .map((data) => _BudgetSpendingItem(data: data))
                              .toList(),
                        ),
                      ),
                    ],
                  );
                }
                
                return _buildLoadingState();
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No spending data yet',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return const SizedBox(
      height: 120,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _BudgetSpendingItem extends StatelessWidget {
  final BudgetSpendingData data;

  const _BudgetSpendingItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final isOverBudget = data.spent > data.budgetAmount;
    final percentage = data.budgetAmount > 0 ? (data.spent / data.budgetAmount * 100) : 0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: data.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.budgetName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${CurrencyFormatter.formatWithSymbol(data.spent, 'Rp', context)} / ${CurrencyFormatter.formatWithSymbol(data.budgetAmount, 'Rp', context)}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isOverBudget ? Colors.red : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${percentage.toStringAsFixed(0)}% ${isOverBudget ? 'over budget' : 'used'}',
            style: TextStyle(
              fontSize: 9,
              color: isOverBudget ? Colors.red : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetSpendingData {
  final String budgetId;
  final String budgetName;
  final double budgetAmount;
  final double spent;
  final Color color;

  const BudgetSpendingData({
    required this.budgetId,
    required this.budgetName,
    required this.budgetAmount,
    required this.spent,
    required this.color,
  });
  
  BudgetSpendingData copyWith({
    String? budgetId,
    String? budgetName,
    double? budgetAmount,
    double? spent,
    Color? color,
  }) {
    return BudgetSpendingData(
      budgetId: budgetId ?? this.budgetId,
      budgetName: budgetName ?? this.budgetName,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      spent: spent ?? this.spent,
      color: color ?? this.color,
    );
  }
  
  double get percentage => budgetAmount > 0 ? (spent / budgetAmount * 100) : 0;
  bool get isOverBudget => spent > budgetAmount;
}