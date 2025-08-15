import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/core/utils/currency_formatter.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity_extensions.dart';
import 'package:cashflow/features/budget_management/data/models/budget_model.dart';
import 'package:cashflow/features/budget_management/presentation/utils/budget_calculation_utils.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class BudgetPlanItem extends StatelessWidget {
  final BudgetEntity budget;
  final CategoryEntity? category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BudgetPlanItem({
    super.key,
    required this.budget,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  
  Future<double> _calculateSpentAmount(BuildContext context) async {
    try {
      final transactionBloc = context.read<TransactionBloc>();
      
      
      final periodStart = BudgetCalculationUtils.calculateBudgetPeriodStart(budget);
      final periodEnd = BudgetCalculationUtils.calculateBudgetPeriodEnd(budget);
      
      
      final result = await transactionBloc.transactionUsecases.getTotalByBudgetAndDateRange(
        budget.id,
        periodStart,
        periodEnd,
      );
      
      return result.when(
        success: (totalSpent) {
          
          
          
          return totalSpent.abs();
        },
        failure: (failure) {
          
          
          return 0.0;
        },
      );
    } catch (e) {
      
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      key: Key('budget_${budget.id}_${DateTime.now().millisecondsSinceEpoch}'), 
      future: _calculateSpentAmount(context),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Loading ${budget.name}...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final totalSpent = snapshot.data ?? 0.0;
        final remaining = budget.amount - totalSpent;
        final spentPercentage = budget.amount > 0 ? (totalSpent / budget.amount) : 0.0;
    
    
    Color categoryColor;
    if (category != null) {
      try {
        categoryColor = Color(int.parse(category!.colorValue));
      } catch (e) {
        categoryColor = Colors.grey;
      }
    } else {
      categoryColor = Colors.grey;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        categoryColor.withValues(alpha: 0.8),
                        categoryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    category != null 
                      ? _getIconData(category!.iconCodePoint)
                      : Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (category != null)
                        Text(
                          category!.localizedName(context),
                          style: TextStyle(
                            fontSize: 14,
                            color: categoryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (budget.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          budget.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BlocBuilder<CurrencyBloc, CurrencyModel>(
                      builder: (context, currency) {
                        return Text(
                          CurrencyFormatter.formatWithSymbol(budget.amount, currency.symbol, context),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: category?.type == CategoryType.expense 
                              ? Colors.red[600] 
                              : Colors.green[600],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)!.edit),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.progress,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                      const SizedBox(height: 8),
                      Container(
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
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            
            BlocBuilder<CurrencyBloc, CurrencyModel>(
              builder: (context, currency) {
                return Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        label: AppLocalizations.of(context)!.spent,
                        amount: CurrencyFormatter.formatWithSymbol(totalSpent, currency.symbol, context),
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatItem(
                        label: AppLocalizations.of(context)!.remaining,
                        amount: CurrencyFormatter.formatWithSymbol(remaining, currency.symbol, context),
                        color: Colors.green,
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            
            Row(
              children: [
                _InfoTag(
                  icon: Icons.schedule_outlined,
                  text: budget.period.localizedDisplayName(context),
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                _InfoTag(
                  icon: Icons.calendar_today_outlined,
                  text: _formatPeriodDisplay(budget),
                  color: Colors.purple,
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


  
  String _formatPeriodDisplay(BudgetEntity budget) {
    final budgetModel = BudgetModel.fromEntity(budget);
    final currentPeriodStart = budgetModel.getCurrentPeriodStart();
    
    switch (budget.period) {
      case BudgetPeriod.weekly:
        return _getWeekRange(currentPeriodStart);
      case BudgetPeriod.monthly:
        return '${_getMonthName(currentPeriodStart)} ${currentPeriodStart.year}';
      case BudgetPeriod.quarterly:
        return '${_getQuarterName(currentPeriodStart)} ${currentPeriodStart.year}';
      case BudgetPeriod.yearly:
        return 'Tahun ${currentPeriodStart.year}';
    }
  }
  
  String _getMonthName(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[date.month];
  }
  
  String _getQuarterName(DateTime date) {
    final quarter = ((date.month - 1) ~/ 3) + 1;
    return 'Q$quarter';
  }
  
  String _getWeekRange(DateTime startDate) {
    final endDate = startDate.add(const Duration(days: 6));
    if (startDate.month == endDate.month) {
      return '${startDate.day}-${endDate.day} ${_getMonthName(startDate)}';
    } else {
      return '${startDate.day} ${_getMonthName(startDate)} - ${endDate.day} ${_getMonthName(endDate)}';
    }
  }

  IconData _getIconData(String iconCodePoint) {
    try {
      return IconData(
        int.parse(iconCodePoint),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      return Icons.account_balance_wallet;
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _StatItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
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
          ),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoTag({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}