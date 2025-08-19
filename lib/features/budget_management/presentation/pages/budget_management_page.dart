import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/services/simple_analytics_service.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_bloc.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_event.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_state.dart';
import 'package:cashflow/features/budget_management/presentation/widgets/budget_overview_card.dart';
import 'package:cashflow/features/budget_management/presentation/widgets/budget_plan_item.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity_extensions.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:cashflow/shared/widgets/banner_ad_widget.dart';

class BudgetManagementPage extends StatelessWidget {
  const BudgetManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<BudgetManagementBloc>()),
        BlocProvider.value(value: getIt<CurrencyBloc>()),
        BlocProvider.value(value: getIt<TransactionBloc>()),
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
  String _sortBy = 'amount';
  bool _sortAscending = false;
  late final SimpleAnalyticsService _analyticsService;
  DateTime? _screenStartTime;

  @override
  void initState() {
    super.initState();

    _analyticsService = getIt<SimpleAnalyticsService>();
    _screenStartTime = DateTime.now();

    context.read<BudgetManagementBloc>().add(
      const BudgetManagementInitialized(),
    );

    // Analytics tracking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _analyticsService.logScreenView('budget_management');
      _analyticsService.logFeatureUsage('budget_overview_access');
    });

    context.read<TransactionBloc>().add(const TransactionDataRequested());
  }

  Future<void> refreshData() async {
    context.read<BudgetManagementBloc>().add(
      const BudgetManagementDataRequested(),
    );

    if (mounted) {
      context.read<TransactionBloc>().add(const TransactionDataRequested());
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onEditBudget(BudgetEntity budget) async {
    // Analytics tracking
    _analyticsService.logButtonPress('edit_budget', 'budget_management');
    _analyticsService.logBudgetAction('edit');
    _analyticsService.logNavigation('budget_management', 'edit_budget');

    await context.pushNamed('create_budget', extra: {'budget': budget});

    if (context.mounted) {
      context.read<BudgetManagementBloc>().add(
        const BudgetManagementDataRequested(),
      );
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
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: const BudgetOverviewCard(),
              ),
            ),

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
                      '${AppLocalizations.of(context)!.sortBy}:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSortDropdown()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _sortAscending = !_sortAscending;
                        });
                      },
                      icon: Icon(
                        _sortAscending
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF667eea),
                      ),
                      tooltip: _sortAscending
                          ? AppLocalizations.of(context)!.ascending
                          : AppLocalizations.of(context)!.descending,
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Analytics tracking
                    _analyticsService.logButtonPress(
                      'create_budget',
                      'budget_management',
                    );
                    _analyticsService.logFeatureUsage('budget_creation_start');
                    _analyticsService.logNavigation(
                      'budget_management',
                      'create_budget',
                    );

                    final bloc = context.read<BudgetManagementBloc>();
                    await context.pushNamed('create_budget');

                    if (mounted) {
                      bloc.add(const BudgetManagementDataRequested());
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
                  label: Text(
                    AppLocalizations.of(context)!.createNewBudgetPlan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: const BannerAdWidget(
                  maxHeight: 100,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),

            _BudgetPlansSliver(
              sortBy: _sortBy,
              sortAscending: _sortAscending,
              onRefreshNeeded: refreshData,
              onEditBudget: _onEditBudget,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    final sortOptions = [
      {
        'value': 'amount',
        'labelKey': 'sortByAmount',
        'icon': Icons.attach_money,
      },
      {'value': 'name', 'labelKey': 'sortByName', 'icon': Icons.sort_by_alpha},
      {'value': 'date', 'labelKey': 'sortByDate', 'icon': Icons.calendar_today},
      {
        'value': 'category',
        'labelKey': 'sortByCategory',
        'icon': Icons.category,
      },
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
                _getLocalizedSortLabel(selectedOption['labelKey'] as String),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    final sortOptions = [
      {
        'value': 'amount',
        'labelKey': 'sortByAmount',
        'icon': Icons.attach_money,
      },
      {'value': 'name', 'labelKey': 'sortByName', 'icon': Icons.sort_by_alpha},
      {'value': 'date', 'labelKey': 'sortByDate', 'icon': Icons.calendar_today},
      {
        'value': 'category',
        'labelKey': 'sortByCategory',
        'icon': Icons.category,
      },
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
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.sortBy,
                    style: const TextStyle(
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
                              _getLocalizedSortLabel(
                                option['labelKey'] as String,
                              ),
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

  String _getLocalizedSortLabel(String key) {
    final localizations = AppLocalizations.of(context)!;
    switch (key) {
      case 'sortByAmount':
        return localizations.sortByAmount;
      case 'sortByName':
        return localizations.sortByName;
      case 'sortByDate':
        return localizations.sortByDate;
      case 'sortByCategory':
        return localizations.sortByCategory;
      default:
        return key;
    }
  }
}

class _BudgetPlansSliver extends StatelessWidget {
  final String sortBy;
  final bool sortAscending;
  final Future<void> Function() onRefreshNeeded;
  final Function(BudgetEntity) onEditBudget;

  const _BudgetPlansSliver({
    required this.sortBy,
    required this.sortAscending,
    required this.onRefreshNeeded,
    required this.onEditBudget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudgetManagementBloc, BudgetManagementState>(
      listener: (context, state) {
        if (state is BudgetManagementOperationSuccess) {
          String localizedMessage;
          switch (state.message) {
            case 'budgetCreatedSuccess':
              localizedMessage = AppLocalizations.of(
                context,
              )!.budgetCreatedSuccess;
              break;
            case 'budgetUpdatedSuccess':
              localizedMessage = AppLocalizations.of(
                context,
              )!.budgetUpdatedSuccess;
              break;
            case 'budgetDeletedSuccess':
              localizedMessage = AppLocalizations.of(
                context,
              )!.budgetDeletedSuccess;
              break;
            default:
              localizedMessage = state.message;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizedMessage),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is BudgetManagementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
                  Text(AppLocalizations.of(context)!.loadingBudgetPlans),
                ],
              ),
            ),
          );
        }

        if (state is! BudgetManagementLoaded || state.budgetPlans.isEmpty) {
          return SliverFillRemaining(child: _buildEmptyState(context));
        }

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
              final categoryA =
                  state.categories
                      .where((cat) => cat.id == a.categoryId)
                      .firstOrNull
                      ?.localizedName(context) ??
                  '';
              final categoryB =
                  state.categories
                      .where((cat) => cat.id == b.categoryId)
                      .firstOrNull
                      ?.localizedName(context) ??
                  '';
              comparison = categoryA.compareTo(categoryB);
              break;
          }

          return sortAscending ? comparison : -comparison;
        });

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final budget = sortedBudgets[index];
            final category = state.categories
                .where((cat) => cat.id == budget.categoryId)
                .firstOrNull;

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: BudgetPlanItem(
                budget: budget,
                category: category,
                onEdit: () => onEditBudget(budget),
                onDelete: () {
                  _showDeleteConfirmation(
                    context,
                    budget.id,
                    budget.name,
                    category?.iconCodePoint ?? '',
                    onRefreshNeeded,
                  );
                },
              ),
            );
          }, childCount: sortedBudgets.length),
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
                  colors: [Colors.grey[300]!, Colors.grey[100]!],
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
              AppLocalizations.of(context)!.noBudgetPlansYet,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noBudgetPlansMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String budgetId,
    String budgetName,
    String categoryIconCodePoint,
    Future<void> Function() onRefreshNeeded,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red[400]!, Colors.red[600]!],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    AppLocalizations.of(context)!.deleteBudgetPlan,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    AppLocalizations.of(
                      context,
                    )!.deleteBudgetConfirmation(budgetName),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getIconData(categoryIconCodePoint),
                          color: Colors.red[600],
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          budgetName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.deleteConfirmationWarning,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final bloc = context.read<BudgetManagementBloc>();
                        Navigator.of(context).pop();

                        try {
                          bloc.add(BudgetDeleteRequested(id: budgetId));

                          await onRefreshNeeded();
                        } catch (e) {}
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.delete,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconCodePoint) {
    // For tree shaking compatibility, return predefined icons
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

    return iconMap[iconCodePoint] ?? Icons.category;
  }
}
