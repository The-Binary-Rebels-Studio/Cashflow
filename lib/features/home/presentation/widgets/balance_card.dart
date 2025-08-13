import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/core/utils/currency_formatter.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final String? trend;
  final bool isBalanceVisible;
  final VoidCallback onVisibilityToggle;

  const BalanceCard({
    super.key,
    required this.balance,
    this.trend,
    this.isBalanceVisible = true,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.dashboardTotalBalance,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              IconButton(
                onPressed: onVisibilityToggle,
                icon: Icon(
                  isBalanceVisible 
                    ? Icons.visibility_outlined 
                    : Icons.visibility_off_outlined
                ),
                color: Colors.white70,
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<CurrencyBloc, CurrencyModel>(
            builder: (context, currency) {
              final formattedBalance = isBalanceVisible 
                ? CurrencyFormatter.formatWithSymbol(balance, currency.symbol, context, useHomeFormat: true)
                : '****';
              return Text(
                formattedBalance,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          if (isBalanceVisible && trend != null)
            Row(
              children: [
                Icon(
                  balance >= 0 ? Icons.trending_up : Icons.trending_down, 
                  color: balance >= 0 ? Colors.greenAccent : Colors.redAccent, 
                  size: 16
                ),
                const SizedBox(width: 4),
                Text(
                  trend!,
                  style: TextStyle(
                    color: balance >= 0 ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
}