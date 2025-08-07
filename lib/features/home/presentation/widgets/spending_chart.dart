import 'package:flutter/material.dart';

class SpendingChart extends StatelessWidget {
  final List<SpendingCategory> categories;

  const SpendingChart({
    super.key,
    this.categories = const [
      SpendingCategory('Food & Dining', Colors.orange, 'Rp 1.2M'),
      SpendingCategory('Transportation', Colors.blue, 'Rp 800K'),
      SpendingCategory('Shopping', Colors.pink, 'Rp 600K'),
      SpendingCategory('Bills', Colors.purple, 'Rp 450K'),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Chart Placeholder'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categories
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
                category.amount,
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