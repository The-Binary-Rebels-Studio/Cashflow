import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/services/currency_service.dart';

class TransactionHeader extends StatelessWidget {
  final bool isSearching;
  final String searchQuery;
  final String selectedPeriod;
  final String selectedCategory;
  final String sortBy;
  final List<String> periods;
  final List<String> categories;
  final List<String> sortOptions;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSortChanged;

  const TransactionHeader({
    super.key,
    required this.isSearching,
    required this.searchQuery,
    required this.selectedPeriod,
    required this.selectedCategory,
    required this.sortBy,
    required this.periods,
    required this.categories,
    required this.sortOptions,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onPeriodChanged,
    required this.onCategoryChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildTopSection(context, l10n),
          if (!isSearching) _buildSummaryCards(context, l10n),
          _buildFilterSection(context, l10n),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (!isSearching) ...[
            Expanded(
              child: Text(
                l10n.dashboardRecentTransactions,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: onSearchToggle,
              icon: const Icon(Icons.search),
            ),
          ] else ...[
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: onSearchChanged,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onSearchToggle,
              icon: const Icon(Icons.close),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: l10n.dashboardIncome,
              amount: GetIt.instance<CurrencyService>().formatAmount(8500000),
              color: Colors.green,
              icon: Icons.trending_up,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: 'Expense',
              amount: GetIt.instance<CurrencyService>().formatAmount(-2750000),
              color: Colors.red,
              icon: Icons.trending_down,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: 'Balance',
              amount: GetIt.instance<CurrencyService>().formatAmount(5750000),
              color: Colors.blue,
              icon: Icons.account_balance_wallet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _FilterChip(
                  label: selectedPeriod,
                  icon: Icons.calendar_today,
                  onTap: () => _showPeriodSelector(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterChip(
                  label: selectedCategory,
                  icon: Icons.category,
                  onTap: () => _showCategorySelector(context),
                ),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: sortBy,
                icon: Icons.sort,
                onTap: () => _showSortSelector(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPeriodSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSelectorSheet(
        'Select Period',
        periods,
        selectedPeriod,
        onPeriodChanged,
      ),
    );
  }

  void _showCategorySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSelectorSheet(
        'Select Category',
        categories,
        selectedCategory,
        onCategoryChanged,
      ),
    );
  }

  void _showSortSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSelectorSheet(
        'Sort By',
        sortOptions,
        sortBy,
        onSortChanged,
      ),
    );
  }

  Widget _buildSelectorSheet(
    String title,
    List<String> options,
    String selected,
    ValueChanged<String> onChanged,
  ) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...options.map((option) => ListTile(
              title: Text(option),
              trailing: selected == option ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                onChanged(option);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}