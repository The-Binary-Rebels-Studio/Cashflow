import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_budget.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';

class TransactionList extends StatefulWidget {
  final String searchQuery;
  final String selectedPeriod;
  final String selectedBudget;
  final String sortBy;
  final DateTime? specificDate;

  const TransactionList({
    super.key,
    required this.searchQuery,
    required this.selectedPeriod,
    required this.selectedBudget,
    required this.sortBy,
    this.specificDate,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<BudgetEntity> _budgets = [];

  @override
  void initState() {
    super.initState();
    _loadBudgets();
    context.read<TransactionBloc>().add(const TransactionDataRequested());
  }

  @override
  void didUpdateWidget(TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.selectedPeriod != widget.selectedPeriod ||
        oldWidget.selectedBudget != widget.selectedBudget ||
        oldWidget.sortBy != widget.sortBy ||
        oldWidget.specificDate != widget.specificDate) {
      context.read<TransactionBloc>().add(const TransactionDataRequested());
    }
  }

  Future<void> _loadBudgets() async {
    try {
      final budgetRepository = GetIt.instance<BudgetManagementRepository>();
      final budgets = await budgetRepository.getAllBudgets();
      setState(() {
        _budgets = budgets;
      });
    } catch (e) {
      debugPrint('Failed to load budgets: $e');
    }
  }

  List<TransactionWithBudget> _filterTransactionsByBudget(
    List<TransactionWithBudget> transactions,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.selectedBudget == l10n.all) return transactions;
    
    // Safely find the selected budget
    final selectedBudget = _budgets.where((budget) => budget.name == widget.selectedBudget).firstOrNull;
    
    if (selectedBudget == null) {
      // If no budget matches the selected name, return all transactions
      // This can happen during loading or if budget data is not yet available
      return transactions;
    }
    
    return transactions.where((transaction) => 
      transaction.transaction.budgetId == selectedBudget.id).toList();
  }

  List<TransactionWithBudget> _filterTransactions(
    List<TransactionWithBudget> transactions,
  ) {
    var filtered = _filterTransactionsByBudget(transactions);
    
    return filtered.where((transaction) {
      bool matchesSearch = widget.searchQuery.isEmpty ||
          transaction.transaction.title.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
          transaction.budget.name.toLowerCase().contains(widget.searchQuery.toLowerCase());
      
      bool matchesPeriod = _matchesPeriodFilter(transaction.transaction.date);
      
      return matchesSearch && matchesPeriod;
    }).toList();
  }

  bool _matchesPeriodFilter(DateTime transactionDate) {
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context)!;
    
    // Check if it's a specific date filter
    if (widget.specificDate != null) {
      final specificDate = DateTime(widget.specificDate!.year, widget.specificDate!.month, widget.specificDate!.day);
      final txDate = DateTime(transactionDate.year, transactionDate.month, transactionDate.day);
      return txDate == specificDate;
    }
    
