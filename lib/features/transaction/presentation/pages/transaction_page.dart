import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_header.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_list.dart';
import 'package:cashflow/features/transaction/presentation/widgets/transaction_fab.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with AutomaticKeepAliveClientMixin {
  late String _selectedPeriod;
  late String _selectedBudget;
  late String _sortBy;
  String _searchQuery = '';
  bool _isSearching = false;
  DateTime? _selectedSpecificDate;

  late List<String> _periods;
  late List<String> _budgets;
  late List<String> _sortOptions;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionBloc>().add(const TransactionDataRequested());
    });
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
      l10n.filterSpecificDate, 
    ];
    _sortOptions = [l10n.sortByDate, l10n.sortByAmount, l10n.sortByCategory];
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
      
    }
  }

  
  void refreshTransactions() {
    
    context.read<TransactionBloc>().add(const TransactionDataRequested());
    
    _loadBudgets();
  }

  String _formatSpecificDate(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate == today) {
      return l10n.filterToday;
    } else if (selectedDate == yesterday) {
      return l10n.dateYesterday;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
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
              specificDate: _selectedSpecificDate,
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
              onPeriodChanged: (period) async {
                final l10n = AppLocalizations.of(context)!;
                if (period == l10n.filterSpecificDate) {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedSpecificDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedSpecificDate = selectedDate;
                      _selectedPeriod = _formatSpecificDate(selectedDate);
                    });
                  }
                } else {
                  setState(() {
                    _selectedPeriod = period;
                    _selectedSpecificDate = null;
                  });
                }
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
              onBudgetsRefreshed: () {
                
                _loadBudgets();
              },
            ),

            Expanded(
              child: TransactionList(
                searchQuery: _searchQuery,
                selectedPeriod: _selectedPeriod,
                selectedBudget: _selectedBudget,
                sortBy: _sortBy,
                specificDate: _selectedSpecificDate,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const TransactionFAB(),
    );
  }
}
