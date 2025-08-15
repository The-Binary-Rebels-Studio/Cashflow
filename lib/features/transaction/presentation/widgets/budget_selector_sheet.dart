import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';
import 'package:cashflow/features/budget_management/presentation/utils/budget_calculation_utils.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';

class BudgetSelectorSheet extends StatefulWidget {
  final BuildContext parentContext; 
  final List<String> budgets;
  final String selectedBudget;
  final ValueChanged<String> onBudgetChanged;
  final VoidCallback? onBudgetsRefreshed;

  const BudgetSelectorSheet({
    super.key,
    required this.parentContext,
    required this.budgets,
    required this.selectedBudget,
    required this.onBudgetChanged,
    this.onBudgetsRefreshed,
  });

  @override
  State<BudgetSelectorSheet> createState() => _BudgetSelectorSheetState();
}

class _BudgetSelectorSheetState extends State<BudgetSelectorSheet> {
  late TextEditingController _searchController;
  late List<String> _filteredBudgets;
  List<BudgetEntity> _budgetEntities = [];
  List<CategoryEntity> _categoryEntities = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredBudgets = widget.budgets;
    _loadBudgetDetails();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadBudgetDetails() async {
    try {
      final budgetRepository = GetIt.instance<BudgetManagementRepository>();
      final budgets = await budgetRepository.getAllBudgets();
      final categories = await budgetRepository.getAllCategories();

      setState(() {
        _budgetEntities = budgets;
        _categoryEntities = categories;
      });

      
      widget.onBudgetsRefreshed?.call();
    } catch (e) {
      
    }
  }

  BudgetEntity? _getBudgetEntity(String budgetName) {
    final l10n = AppLocalizations.of(context)!;
    if (budgetName == l10n.all) return null;
    try {
      return _budgetEntities.firstWhere((b) => b.name == budgetName);
    } catch (e) {
      return null;
    }
  }

  CategoryEntity? _getCategoryForBudget(BudgetEntity budget) {
    try {
      return _categoryEntities.firstWhere((c) => c.id == budget.categoryId);
    } catch (e) {
      return null;
    }
  }

  IconData _getBudgetIcon(BudgetEntity? budget) {
    if (budget == null) return Icons.dashboard;

    final category = _getCategoryForBudget(budget);
    if (category == null) {
      
      return _getFallbackIconByName(budget.name);
    }

    const iconMap = {
      '57411': Icons.restaurant,
      '57669': Icons.directions_car,
      '59511': Icons.shopping_cart,
      '57699': Icons.receipt,
      '57458': Icons.movie,
      '57704': Icons.local_hospital,
      '57437': Icons.school,
      '58730': Icons.account_balance_wallet,
    };
    
    return iconMap[category.iconCodePoint] ?? _getFallbackIconByCategory(category.name);
  }

