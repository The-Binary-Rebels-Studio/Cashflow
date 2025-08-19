import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onAddIncome;
  final VoidCallback? onAddExpense;
  final VoidCallback? onBudget;

  const QuickActionsSection({
    super.key,
    this.onAddIncome,
    this.onAddExpense,
    this.onBudget,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            l10n.dashboardQuickActions,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ActionButton(
              label: l10n.dashboardAddIncome,
              icon: Icons.add_circle_outline,
              color: Colors.green,
              onTap: onAddIncome,
            ),
            _ActionButton(
              label: l10n.dashboardAddExpense,
              icon: Icons.remove_circle_outline,
              color: Colors.red,
              onTap: onAddExpense,
            ),
            _ActionButton(
              label: l10n.dashboardBudget,
              icon: Icons.pie_chart_outline,
              color: Colors.purple,
              onTap: onBudget,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            height: 36,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                height: 1.1,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