    if (widget.selectedPeriod == l10n.filterToday) {
      return DateTime(transactionDate.year, transactionDate.month, transactionDate.day) ==
          DateTime(now.year, now.month, now.day);
    } else if (widget.selectedPeriod == l10n.filterThisWeek) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      return transactionDate.isAfter(weekStart) && transactionDate.isBefore(now.add(const Duration(days: 1)));
    } else if (widget.selectedPeriod == l10n.filterThisMonth) {
      return transactionDate.year == now.year && transactionDate.month == now.month;
    } else if (widget.selectedPeriod == l10n.filterThisYear) {
      return transactionDate.year == now.year;
    } else {
      return true;
    }
  }

  List<TransactionGroup> _groupTransactionsByDate(
    List<TransactionWithBudget> transactions,
  ) {
    final sortedTransactions = List<TransactionWithBudget>.from(transactions);
    
    final l10n = AppLocalizations.of(context)!;
    
    if (widget.sortBy == l10n.sortByAmount) {
      sortedTransactions.sort((a, b) => b.transaction.amount.abs().compareTo(a.transaction.amount.abs()));
    } else if (widget.sortBy == l10n.sortByCategory) {
      sortedTransactions.sort((a, b) => a.budget.name.compareTo(b.budget.name));
    } else {
      // Default to date sorting
      sortedTransactions.sort((a, b) => b.transaction.date.compareTo(a.transaction.date));
    }

    final Map<String, List<TransactionWithBudget>> grouped = {};
    
    for (final transaction in sortedTransactions) {
      final dateKey = _formatDateKey(transaction.transaction.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    return grouped.entries.map((entry) => TransactionGroup(
      date: entry.key,
      transactions: entry.value,
    )).toList();
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);
    final l10n = AppLocalizations.of(context)!;

    if (transactionDate == today) {
      return l10n.dateToday;
    } else if (transactionDate == yesterday) {
      return l10n.dateYesterday;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is TransactionError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading transactions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<TransactionBloc>().add(const TransactionDataRequested()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (state is TransactionLoaded) {
          final filteredTransactions = _filterTransactions(state.transactions);
          final groupedTransactions = _groupTransactionsByDate(filteredTransactions);
          
          if (groupedTransactions.isEmpty) {
            return _EmptyState(
              searchQuery: widget.searchQuery,
              selectedBudget: widget.selectedBudget,
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TransactionBloc>().add(const TransactionDataRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final group = groupedTransactions[index];
                return _TransactionGroup(group: group);
              },
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}

class _TransactionGroup extends StatelessWidget {
  final TransactionGroup group;

  const _TransactionGroup({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(
                group.date,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              Text(
                _calculateDayTotal(group.transactions),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _getDayTotalColor(group.transactions),
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Column(
            children: group.transactions
                .map((transaction) => _TransactionTile(transaction: transaction))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _calculateDayTotal(List<TransactionWithBudget> transactions) {
    final total = transactions.fold<double>(0, (sum, item) => sum + item.transaction.amount);
    return GetIt.instance<CurrencyBloc>().formatAmount(total);
  }

  Color _getDayTotalColor(List<TransactionWithBudget> transactions) {
    final total = transactions.fold<double>(0, (sum, item) => sum + item.transaction.amount);
    return total >= 0 ? Colors.green : Colors.red;
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionWithBudget transaction;

  const _TransactionTile({required this.transaction});

  IconData _getTransactionIcon() {
    if (transaction.transaction.type.value == 'income') {
      return Icons.attach_money; // Dollar icon for income
    }
    
    // For expense transactions, use shopping cart as default
    // Could be enhanced later to fetch actual category icons
    return Icons.shopping_cart; // Default expense icon
  }

  Color _getTransactionIconColor() {
    // Always use the transaction type for background color
    return transaction.transaction.type.value == 'income' 
        ? Colors.green    // Green for income
        : Colors.red;     // Red for expenses
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.transaction.amount >= 0;
    final displayAmount = GetIt.instance<CurrencyBloc>().formatAmount(transaction.transaction.amount);
    final transactionIcon = _getTransactionIcon();
    final iconColor = _getTransactionIconColor();
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () => _navigateToDetail(context),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          transactionIcon,
          color: iconColor,
          size: 24,
        ),
      ),
      title: Text(
        transaction.transaction.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        transaction.budget.name,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            displayAmount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${transaction.transaction.date.hour.toString().padLeft(2, '0')}:${transaction.transaction.date.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    context.pushNamed(
      'transaction_detail',
      pathParameters: {
        'transactionId': transaction.transaction.id,
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchQuery;
  final String selectedBudget;

  const _EmptyState({
    required this.searchQuery,
    required this.selectedBudget,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isNotEmpty || selectedBudget != AppLocalizations.of(context)!.all
                  ? Icons.search_off
                  : Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              searchQuery.isNotEmpty || selectedBudget != AppLocalizations.of(context)!.all
                  ? AppLocalizations.of(context)!.noTransactionsFound
                  : l10n.dashboardMoreTransactionsSoon,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty || selectedBudget != AppLocalizations.of(context)!.all
                  ? AppLocalizations.of(context)!.tryAdjustingFilters
                  : AppLocalizations.of(context)!.startAddingTransactions,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionGroup {
  final String date;
  final List<TransactionWithBudget> transactions;

  TransactionGroup({
    required this.date,
    required this.transactions,
  });
}