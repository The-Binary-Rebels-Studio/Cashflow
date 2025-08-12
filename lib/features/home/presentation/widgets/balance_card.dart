import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/models/currency_model.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final String trend;
  final bool isBalanceVisible;
  final VoidCallback onVisibilityToggle;

  const BalanceCard({
    super.key,
    this.balance = 'Rp 15,750,000',
    this.trend = '+12.5% from last month',
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
                ? '${currency.symbol} 15,750,000' // TODO: Use real balance data
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
          if (isBalanceVisible)
            Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  l10n.dashboardTrendFromLastMonth,
                  style: const TextStyle(
                    color: Colors.greenAccent,
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