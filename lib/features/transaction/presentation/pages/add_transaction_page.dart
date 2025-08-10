import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/core/services/currency_service.dart';
import 'package:cashflow/features/transaction/presentation/cubit/transaction_cubit.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/budget_management/presentation/cubit/budget_management_cubit.dart';
import 'package:cashflow/features/budget_management/presentation/cubit/budget_management_state.dart';
import 'package:cashflow/core/constants/app_constants.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';

// Generic item for transaction selection (Budget Plans for expense, Categories for income)
class TransactionItem {
  final String id;
  final String name;
  final double remainingAmount; // Only for budget plans
  final bool isOthers;
  final bool isBudgetPlan; // true for budget plans, false for categories
  final String displayName;
  final String description;
  final IconData icon;
  final Color color;
  final BudgetEntity? budget; // null for categories
  final CategoryEntity? category; // null for budget plans

  const TransactionItem({
    required this.id,
    required this.name,
    required this.remainingAmount,
    required this.isOthers,
    required this.isBudgetPlan,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.color,
    this.budget,
    this.category,
  });

  // Create from Budget Plan (for expense)
  factory TransactionItem.fromBudget(BudgetEntity budget, double remainingAmount, CategoryEntity category) {
    Color categoryColor;
    IconData iconData;
    
    try {
      categoryColor = Color(int.parse(category.colorValue));
    } catch (e) {
      categoryColor = Colors.blue;
    }
    
    try {
      iconData = IconData(
        int.parse(category.iconCodePoint),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      iconData = Icons.category;
    }
    
    return TransactionItem(
      id: budget.id,
      name: budget.name,
      remainingAmount: remainingAmount,
      isOthers: false,
      isBudgetPlan: true,
      displayName: budget.name,
      description: 'Sisa budget yang tersedia',
      icon: iconData,
      color: categoryColor,
      budget: budget,
    );
  }

  // Create from Category (for income)
  factory TransactionItem.fromCategory(CategoryEntity category) {
    Color categoryColor;
    IconData iconData;
    
    try {
      categoryColor = Color(int.parse(category.colorValue));
    } catch (e) {
      categoryColor = Colors.green;
    }
    
    try {
      iconData = IconData(
        int.parse(category.iconCodePoint),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      iconData = Icons.category;
    }
    
    return TransactionItem(
      id: category.id,
      name: category.name,
      remainingAmount: 0,
      isOthers: false,
      isBudgetPlan: false,
      displayName: category.name,
      description: category.description,
      icon: iconData,
      color: categoryColor,
      category: category,
    );
  }

  // Create Others option
  factory TransactionItem.others(TransactionType type) {
    return TransactionItem(
      id: type == TransactionType.expense ? 'others_expense' : 'others_income',
      name: 'Others',
      remainingAmount: 0,
      isOthers: true,
      isBudgetPlan: false,
      displayName: type == TransactionType.expense ? 'Lainnya (Pengeluaran)' : 'Lainnya (Pemasukan)',
      description: 'Transaksi tidak terkait budget atau kategori',
      icon: Icons.more_horiz,
      color: Colors.grey,
    );
  }
}

// Custom TextInputFormatter for thousands separator  
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const String _separator = '.';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digits
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // If empty, return empty
    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Add thousands separators
    String formattedText = _addThousandsSeparator(newText);

    // Calculate cursor position
    int selectionIndex = newValue.selection.end;
    int originalLength = newValue.text.length;
    int formattedLength = formattedText.length;
    int lengthDifference = formattedLength - originalLength;

    // Adjust cursor position
    selectionIndex += lengthDifference;
    if (selectionIndex > formattedLength) {
      selectionIndex = formattedLength;
    }
    if (selectionIndex < 0) {
      selectionIndex = 0;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _addThousandsSeparator(String value) {
    if (value.length <= 3) return value;

    String result = '';
    int count = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      if (count == 3) {
        result = _separator + result;
        count = 0;
      }
      result = value[i] + result;
      count++;
    }

    return result;
  }
}

// Helper function to get raw number from formatted string
String getRawNumber(String formattedText) {
  return formattedText.replaceAll('.', '');
}

class AddTransactionPage extends StatelessWidget {
  final TransactionType? initialType;

