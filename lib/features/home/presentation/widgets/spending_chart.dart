import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingChart extends StatelessWidget {
  final List<SpendingCategory> categories;

  const SpendingChart({
    super.key,
    this.categories = const [],
  });

  static String _formatCurrency(String amount) {
    final number = int.parse(amount);
    if (number >= 1000000) {
      final millions = number / 1000000;
      return '${millions.toStringAsFixed(millions % 1 == 0 ? 0 : 1)}M';
    } else if (number >= 1000) {
      final thousands = number / 1000;
      return '${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)}K';
    } else {
      return number.toString();
    }
  }

  List<PieChartSectionData> _createPieChartSections(List<SpendingCategory> categories) {
    final total = categories.fold<double>(0, (sum, category) {
      final amount = double.parse(category.amount.replaceAll(RegExp(r'[^\d]'), ''));
      return sum + amount;
    });

    return categories.map((category) {
      final amount = double.parse(category.amount.replaceAll(RegExp(r'[^\d]'), ''));
      final percentage = (amount / total) * 100;
      
      return PieChartSectionData(
        color: category.color,
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 45,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final defaultCategories = [
      SpendingCategory(l10n.dashboardFoodDining, Colors.orange, '1200000'),
      SpendingCategory(l10n.dashboardTransportation, Colors.blue, '800000'),
      SpendingCategory(l10n.dashboardShopping, Colors.pink, '600000'),
      SpendingCategory(l10n.dashboardBills, Colors.purple, '450000'),
    ];
    final displayCategories = categories.isEmpty ? defaultCategories : categories;
    
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
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: PieChart(
                      PieChartData(
                        sections: _createPieChartSections(displayCategories),
                        centerSpaceRadius: 30,
                        sectionsSpace: 2,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayCategories
                      .map((category) => _CategoryItem(category: category))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final SpendingCategory category;

  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.label,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Rp ${SpendingChart._formatCurrency(category.amount)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpendingCategory {
  final String label;
  final Color color;
  final String amount;

  const SpendingCategory(this.label, this.color, this.amount);
}