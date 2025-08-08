import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/core/services/currency_service.dart';
import 'package:cashflow/features/financial/presentation/cubit/budget_management_cubit.dart';
import 'package:cashflow/features/financial/presentation/cubit/budget_management_state.dart';
import 'package:cashflow/features/financial/presentation/widgets/budget_overview_card.dart';
import 'package:cashflow/features/financial/presentation/widgets/budget_plan_item.dart';

class BudgetManagementPage extends StatelessWidget {
  const BudgetManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<BudgetManagementCubit>()),
        BlocProvider.value(value: getIt<CurrencyService>()),
      ],
      child: const _BudgetManagementView(),
    );
  }
}

class _BudgetManagementView extends StatefulWidget {
  const _BudgetManagementView();

  @override
  State<_BudgetManagementView> createState() => _BudgetManagementViewState();
}

class _BudgetManagementViewState extends State<_BudgetManagementView> {
  String _sortBy = 'amount'; // amount, name, date
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    // Initialize budget management data when page loads
    context.read<BudgetManagementCubit>().initializeBudgetManagement();
  }

  Future<void> refreshData() async {
    await context.read<BudgetManagementCubit>().loadBudgetManagementData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                onPressed: () => context.pop(),
              ),
              title: Text(
                l10n.budgetManagement,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black87),
                  onPressed: () {
                    // TODO: Show options menu
                  },
                ),
              ],
            ),
            
            // Budget Overview Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: const BudgetOverviewCard(),
              ),
            ),
            
            // Filter and Sort Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tune, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Sort by:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSortDropdown(),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _sortAscending = !_sortAscending;
                        });
                      },
                      icon: Icon(
                        _sortAscending ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: const Color(0xFF667eea),
                      ),
                      tooltip: _sortAscending ? 'Ascending' : 'Descending',
                    ),
                  ],
                ),
              ),
            ),
            
            // Add Budget Button
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final cubit = context.read<BudgetManagementCubit>();
                    await context.pushNamed('create_budget');
                    // Refresh data after returning from create budget page
                    if (mounted) {
                      cubit.loadBudgetManagementData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text(
                    'Create New Budget Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            
            // Budget Plans List
            _BudgetPlansSliver(
              sortBy: _sortBy,
              sortAscending: _sortAscending,
              onRefreshNeeded: refreshData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    final sortOptions = [
      {'value': 'amount', 'label': 'Amount', 'icon': Icons.attach_money},
      {'value': 'name', 'label': 'Name', 'icon': Icons.sort_by_alpha},
      {'value': 'date', 'label': 'Date', 'icon': Icons.calendar_today},
      {'value': 'category', 'label': 'Category', 'icon': Icons.category},
    ];

    final selectedOption = sortOptions.firstWhere(
      (option) => option['value'] == _sortBy,
      orElse: () => sortOptions.first,
    );

    return GestureDetector(
      onTap: () => _showSortOptions(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(
              selectedOption['icon'] as IconData,
              size: 16,
              color: const Color(0xFF667eea),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedOption['label'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    final sortOptions = [
      {'value': 'amount', 'label': 'Amount', 'icon': Icons.attach_money},
      {'value': 'name', 'label': 'Name', 'icon': Icons.sort_by_alpha},
      {'value': 'date', 'label': 'Date', 'icon': Icons.calendar_today},
      {'value': 'category', 'label': 'Category', 'icon': Icons.category},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
            // Options
            ...sortOptions.map((option) {
              final isSelected = option['value'] == _sortBy;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _sortBy = option['value'] as String;
                      });
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF667eea)
                              : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? const Color(0xFF667eea).withValues(alpha: 0.05)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            option['icon'] as IconData,
                            color: isSelected
                                ? const Color(0xFF667eea)
                                : Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              option['label'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF667eea)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF667eea),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}

class _BudgetPlansSliver extends StatelessWidget {
  final String sortBy;
  final bool sortAscending;
  final Future<void> Function() onRefreshNeeded;

  const _BudgetPlansSliver({
    required this.sortBy,
    required this.sortAscending,
    required this.onRefreshNeeded,
  });

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<BudgetManagementCubit, BudgetManagementState>(
      listener: (context, state) {
        if (state is BudgetManagementOperationSuccess) {
          // Show success message for delete/update operations
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is BudgetManagementError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is BudgetManagementLoading) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading budget plans...'),
                ],
              ),
            ),
          );
        }

        if (state is! BudgetManagementLoaded || state.budgetPlans.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(context),
          );
        }

        // Sort budget plans based on selected criteria
        final sortedBudgets = List<dynamic>.from(state.budgetPlans);
        sortedBudgets.sort((a, b) {
          int comparison = 0;
          
          switch (sortBy) {
            case 'amount':
              comparison = a.amount.compareTo(b.amount);
              break;
            case 'name':
              comparison = a.name.compareTo(b.name);
              break;
            case 'date':
              comparison = a.createdAt.compareTo(b.createdAt);
              break;
            case 'category':
              final categoryA = state.categories.where((cat) => cat.id == a.categoryId).firstOrNull?.name ?? '';
              final categoryB = state.categories.where((cat) => cat.id == b.categoryId).firstOrNull?.name ?? '';
              comparison = categoryA.compareTo(categoryB);
              break;
          }
          
          return sortAscending ? comparison : -comparison;
        });

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final budget = sortedBudgets[index];
              final category = state.categories
                  .where((cat) => cat.id == budget.categoryId)
                  .firstOrNull;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: BudgetPlanItem(
                  budget: budget,
                  category: category,
                  onEdit: () async {
                    await context.pushNamed('create_budget', extra: {'budget': budget});
                    // Refresh data after returning from edit budget page
                    if (context.mounted) {
                      context.read<BudgetManagementCubit>().loadBudgetManagementData();
                    }
                  },
                  onDelete: () {
                    _showDeleteConfirmation(context, budget.id, budget.name, onRefreshNeeded);
                  },
                ),
              );
            },
            childCount: sortedBudgets.length,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[100]!,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 40,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Budget Plans Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start managing your spending by creating budget plans.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String budgetId, String budgetName, Future<void> Function() onRefreshNeeded) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red, size: 24),
            SizedBox(width: 12),
            Text('Delete Budget Plan'),
          ],
        ),
        content: Text('Are you sure you want to delete "$budgetName"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              final cubit = context.read<BudgetManagementCubit>();
              Navigator.of(context).pop(); // Close dialog first
              
              try {
                // Delete budget and wait for completion
                await cubit.deleteBudget(budgetId);
                
                // Use callback to refresh data and UI
                await onRefreshNeeded();
              } catch (e) {
                // Error will be handled by BlocConsumer listener
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}