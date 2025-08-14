import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/utils/currency_formatter.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_budget.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity_extensions.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';
import 'package:cashflow/features/budget_management/presentation/utils/budget_calculation_utils.dart';

class TransactionDetailPage extends StatefulWidget {
  final String transactionId;

  const TransactionDetailPage({super.key, required this.transactionId});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  TransactionWithBudget? _transaction;
  BudgetEntity? _budget;
  CategoryEntity? _category;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTransactionDetail();
  }

  Future<void> _loadTransactionDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final transactionBloc = context.read<TransactionBloc>();
      final result = await transactionBloc.transactionUsecases
          .getTransactionById(widget.transactionId);

      result.when(
        success: (transaction) async {
          setState(() {
            _transaction = transaction;
            _budget = transaction.budget;
          });

          // Load related category information through budget
          await _loadCategoryInfo(transaction.budget.categoryId);

          setState(() {
            _isLoading = false;
          });
        },
        failure: (failure) {
          setState(() {
            _isLoading = false;
            _errorMessage = failure.message;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load transaction details: $e';
      });
    }
  }

  Future<void> _loadCategoryInfo(String categoryId) async {
    try {
      // Handle virtual income category
      if (categoryId == 'virtual_income_category') {
        final now = DateTime.now();
        final virtualCategory = CategoryEntity(
          id: 'virtual_income_category',
          name: 'Income',
          description: 'Virtual category for income transactions',
          iconCodePoint: '0xe4b8', // attach_money icon
          colorValue: '0xFF4CAF50', // Green color
          type: CategoryType.income,
          isActive: true,
          createdAt: now,
          updatedAt: now,
        );
        
        setState(() {
          _category = virtualCategory;
        });
        return;
      }
      
      final budgetRepository = GetIt.instance<BudgetManagementRepository>();
      final category = await budgetRepository.getCategoryById(categoryId);
      if (category != null) {
        setState(() {
          _category = category;
        });
      }
    } catch (e) {
    }
  }

  Future<void> _deleteTransaction() async {
    if (_transaction == null) return;

    final confirmed = await _showDeleteConfirmationDialog();
    if (!confirmed) return;

    try {
      final transactionBloc = context.read<TransactionBloc>();
      final result = await transactionBloc.transactionUsecases
          .deleteTransaction(_transaction!.transaction.id);

      result.when(
        success: (_) {
          // Refresh transaction list
          transactionBloc.add(const TransactionDataRequested());

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.transactionDeleted),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        },
        failure: (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to delete transaction: ${failure.message}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting transaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {}
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return await showModalBottomSheet<bool>(
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
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header section with icon and title
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Icon
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
                      
                      // Title
                      Text(
                        l10n.deleteConfirmationTitle,
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
                      
                      // Subtitle
                      Text(
                        l10n.deleteConfirmationMessage,
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
                
                // Content section with white background
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
                      // Transaction preview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _getCategoryIcon(),
                              color: Colors.red[600],
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _transaction?.transaction.title ?? '',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              CurrencyFormatter.formatWithSymbol(
                                _transaction?.transaction.amount ?? 0,
                                GetIt.instance<CurrencyBloc>().state.symbol,
                                context,
                                showSign: true,
                                useHomeFormat: true, // Detail format untuk transaction detail
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: (_transaction?.transaction.amount ?? 0) >= 0
                                    ? theme.colorScheme.primary
                                    : Colors.red[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Warning message
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
                                l10n.deleteConfirmationWarning,
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
                
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n.cancel,
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
                          onPressed: () => Navigator.of(context).pop(true),
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
                            l10n.delete,
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
        ) ??
        false;
  }

  IconData _getCategoryIcon() {
    if (_transaction == null) return Icons.attach_money;

    try {
      return IconData(
        int.parse(_category!.iconCodePoint),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      final categoryName = _category!.name.toLowerCase();
      if (categoryName.contains('food') || categoryName.contains('dining')) {
        return Icons.restaurant;
      }
      if (categoryName.contains('transport') || categoryName.contains('travel')) {
        return Icons.directions_car;
      }
      if (categoryName.contains('shopping') || categoryName.contains('retail')) {
        return Icons.shopping_cart;
      }
      if (categoryName.contains('bill') || categoryName.contains('utility')) {
        return Icons.receipt;
      }
      if (categoryName.contains('entertainment')) {
        return Icons.movie;
      }
      if (categoryName.contains('health') || categoryName.contains('medical')) {
        return Icons.local_hospital;
      }
      if (categoryName.contains('education')) {
        return Icons.school;
      }
      if (categoryName.contains('income') || categoryName.contains('salary')) {
        return Icons.account_balance_wallet;
      }
      return Icons.attach_money;
    }
  }

  Color _getCategoryColor() {
    if (_transaction == null) return Colors.grey;

    try {
      return Color(int.parse(_category!.colorValue));
    } catch (e) {
      final categoryName = _category!.name.toLowerCase();
      if (categoryName.contains('food')) {
        return Colors.orange;
      }
      if (categoryName.contains('transport')) {
        return Colors.blue;
      }
      if (categoryName.contains('shopping')) {
        return Colors.purple;
      }
      if (categoryName.contains('bill')) {
        return Colors.red;
      }
      if (categoryName.contains('entertainment')) {
        return Colors.pink;
      }
      if (categoryName.contains('health')) {
        return Colors.teal;
      }
      if (categoryName.contains('education')) {
        return Colors.indigo;
      }
      if (categoryName.contains('income')) {
        return Colors.green;
      }
      return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);
    final l10n = AppLocalizations.of(context)!;

    if (transactionDate == today) {
      return '${l10n.dateToday}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (transactionDate == yesterday) {
      return '${l10n.dateYesterday}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDateOnly(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);
    final l10n = AppLocalizations.of(context)!;

    if (transactionDate == today) {
      return l10n.dateToday;
    } else if (transactionDate == yesterday) {
      return l10n.dateYesterday;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTimeOnly(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.transactionDetails,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          if (_transaction != null && !_isLoading) ...[
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    // TODO: Navigate to edit transaction page
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.editFunctionalityComingSoon),
                        backgroundColor: Colors.blue,
                      ),
                    );
                    break;
                  case 'delete':
                    _deleteTransaction();
                    break;
                }
              },
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18, color: Colors.blue),
                      SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, size: 18, color: Colors.red),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading transaction details...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.error,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadTransactionDetail,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_transaction == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            AppLocalizations.of(context)!.transactionNotFound,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionCard(),
          const SizedBox(height: 20),
          _buildDetailsSection(),
          if (_budget != null && _transaction!.transaction.isExpense) ...[
            const SizedBox(height: 20),
            _buildBudgetInfo(),
          ],
          const SizedBox(height: 20),
          _buildTimestampSection(),
          const SizedBox(height: 100), // Space for potential actions
        ],
      ),
    );
  }

  Widget _buildTransactionCard() {
    final transaction = _transaction!.transaction;
    final isPositive = transaction.amount >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPositive
              ? [const Color(0xFF4CAF50), const Color(0xFF8BC34A)]
              : [const Color(0xFFFF5722), const Color(0xFFFF9800)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                (isPositive ? const Color(0xFF4CAF50) : const Color(0xFFFF5722))
                    .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            transaction.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatWithSymbol(
              transaction.amount,
              GetIt.instance<CurrencyBloc>().state.symbol,
              context,
              showSign: true,
              useHomeFormat: true,
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(transaction.date),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    final transaction = _transaction!.transaction;
    final category = _category!;
    final categoryColor = _getCategoryColor();
    final categoryIcon = _getCategoryIcon();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.details,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Category
          _buildDetailRow(
            AppLocalizations.of(context)!.category,
            category.localizedName(context),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 20),
            ),
          ),

          const SizedBox(height: 16),

          // Type chip only
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: transaction.isIncome
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              transaction.isIncome ? AppLocalizations.of(context)!.income : AppLocalizations.of(context)!.expense,
              style: TextStyle(
                color: transaction.isIncome
                    ? Colors.green[700]
                    : Colors.red[700],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          if (transaction.description != null &&
              transaction.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildDetailRow(
              AppLocalizations.of(context)!.description,
              transaction.description!,
              leading: Icon(Icons.notes, color: Colors.grey[600], size: 20),
            ),
          ],

          const SizedBox(height: 16),

          // Amount breakdown
          _buildDetailRow(
            AppLocalizations.of(context)!.amount,
            CurrencyFormatter.formatWithSymbol(
              transaction.amount,
              GetIt.instance<CurrencyBloc>().state.symbol,
              context,
              showSign: true,
              useHomeFormat: true,
            ),
            leading: Icon(
              transaction.isIncome ? Icons.add_circle : Icons.remove_circle,
              color: transaction.isIncome ? Colors.green : Colors.red,
              size: 20,
            ),
          ),

          const SizedBox(height: 16),

          // Date and Time
          Row(
            children: [
              Expanded(
                child: _buildDetailRow(
                  AppLocalizations.of(context)!.transactionDate,
                  _formatDateOnly(transaction.date),
                  leading: Icon(
                    Icons.calendar_today,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  compact: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailRow(
                  AppLocalizations.of(context)!.time,
                  _formatTimeOnly(transaction.date),
                  leading: Icon(
                    Icons.schedule,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Widget? leading,
    bool showTrailing = true,
    bool compact = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: 12)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: compact ? 12 : 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              if (showTrailing)
                Text(
                  value,
                  style: TextStyle(
                    fontSize: compact ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetInfo() {
    if (_budget == null) return const SizedBox();

    return FutureBuilder<double>(
      future: _calculateBudgetSpent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final totalSpent = snapshot.data ?? 0.0;
        final remaining = _budget!.amount - totalSpent;
        final spentPercentage = _budget!.amount > 0
            ? (totalSpent / _budget!.amount)
            : 0.0;
        final isOverBudget = remaining < 0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Budget Impact',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                _budget!.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Progress bar
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  widthFactor: spentPercentage.clamp(0.0, 1.0),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: spentPercentage < 0.8
                            ? [Colors.green[400]!, Colors.green[600]!]
                            : spentPercentage < 0.9
                            ? [Colors.orange[400]!, Colors.orange[600]!]
                            : [Colors.red[400]!, Colors.red[600]!],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.spent}: ${CurrencyFormatter.formatWithSymbol(-totalSpent, GetIt.instance<CurrencyBloc>().state.symbol, context, showSign: false)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    '${(spentPercentage * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: spentPercentage < 0.8
                          ? Colors.green[600]
                          : spentPercentage < 0.9
                          ? Colors.orange[600]
                          : Colors.red[600],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.budget,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          CurrencyFormatter.formatWithSymbol(
                            _budget!.amount,
                            GetIt.instance<CurrencyBloc>().state.symbol,
                            context,
                            showSign: false,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.remaining,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          CurrencyFormatter.formatWithSymbol(
                            remaining,
                            GetIt.instance<CurrencyBloc>().state.symbol,
                            context,
                            showSign: false,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isOverBudget
                                ? Colors.red[600]
                                : Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (isOverBudget) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red[600], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${AppLocalizations.of(context)!.thisBudgetIsOverBy} ${CurrencyFormatter.formatWithSymbol(remaining.abs(), GetIt.instance<CurrencyBloc>().state.symbol, context, showSign: false)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<double> _calculateBudgetSpent() async {
    if (_budget == null || _transaction == null) return 0.0;

    try {
      final transactionBloc = context.read<TransactionBloc>();
      // Calculate budget-specific period (from budget creation date, not rolling periods)
      final periodStart = BudgetCalculationUtils.calculateBudgetPeriodStart(_budget!);
      final periodEnd = BudgetCalculationUtils.calculateBudgetPeriodEnd(_budget!);

      final result = await transactionBloc.transactionUsecases
          .getTotalByBudgetAndDateRange(
            _budget!.id,
            periodStart,
            periodEnd,
          );

      return result.when(
        success: (totalSpent) => totalSpent.abs(),
        failure: (failure) => 0.0,
      );
    } catch (e) {
      return 0.0;
    }
  }

  Widget _buildTimestampSection() {
    final transaction = _transaction!.transaction;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.timeline,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _buildTimestampRow(
            AppLocalizations.of(context)!.created,
            transaction.createdAt,
            Icons.add_circle_outline,
            Colors.blue,
          ),

          if (transaction.createdAt != transaction.updatedAt) ...[
            const SizedBox(height: 12),
            _buildTimestampRow(
              AppLocalizations.of(context)!.lastUpdated,
              transaction.updatedAt,
              Icons.edit,
              Colors.orange,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimestampRow(
    String label,
    DateTime timestamp,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(timestamp),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
