import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/services/currency_service.dart';

class TransactionList extends StatefulWidget {
  final String searchQuery;
  final String selectedPeriod;
  final String selectedCategory;
  final String sortBy;

  const TransactionList({
    super.key,
    required this.searchQuery,
    required this.selectedPeriod,
    required this.selectedCategory,
    required this.sortBy,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<TransactionGroup> _transactionGroups = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void didUpdateWidget(TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.selectedPeriod != widget.selectedPeriod ||
        oldWidget.selectedCategory != widget.selectedCategory ||
        oldWidget.sortBy != widget.sortBy) {
      _loadTransactions();
    }
  }

  void _loadTransactions() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final mockTransactions = _generateMockTransactions();
      final filteredTransactions = _filterTransactions(mockTransactions);
      final groupedTransactions = _groupTransactionsByDate(filteredTransactions);
      
      setState(() {
        _transactionGroups = groupedTransactions;
        _isLoading = false;
      });
    });
  }

  List<TransactionItem> _generateMockTransactions() {
    return [
      TransactionItem(
        id: '1',
        title: 'Starbucks Coffee',
        category: 'Food & Dining',
        amount: -45000,
        date: DateTime.now(),
        icon: Icons.local_cafe,
        color: Colors.orange,
      ),
      TransactionItem(
        id: '2',
        title: 'Grab Transport',
        category: 'Transportation',
        amount: -25000,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        icon: Icons.directions_car,
        color: Colors.blue,
      ),
      TransactionItem(
        id: '3',
        title: 'Salary Deposit',
        category: 'Income',
        amount: 8500000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        icon: Icons.account_balance_wallet,
        color: Colors.green,
      ),
      TransactionItem(
        id: '4',
        title: 'Grocery Shopping',
        category: 'Shopping',
        amount: -150000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        icon: Icons.shopping_cart,
        color: Colors.purple,
      ),
      TransactionItem(
        id: '5',
        title: 'Netflix Subscription',
        category: 'Bills',
        amount: -199000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        icon: Icons.subscriptions,
        color: Colors.red,
      ),
      TransactionItem(
        id: '6',
        title: 'Freelance Payment',
        category: 'Income',
        amount: 2500000,
        date: DateTime.now().subtract(const Duration(days: 3)),
        icon: Icons.work,
        color: Colors.green,
      ),
    ];
  }

  List<TransactionItem> _filterTransactions(List<TransactionItem> transactions) {
    return transactions.where((transaction) {
      bool matchesSearch = widget.searchQuery.isEmpty ||
          transaction.title.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
          transaction.category.toLowerCase().contains(widget.searchQuery.toLowerCase());
      
      bool matchesCategory = widget.selectedCategory == 'All' ||
          transaction.category == widget.selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<TransactionGroup> _groupTransactionsByDate(List<TransactionItem> transactions) {
    final sortedTransactions = List<TransactionItem>.from(transactions);
    
    switch (widget.sortBy) {
      case 'Amount':
        sortedTransactions.sort((a, b) => b.amount.abs().compareTo(a.amount.abs()));
        break;
      case 'Category':
        sortedTransactions.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'Date':
      default:
        sortedTransactions.sort((a, b) => b.date.compareTo(a.date));
    }

    final Map<String, List<TransactionItem>> grouped = {};
    
    for (final transaction in sortedTransactions) {
      final dateKey = _formatDateKey(transaction.date);
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

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_transactionGroups.isEmpty) {
      return _EmptyState(
        searchQuery: widget.searchQuery,
        selectedCategory: widget.selectedCategory,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadTransactions();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _transactionGroups.length,
        itemBuilder: (context, index) {
          final group = _transactionGroups[index];
          return _TransactionGroup(group: group);
        },
      ),
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

  String _calculateDayTotal(List<TransactionItem> transactions) {
    final total = transactions.fold<double>(0, (sum, item) => sum + item.amount);
    return GetIt.instance<CurrencyService>().formatAmount(total);
  }

  Color _getDayTotalColor(List<TransactionItem> transactions) {
    final total = transactions.fold<double>(0, (sum, item) => sum + item.amount);
    return total >= 0 ? Colors.green : Colors.red;
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionItem transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount >= 0;
    final displayAmount = GetIt.instance<CurrencyService>().formatAmount(transaction.amount);
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: transaction.color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          transaction.icon,
          color: transaction.color,
          size: 24,
        ),
      ),
      title: Text(
        transaction.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Row(
        children: [
          Text(
            transaction.category,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${transaction.date.hour.toString().padLeft(2, '0')}:${transaction.date.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: Text(
        displayAmount,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isPositive ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;

  const _EmptyState({
    required this.searchQuery,
    required this.selectedCategory,
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
              searchQuery.isNotEmpty || selectedCategory != 'All'
                  ? Icons.search_off
                  : Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              searchQuery.isNotEmpty || selectedCategory != 'All'
                  ? 'No transactions found'
                  : l10n.dashboardMoreTransactionsSoon,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty || selectedCategory != 'All'
                  ? 'Try adjusting your search or filters'
                  : 'Start adding your income and expenses',
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
  final List<TransactionItem> transactions;

  TransactionGroup({
    required this.date,
    required this.transactions,
  });
}

class TransactionItem {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final IconData icon;
  final Color color;

  TransactionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });
}