  IconData _getFallbackIconByName(String budgetName) {
    final name = budgetName.toLowerCase();

    
    if (name.contains('makanan') ||
        name.contains('food') ||
        name.contains('makan') ||
        name.contains('restoran') ||
        name.contains('coffee') ||
        name.contains('cafe')) {
      return Icons.restaurant;
    }
    
    else if (name.contains('transport') ||
        name.contains('bensin') ||
        name.contains('fuel') ||
        name.contains('uber') ||
        name.contains('grab') ||
        name.contains('ojek') ||
        name.contains('travel') ||
        name.contains('perjalanan')) {
      return Icons.directions_car;
    }
    
    else if (name.contains('belanja') ||
        name.contains('shopping') ||
        name.contains('retail') ||
        name.contains('pakaian') ||
        name.contains('fashion') ||
        name.contains('elektronik')) {
      return Icons.shopping_cart;
    }
    
    else if (name.contains('tagihan') ||
        name.contains('listrik') ||
        name.contains('air') ||
        name.contains('internet') ||
        name.contains('telepon') ||
        name.contains('bill') ||
        name.contains('utilities')) {
      return Icons.receipt;
    }
    
    else if (name.contains('hiburan') ||
        name.contains('entertainment') ||
        name.contains('movie') ||
        name.contains('game') ||
        name.contains('netflix') ||
        name.contains('spotify')) {
      return Icons.movie;
    }
    
    else if (name.contains('kesehatan') ||
        name.contains('health') ||
        name.contains('medical') ||
        name.contains('dokter') ||
        name.contains('obat') ||
        name.contains('hospital')) {
      return Icons.local_hospital;
    }
    
    else if (name.contains('pendidikan') ||
        name.contains('education') ||
        name.contains('sekolah') ||
        name.contains('kursus') ||
        name.contains('buku') ||
        name.contains('course')) {
      return Icons.school;
    }
    
    else if (name.contains('gaji') ||
        name.contains('salary') ||
        name.contains('income') ||
        name.contains('pendapatan') ||
        name.contains('bonus')) {
      return Icons.account_balance_wallet;
    }
    
    else if (name.contains('tabungan') ||
        name.contains('saving') ||
        name.contains('investasi') ||
        name.contains('investment') ||
        name.contains('deposito')) {
      return Icons.savings;
    }
    
    else if (name.contains('rumah') ||
        name.contains('home') ||
        name.contains('family') ||
        name.contains('keluarga')) {
      return Icons.home;
    }
    
    else {
      return Icons.account_balance_wallet;
    }
  }

  IconData _getFallbackIconByCategory(String categoryName) {
    final name = categoryName.toLowerCase();

    
    if (name.contains('food') ||
        name.contains('dining') ||
        name.contains('makanan')) {
      return Icons.restaurant;
    } else if (name.contains('transport') || name.contains('travel')) {
      return Icons.directions_car;
    } else if (name.contains('shopping') ||
        name.contains('retail') ||
        name.contains('belanja')) {
      return Icons.shopping_cart;
    } else if (name.contains('bills') ||
        name.contains('utilities') ||
        name.contains('tagihan')) {
      return Icons.receipt;
    } else if (name.contains('entertainment') || name.contains('hiburan')) {
      return Icons.movie;
    } else if (name.contains('health') ||
        name.contains('medical') ||
        name.contains('kesehatan')) {
      return Icons.local_hospital;
    } else if (name.contains('education') || name.contains('pendidikan')) {
      return Icons.school;
    } else if (name.contains('income') || name.contains('pendapatan')) {
      return Icons.account_balance_wallet;
    } else if (name.contains('saving') ||
        name.contains('tabungan') ||
        name.contains('investment')) {
      return Icons.savings;
    } else if (name.contains('home') || name.contains('rumah')) {
      return Icons.home;
    } else {
      return Icons.account_balance_wallet; 
    }
  }