  const AddTransactionPage({
    super.key,
    this.initialType,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<TransactionCubit>()),
        BlocProvider.value(value: getIt<CurrencyService>()),
        BlocProvider.value(value: getIt<BudgetManagementCubit>()),
      ],
      child: _AddTransactionView(initialType: initialType),
    );
  }
}

class _AddTransactionView extends StatefulWidget {
  final TransactionType? initialType;

  const _AddTransactionView({this.initialType});

  @override
  State<_AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<_AddTransactionView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType? _selectedType;
  String? _selectedItemId; // Can be budget ID or category ID
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  // Static Others option for standalone transactions
  static const String _othersExpenseId = 'others_expense';
  static const String _othersIncomeId = 'others_income';

  @override
  void initState() {
    super.initState();
    
    // Set initial type
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }

    // Initialize services
    context.read<CurrencyService>().initializeService();
    _refreshBudgetData();
  }
  
  // Refresh budget data
  void _refreshBudgetData() {
    context.read<BudgetManagementCubit>().initializeBudgetManagement();
  }


  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Get available transaction items (Budget Plans for expense, Categories for income)
  Future<List<TransactionItem>> _getAvailableTransactionItems(BudgetManagementState budgetState) async {
    List<TransactionItem> transactionItems = [];
    
    if (budgetState is BudgetManagementLoaded) {
      if (_selectedType == TransactionType.expense) {
        // For expenses, use Budget Plans
        final budgets = budgetState.budgetPlans;
        
        for (final budget in budgets) {
          // Get category info for this budget
          final category = budgetState.expenseCategories
              .where((cat) => cat.id == budget.categoryId)
              .firstOrNull;
          
          if (category != null) {
            // Calculate remaining budget based on actual transactions
            final remainingAmount = await _calculateRemainingBudget(budget);
            
            transactionItems.add(TransactionItem.fromBudget(budget, remainingAmount, category));
          }
        }
      } else if (_selectedType == TransactionType.income) {
        // For income, use Categories
        final incomeCategories = budgetState.incomeCategories;
        
        for (final category in incomeCategories) {
          transactionItems.add(TransactionItem.fromCategory(category));
        }
      }
    }

    // Always add Others option as fallback
    if (_selectedType != null) {
      transactionItems.add(TransactionItem.others(_selectedType!));
    }

    return transactionItems;
  }

  // Calculate remaining budget for a specific budget plan
  Future<double> _calculateRemainingBudget(BudgetEntity budget) async {
    try {
      final transactionCubit = context.read<TransactionCubit>();
      
      // Get total spent in this budget's category within the budget period
      final totalSpent = await transactionCubit.transactionUsecases.getTotalByCategoryAndDateRange(
        budget.categoryId,
        budget.startDate,
        budget.endDate,
      );
      
      // Debug: Print calculation details
      print('DEBUG Budget Calculation:');
      print('  Budget Name: ${budget.name}');
      print('  Budget Amount: ${budget.amount}');
      print('  Category ID: ${budget.categoryId}');
      print('  Period: ${budget.startDate} - ${budget.endDate}');
      print('  Total Spent: $totalSpent');
      print('  Total Spent (abs): ${totalSpent.abs()}');
      
      // Remaining = budget amount - absolute value of expenses (expenses are negative)
      final remaining = budget.amount - totalSpent.abs();
      
      print('  Remaining: $remaining');
      print('---');
      
      return remaining;
    } catch (e) {
      print('DEBUG Error calculating remaining budget: $e');
      // If there's an error, return full budget amount as fallback
      return budget.amount;
    }
  }

  // Format currency for display
  String _formatCurrency(double amount) {
    final currencyService = context.read<CurrencyService>();
    final symbol = currencyService.selectedCurrency.symbol;
    final formattedAmount = _formatNumber(amount);
    return '$symbol $formattedAmount';
  }
  
  // Format number with thousands separator
  String _formatNumber(double number) {
    final formatter = ThousandsSeparatorInputFormatter();
    final intValue = number.toInt().toString();
    final textEditingValue = TextEditingValue(text: intValue);
    final formattedValue = formatter.formatEditUpdate(
      const TextEditingValue(text: ''),
      textEditingValue,
    );
    return formattedValue.text;
  }


  // Show dialog when no budget plans exist
  void _showNoBudgetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue, size: 24),
            const SizedBox(width: 12),
            const Expanded(child: Text('No Budget Plans')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Untuk melacak pengeluaran dengan baik, Anda perlu membuat budget plan terlebih dahulu.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Apa yang ingin Anda lakukan?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Select Others option as fallback
              setState(() {
                _selectedItemId = _othersExpenseId;
              });
            },
            child: Text(
              'Pakai "Lainnya"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push(AppConstants.budgetManagementRoute);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Buat Budget Plan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
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
          l10n.addTransaction,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _selectedType == null
                        ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                        : _selectedType == TransactionType.income
                            ? [const Color(0xFF4CAF50), const Color(0xFF8BC34A)]
                            : [const Color(0xFFFF5722), const Color(0xFFFF9800)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (_selectedType == null
                          ? const Color(0xFF667eea)
                          : _selectedType == TransactionType.income
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFFF5722)).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _selectedType == null
                            ? Icons.account_balance_wallet
                            : _selectedType == TransactionType.income
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedType == null
                          ? l10n.addTransaction
                          : _selectedType == TransactionType.income
                              ? l10n.addIncome
                              : l10n.addExpense,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedType == null
                          ? 'Choose transaction type and record your financial activity'
                          : _selectedType == TransactionType.income
                              ? 'Record your income and earnings'
                              : 'Track your spending and expenses',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Transaction Type Toggle
              _buildFormSection(
                l10n.transactionType,
                Container(
                  decoration: _buildContainerDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton(
                          l10n.expense,
                          TransactionType.expense,
                          _selectedType == TransactionType.expense,
                          const Color(0xFFFF5722),
                          Icons.remove_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: _buildTypeButton(
                          l10n.income,
                          TransactionType.income,
                          _selectedType == TransactionType.income,
                          const Color(0xFF4CAF50),
                          Icons.add_circle_outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Transaction Title
              _buildFormSection(
                l10n.transactionTitle,
                TextFormField(
                  controller: _titleController,
                  decoration: _buildInputDecoration(
                    hintText: l10n.transactionTitleHint,
                    prefixIcon: Icons.edit_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.transactionTitleRequired;
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Amount and Date Row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildFormSection(
                      l10n.transactionAmount,
                      BlocBuilder<CurrencyService, dynamic>(
                        builder: (context, currencyState) {
                          final currencyService = context.read<CurrencyService>();
                          final currencySymbol = currencyService.selectedCurrency.symbol;

                          return TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              hintText: l10n.transactionAmountHint,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  currencySymbol,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF667eea),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              ThousandsSeparatorInputFormatter(),
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.transactionAmountRequired;
                              }
                              final rawValue = getRawNumber(value);
                              final amount = double.tryParse(rawValue);
                              if (amount == null || amount <= 0) {
                                return l10n.transactionAmountInvalid;
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _buildFormSection(
                      l10n.transactionDate,
                      GestureDetector(
                        onTap: _showDatePicker,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: _buildContainerDecoration(),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Color(0xFF667eea),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _formatDate(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Category Selection
              _buildFormSection(
                l10n.transactionCategory,
                BlocBuilder<BudgetManagementCubit, BudgetManagementState>(
                  builder: (context, budgetState) {
                    return FutureBuilder<List<TransactionItem>>(
                      future: _getAvailableTransactionItems(budgetState),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: _buildContainerDecoration(),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final transactionItems = snapshot.data ?? [];
                        
                        // Find selected transaction item
                        final selectedTransactionItem = transactionItems
                            .where((item) => item.id == _selectedItemId)
                            .firstOrNull;

                        return GestureDetector(
                          onTap: () => _showTransactionPicker(),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: _buildContainerDecoration(),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                if (selectedTransactionItem != null) ...[
                                  _buildTransactionDisplayWidget(selectedTransactionItem),
                                ] else ...[
                                  Expanded(
                                    child: Text(
                                      'Pilih Budget Plan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Description
              _buildFormSection(
                l10n.transactionDescription,
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: l10n.transactionDescriptionHint,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 64),
                      child: Icon(
                        Icons.notes_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF667eea),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                ),
              ),

              const SizedBox(height: 32),

              // Budget Preview (for expenses)
              if (_selectedType == TransactionType.expense) ...[
                _buildBudgetPreviewSection(),
                const SizedBox(height: 24),
              ],

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: const BorderSide(color: Color(0xFF667eea)),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF667eea),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveTransaction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedType == null
                            ? const Color(0xFF667eea)
                            : _selectedType == TransactionType.income
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF5722),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.saveTransaction,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, size: 20, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
    );
  }

  Widget _buildTypeButton(String label, TransactionType type, bool isSelected, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedItemId = null; // Reset selection when type changes
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDisplayWidget(TransactionItem transactionItem) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: transactionItem.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(transactionItem.icon, color: transactionItem.color, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transactionItem.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (!transactionItem.isOthers) ...[
                  Text(
                    transactionItem.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetPreviewSection() {
    // Only show for expense transactions when a budget plan is selected
    if (_selectedType != TransactionType.expense || _selectedItemId == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Pilih budget plan untuk melihat informasi anggaran',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<BudgetManagementCubit, BudgetManagementState>(
      builder: (context, budgetState) {
        return FutureBuilder<List<TransactionItem>>(
          future: _getAvailableTransactionItems(budgetState),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Loading budget info...'),
                  ],
                ),
              );
            }

            final transactionItems = snapshot.data ?? [];
            final selectedItem = transactionItems
                .where((item) => item.id == _selectedItemId)
                .firstOrNull;

            if (selectedItem == null || !selectedItem.isBudgetPlan) {
              return const SizedBox(); // Don't show preview for non-budget items
            }

            final budget = selectedItem.budget!;
            final currentAmount = double.tryParse(getRawNumber(_amountController.text)) ?? 0;
            final remainingAfterTransaction = selectedItem.remainingAmount - currentAmount;
            final isOverBudget = remainingAfterTransaction < 0;

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isOverBudget 
                    ? Colors.red.withValues(alpha: 0.05)
                    : Colors.green.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isOverBudget 
                      ? Colors.red.withValues(alpha: 0.2)
                      : Colors.green.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedItem.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          selectedItem.icon,
                          color: selectedItem.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              budget.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Budget Preview',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isOverBudget ? Icons.warning_amber_rounded : Icons.check_circle,
                        color: isOverBudget ? Colors.red[600] : Colors.green[600],
                        size: 24,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Budget Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildBudgetStatItem(
                          'Total Budget',
                          _formatCurrency(budget.amount),
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBudgetStatItem(
                          'Terpakai',
                          _formatCurrency(budget.amount - selectedItem.remainingAmount),
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBudgetStatItem(
                          'Tersisa',
                          _formatCurrency(selectedItem.remainingAmount),
                          selectedItem.remainingAmount > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  if (currentAmount > 0) ...[
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 16),

                    // After Transaction Preview
                    Row(
                      children: [
                        Icon(
                          isOverBudget ? Icons.trending_down : Icons.trending_flat,
                          color: isOverBudget ? Colors.red[600] : Colors.blue[600],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Setelah transaksi ini:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sisa Budget:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _formatCurrency(remainingAfterTransaction),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isOverBudget ? Colors.red[600] : Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                    if (isOverBudget) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            size: 16,
                            color: Colors.red[600],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Transaksi ini akan melebihi budget sebesar ${_formatCurrency(remainingAfterTransaction.abs())}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBudgetStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showTransactionPicker() async {
    final budgetState = context.read<BudgetManagementCubit>().state;
    final transactionItems = await _getAvailableTransactionItems(budgetState);

    // Check if only "Others" option is available (meaning no budget plans exist for expense)
    final realItems = transactionItems.where((item) => !item.isOthers).toList();
    
    if (realItems.isEmpty && _selectedType == TransactionType.expense) {
      _showNoBudgetDialog();
      return;
    }

    if (mounted) {
      showModalBottomSheet(
        context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    'Pilih Budget Plan (${transactionItems.length})',
                    style: const TextStyle(
                      fontSize: 20,
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
            // Check if only Others option exists
            if (realItems.isEmpty && transactionItems.isNotEmpty) ...[
              // Show guidance when only Others option available
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum Ada Budget Plan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Untuk tracking pengeluaran yang lebih baik, buat budget plan terlebih dahulu.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          await context.push(AppConstants.budgetManagementRoute);
                          // Refresh data when returning from budget management
                          if (mounted) {
                            _refreshBudgetData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667eea),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: const Text(
                          'Buat Budget Plan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Budget Items List
            Expanded(
              child: transactionItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Budget Plans Available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: transactionItems.length,
                      itemBuilder: (context, index) {
                        final transactionItem = transactionItems[index];
                        final isSelected = transactionItem.id == _selectedItemId;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedItemId = transactionItem.id;
                                });
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF667eea)
                                        : Colors.grey[200]!,
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
                                        color: transactionItem.color.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(transactionItem.icon, color: transactionItem.color, size: 20),
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
                                                  transactionItem.displayName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected ? const Color(0xFF667eea) : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              if (transactionItem.isOthers) ...[
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                                                  ),
                                                  child: Text(
                                                    'No Budget',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.orange[700],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          if (transactionItem.isBudgetPlan) ...[
                                            Text(
                                              'Sisa: ${_formatCurrency(transactionItem.remainingAmount)} dari ${_formatCurrency(transactionItem.budget?.amount ?? 0)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: transactionItem.remainingAmount > 0 ? Colors.green[600] : Colors.red[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ] else ...[
                                            Text(
                                              transactionItem.description,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
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
                      },
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
    }
  }

  void _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.transactionTypeRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedItemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon pilih budget plan atau lainnya'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get transaction data
      final title = _titleController.text.trim();
      final rawAmount = getRawNumber(_amountController.text);
      final amount = double.parse(rawAmount);
      final description = _descriptionController.text.trim();

      // Determine the category ID to use
      String? categoryId;
      final budgetState = context.read<BudgetManagementCubit>().state;
      
      if (budgetState is BudgetManagementLoaded) {
        final transactionItems = await _getAvailableTransactionItems(budgetState);
        final selectedItem = transactionItems
            .where((item) => item.id == _selectedItemId)
            .firstOrNull;
            
        if (selectedItem != null) {
          if (selectedItem.isBudgetPlan) {
            // For budget plans, use the budget's category ID
            categoryId = selectedItem.budget!.categoryId;
          } else if (selectedItem.category != null) {
            // For categories, use the category ID
            categoryId = selectedItem.category!.id;
          }
        }
      }
      
      if (categoryId == null) {
        throw Exception('Category ID not found');
      }

      // Create transaction entity
      final transaction = TransactionEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple ID generation
        title: title,
        description: description.isEmpty ? null : description,
        amount: _selectedType == TransactionType.expense ? -amount : amount, // Negative for expenses
        categoryId: categoryId,
        type: _selectedType!,
        date: _selectedDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Debug: Print transaction details
      print('DEBUG Transaction Saving:');
      print('  Title: $title');
      print('  Amount: ${transaction.amount}');
      print('  Type: ${_selectedType}');
      print('  Category ID: $categoryId');
      print('  Date: ${_selectedDate}');
      print('---');

      // Save transaction using cubit
      final transactionCubit = context.read<TransactionCubit>();
      await transactionCubit.transactionUsecases.addTransaction(transaction);

      // Refresh both budget and transaction data
      if (mounted) {
        // Refresh budget management data
        context.read<BudgetManagementCubit>().loadBudgetManagementData();
        
        // Also refresh transaction data to ensure fresh data for calculations
        await transactionCubit.loadTransactions();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.transactionSaved),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.transactionSaveFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}