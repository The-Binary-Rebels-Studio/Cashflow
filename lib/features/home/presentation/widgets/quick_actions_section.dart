import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onAddIncome;
  final VoidCallback? onAddExpense;
  final VoidCallback? onTransfer;
  final VoidCallback? onBudget;

  const QuickActionsSection({
    super.key,
    this.onAddIncome,
    this.onAddExpense,
    this.onTransfer,
    this.onBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ActionButton(
              label: 'Add Income',
              icon: Icons.add_circle_outline,
              color: Colors.green,
              onTap: onAddIncome,
            ),
            _ActionButton(
              label: 'Add Expense',
              icon: Icons.remove_circle_outline,
              color: Colors.red,
              onTap: onAddExpense,
            ),
            _ActionButton(
              label: 'Transfer',
              icon: Icons.swap_horiz,
              color: Colors.blue,
              onTap: onTransfer,
            ),
            _ActionButton(
              label: 'Budget',
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
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}