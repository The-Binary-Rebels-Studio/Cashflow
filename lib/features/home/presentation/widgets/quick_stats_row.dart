import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/core/utils/currency_formatter.dart';

class QuickStatsRow extends StatelessWidget {
  final double income;
  final double expenses;

  const QuickStatsRow({
    super.key,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<CurrencyBloc, CurrencyModel>(
      builder: (context, currency) {
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                title: l10n.dashboardIncome,
                amount: CurrencyFormatter.formatWithSymbol(income, currency.symbol, context, useHomeFormat: true),
                icon: Icons.trending_up,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                title: l10n.dashboardExpenses,
                amount: CurrencyFormatter.formatWithSymbol(expenses, currency.symbol, context, useHomeFormat: true),
                icon: Icons.trending_down,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
  
}

class _StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}