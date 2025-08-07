import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class RecentTransactions extends StatelessWidget {
  final List<TransactionItem> transactions;
  final VoidCallback? onSeeAll;

  const RecentTransactions({
    super.key,
    this.transactions = const [],
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final defaultTransactions = [
      TransactionItem(
        title: l10n.dashboardStarbucksCoffee,
        category: l10n.dashboardFoodDining,
        amount: '-Rp 45,000',
        icon: Icons.local_cafe,
        color: Colors.orange,
      ),
      TransactionItem(
        title: l10n.dashboardGrabTransport,
        category: l10n.dashboardTransportation,
        amount: '-Rp 25,000',
        icon: Icons.directions_car,
        color: Colors.blue,
      ),
      TransactionItem(
        title: l10n.dashboardSalaryDeposit,
        category: l10n.dashboardIncome,
        amount: '+Rp 8,500,000',
        icon: Icons.account_balance_wallet,
        color: Colors.green,
      ),
    ];
    final displayTransactions = transactions.isEmpty ? defaultTransactions : transactions;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.dashboardRecentTransactions,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(l10n.dashboardSeeAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...displayTransactions.map((transaction) => _TransactionTile(
              transaction: transaction,
            )),
            const SizedBox(height: 16),
            _EmptyState(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionItem transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.category,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: transaction.amount.startsWith('+') 
                  ? Colors.green 
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  
  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.dashboardMoreTransactionsSoon,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionItem {
  final String title;
  final String category;
  final String amount;
  final IconData icon;
  final Color color;

  const TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.icon,
    required this.color,
  });
}