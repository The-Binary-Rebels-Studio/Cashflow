import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_header.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_list.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_fab.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late String _selectedPeriod;
  late String _selectedBudget;
  late String _sortBy;
  String _searchQuery = '';
  bool _isSearching = false;
  
  late List<String> _periods;
  late List<String> _budgets;
  late List<String> _sortOptions;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _periods = [
      l10n.filterToday,
      l10n.filterThisWeek,
      l10n.filterThisMonth,
      l10n.filterThisYear,
    ];
    _sortOptions = [
      l10n.sortByDate,
      l10n.sortByAmount,
      l10n.sortByCategory,
    ];
    _budgets = [l10n.all];
    _selectedPeriod = l10n.filterThisMonth;
    _sortBy = l10n.sortByDate;
    _selectedBudget = l10n.all;
  }

  Future<void> _loadBudgets() async {
    try {
      final budgetRepository = GetIt.instance<BudgetManagementRepository>();
      final budgets = await budgetRepository.getAllBudgets();
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _budgets = [l10n.all, ...budgets.map((budget) => budget.name)];
      });
    } catch (e) {
      debugPrint('Failed to load budgets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TransactionHeader(
                isSearching: _isSearching,
                searchQuery: _searchQuery,
                selectedPeriod: _selectedPeriod,
                selectedBudget: _selectedBudget,
                sortBy: _sortBy,
                periods: _periods,
                budgets: _budgets,
                sortOptions: _sortOptions,
                onSearchToggle: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) _searchQuery = '';
                  });
                },
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                onPeriodChanged: (period) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
                onBudgetChanged: (budget) {
                  setState(() {
                    _selectedBudget = budget;
                  });
                },
                onSortChanged: (sort) {
                  setState(() {
                    _sortBy = sort;
                  });
                },
              ),
              Expanded(
                child: TransactionList(
                  searchQuery: _searchQuery,
                  selectedPeriod: _selectedPeriod,
                  selectedBudget: _selectedBudget,
                  sortBy: _sortBy,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const TransactionFAB(),
      );
  }
}