  Color _getBudgetColor(BudgetEntity? budget) {
    if (budget == null) return Colors.blue;

    final category = _getCategoryForBudget(budget);
    if (category == null) {
      
      return _getFallbackColorByName(budget.name);
    }

    try {
      
      return Color(
        int.parse('0xFF${category.colorValue.replaceFirst('#', '')}'),
      );
    } catch (e) {
      
      return _getFallbackColorByCategory(category.name);
    }
  }

  Color _getFallbackColorByName(String budgetName) {
    final name = budgetName.toLowerCase();

    
    if (name.contains('makanan') ||
        name.contains('food') ||
        name.contains('makan') ||
        name.contains('restoran') ||
        name.contains('coffee') ||
        name.contains('cafe')) {
      return Colors.orange;
    }
    
    else if (name.contains('transport') ||
        name.contains('bensin') ||
        name.contains('fuel') ||
        name.contains('uber') ||
        name.contains('grab') ||
        name.contains('ojek') ||
        name.contains('travel') ||
        name.contains('perjalanan')) {
      return Colors.blue;
    }
    
    else if (name.contains('belanja') ||
        name.contains('shopping') ||
        name.contains('retail') ||
        name.contains('pakaian') ||
        name.contains('fashion') ||
        name.contains('elektronik')) {
      return Colors.purple;
    }
    
    else if (name.contains('tagihan') ||
        name.contains('listrik') ||
        name.contains('air') ||
        name.contains('internet') ||
        name.contains('telepon') ||
        name.contains('bill') ||
        name.contains('utilities')) {
      return Colors.red;
    }
    
    else if (name.contains('hiburan') ||
        name.contains('entertainment') ||
        name.contains('movie') ||
        name.contains('game') ||
        name.contains('netflix') ||
        name.contains('spotify')) {
      return Colors.pink;
    }
    
    else if (name.contains('kesehatan') ||
        name.contains('health') ||
        name.contains('medical') ||
        name.contains('dokter') ||
        name.contains('obat') ||
        name.contains('hospital')) {
      return Colors.teal;
    }
    
    else if (name.contains('pendidikan') ||
        name.contains('education') ||
        name.contains('sekolah') ||
        name.contains('kursus') ||
        name.contains('buku') ||
        name.contains('course')) {
      return Colors.indigo;
    }
    
    else if (name.contains('gaji') ||
        name.contains('salary') ||
        name.contains('income') ||
        name.contains('pendapatan') ||
        name.contains('bonus')) {
      return Colors.green;
    }
    
    else if (name.contains('tabungan') ||
        name.contains('saving') ||
        name.contains('investasi') ||
        name.contains('investment') ||
        name.contains('deposito')) {
      return Colors.cyan;
    }
    
    else {
      return Colors.grey;
    }
  }

  Color _getFallbackColorByCategory(String categoryName) {
    final name = categoryName.toLowerCase();

    
    if (name.contains('food') ||
        name.contains('dining') ||
        name.contains('makanan')) {
      return Colors.orange;
    } else if (name.contains('transport') || name.contains('travel')) {
      return Colors.blue;
    } else if (name.contains('shopping') ||
        name.contains('retail') ||
        name.contains('belanja')) {
      return Colors.purple;
    } else if (name.contains('bills') ||
        name.contains('utilities') ||
        name.contains('tagihan')) {
      return Colors.red;
    } else if (name.contains('entertainment') || name.contains('hiburan')) {
      return Colors.pink;
    } else if (name.contains('health') ||
        name.contains('medical') ||
        name.contains('kesehatan')) {
      return Colors.teal;
    } else if (name.contains('education') || name.contains('pendidikan')) {
      return Colors.indigo;
    } else if (name.contains('income') || name.contains('pendapatan')) {
      return Colors.green;
    } else if (name.contains('saving') ||
        name.contains('tabungan') ||
        name.contains('investment')) {
      return Colors.cyan;
    } else {
      return Colors.green; 
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        if (query.isEmpty) {
          _filteredBudgets = widget.budgets;
        } else {
          _filteredBudgets = widget.budgets.where((budget) {
            if (budget.toLowerCase().contains(query.toLowerCase())) {
              return true;
            }
            
            final budgetEntity = _getBudgetEntity(budget);
            if (budgetEntity != null) {
              return budgetEntity.description.toLowerCase().contains(
                query.toLowerCase(),
              );
            }
            return false;
          }).toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.selectBudget,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchBudgets,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),

          
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                AppLocalizations.of(context)!.budgetCount(_filteredBudgets.length, widget.budgets.length),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          
          Flexible(
            child: _filteredBudgets.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredBudgets.length,
                    itemBuilder: (context, index) {
                      final budget = _filteredBudgets[index];
                      final isSelected = widget.selectedBudget == budget;
                      final isAllOption =
                          budget == AppLocalizations.of(context)!.all;
                      final budgetEntity = _getBudgetEntity(budget);

                      return _BudgetTile(
                        key: Key('budget_tile_$budget'),
                        parentContext:
                            widget.parentContext, 
                        budget: budget,
                        budgetEntity: budgetEntity,
                        isSelected: isSelected,
                        isAllOption: isAllOption,
                        budgetIcon: _getBudgetIcon(budgetEntity),
                        budgetColor: _getBudgetColor(budgetEntity),
                        onTap: () {
                          widget.onBudgetChanged(budget);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noBudgetsFound,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.tryAdjustingSearchTerm,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
              child: Text(AppLocalizations.of(context)!.clearSearch),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetTile extends StatelessWidget {
  final BuildContext parentContext; 
  final String budget;
  final BudgetEntity? budgetEntity;
  final bool isSelected;
  final bool isAllOption;
  final IconData budgetIcon;
  final Color budgetColor;
  final VoidCallback onTap;

  const _BudgetTile({
    super.key,
    required this.parentContext,
    required this.budget,
    required this.budgetEntity,
    required this.isSelected,
    required this.isAllOption,
    required this.budgetIcon,
    required this.budgetColor,
    required this.onTap,
  });

  
  Future<double> _calculateSpentAmount(BuildContext context) async {
    if (budgetEntity == null) {
      return 0.0;
    }

    try {
      final transactionBloc = parentContext.read<TransactionBloc>();

      
      final periodStart = BudgetCalculationUtils.calculateBudgetPeriodStart(budgetEntity!);
      final periodEnd = BudgetCalculationUtils.calculateBudgetPeriodEnd(budgetEntity!);


      
      final result = await transactionBloc.transactionUsecases
          .getTotalByBudgetAndDateRange(
            budgetEntity!.id,
            periodStart,
            periodEnd,
          );

      return result.when(
        success: (totalSpent) {
          
          return totalSpent.abs();
        },
        failure: (failure) {
          return 0.0;
        },
      );
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyBloc = GetIt.instance<CurrencyBloc>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? const Color(0xFF667eea) : Colors.grey[200]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
              color: isSelected
                  ? const Color(0xFF667eea).withValues(alpha: 0.05)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: budgetColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(budgetIcon, color: budgetColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              budget,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFF667eea)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (budgetEntity != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getPeriodColor().withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _getPeriodColor().withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                _getLocalizedPeriodName(
                                  context,
                                  budgetEntity!.period,
                                ),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: _getPeriodColor(),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildSubtitle(context, currencyBloc),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF667eea),
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLocalizedPeriodName(BuildContext context, BudgetPeriod period) {
    final l10n = AppLocalizations.of(context)!;
    switch (period) {
      case BudgetPeriod.weekly:
        return l10n.budgetPeriodWeekly;
      case BudgetPeriod.monthly:
        return l10n.budgetPeriodMonthly;
      case BudgetPeriod.quarterly:
        return l10n.budgetPeriodQuarterly;
      case BudgetPeriod.yearly:
        return l10n.budgetPeriodYearly;
    }
  }

  Widget _buildSubtitle(BuildContext context, CurrencyBloc currencyBloc) {
    if (isAllOption) {
      return Text(
        AppLocalizations.of(context)!.showAllTransactions,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      );
    }

    if (budgetEntity == null) {
      return Text(
        AppLocalizations.of(context)!.budgetDetailsLoading,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      );
    }

    return FutureBuilder<double>(
      future: _calculateSpentAmount(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            AppLocalizations.of(context)!.calculatingRemaining,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          );
        }

        final totalSpent = snapshot.data ?? 0.0;
        final remaining = budgetEntity!.amount - totalSpent;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (budgetEntity!.description.isNotEmpty) ...[
              Text(
                budgetEntity!.description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            Text(
              remaining > 0
                  ? '${AppLocalizations.of(context)!.remaining}: ${currencyBloc.formatAmount(remaining)} dari ${currencyBloc.formatAmount(budgetEntity!.amount)}'
                  : '${AppLocalizations.of(context)!.overBudget}: ${currencyBloc.formatAmount(remaining.abs())} dari ${currencyBloc.formatAmount(budgetEntity!.amount)}',
              style: TextStyle(
                fontSize: 12,
                color: remaining > 0 ? Colors.green[600] : Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getPeriodColor() {
    if (budgetEntity == null) return Colors.grey;

    switch (budgetEntity!.period) {
      case BudgetPeriod.weekly:
        return Colors.orange;
      case BudgetPeriod.monthly:
        return Colors.blue;
      case BudgetPeriod.quarterly:
        return Colors.purple;
      case BudgetPeriod.yearly:
        return Colors.red;
    }
  }
}
