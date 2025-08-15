import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/services/currency_event.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_bloc.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_event.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_state.dart';
import 'package:cashflow/features/budget_management/presentation/utils/budget_calculation_utils.dart';
import 'package:cashflow/core/constants/app_constants.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/shared/widgets/banner_ad_widget.dart';


class TransactionItem {
  final String id;
  final String name;
  final double remainingAmount; 
  final bool isBudgetPlan; 
  final String displayName;
  final String description;
  final IconData icon;
  final Color color;
  final BudgetEntity? budget; 
  final CategoryEntity? category; 

  const TransactionItem({
    required this.id,
    required this.name,
    required this.remainingAmount,
    required this.isBudgetPlan,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.color,
    this.budget,
    this.category,
  });

  
  factory TransactionItem.fromBudget(BudgetEntity budget, double remainingAmount, CategoryEntity category) {
    Color categoryColor;
    IconData iconData;
    
    try {
      categoryColor = Color(int.parse(category.colorValue));
    } catch (e) {
      categoryColor = Colors.blue;
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
    
    iconData = iconMap[category.iconCodePoint] ?? Icons.category;
    
    return TransactionItem(
      id: budget.id,
      name: budget.name,
      remainingAmount: remainingAmount,
      isBudgetPlan: true,
      displayName: budget.name,
      description: 'Sisa budget yang tersedia',
      icon: iconData,
      color: categoryColor,
      budget: budget,
    );
  }

  
  factory TransactionItem.fromCategory(CategoryEntity category) {
    Color categoryColor;
    IconData iconData;
    
    try {
      categoryColor = Color(int.parse(category.colorValue));
    } catch (e) {
      categoryColor = Colors.green;
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
    
    iconData = iconMap[category.iconCodePoint] ?? Icons.category;
    
    return TransactionItem(
      id: category.id,
      name: category.name,
      remainingAmount: 0,
      isBudgetPlan: false,
      displayName: category.name,
      description: category.description,
      icon: iconData,
      color: categoryColor,
      category: category,
    );
  }

}


class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const String _separator = '.';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    
    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    
    String formattedText = _addThousandsSeparator(newText);

    
    int selectionIndex = newValue.selection.end;
    int originalLength = newValue.text.length;
    int formattedLength = formattedText.length;
    int lengthDifference = formattedLength - originalLength;

    
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
        BlocProvider.value(value: getIt<TransactionBloc>()),
        BlocProvider.value(value: getIt<CurrencyBloc>()),
        BlocProvider.value(value: getIt<BudgetManagementBloc>()),
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
  String? _selectedItemId; 
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    
    
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }

    
    _amountController.addListener(_onAmountChanged);

    
    context.read<CurrencyBloc>().add(const CurrencyInitialized());
    _refreshBudgetData();
  }
  
  
  void _refreshBudgetData() {
    context.read<BudgetManagementBloc>().add(const BudgetManagementInitialized());
  }

  
  void _onAmountChanged() {
    if (_selectedType == TransactionType.expense && _selectedItemId != null) {
      setState(() {
        
      });
    }
  }


  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  
  Future<List<TransactionItem>> _getAvailableTransactionItems(BudgetManagementState budgetState) async {
    List<TransactionItem> transactionItems = [];
    
    if (budgetState is BudgetManagementLoaded) {
      if (_selectedType == TransactionType.expense) {
        
        final budgets = budgetState.budgetPlans;
        
        for (final budget in budgets) {
          
          final category = budgetState.expenseCategories
              .where((cat) => cat.id == budget.categoryId)
              .firstOrNull;
          
          if (category != null) {
            
            final remainingAmount = await _calculateRemainingBudget(budget);
            
            transactionItems.add(TransactionItem.fromBudget(budget, remainingAmount, category));
          }
        }
      }
      
    }

    return transactionItems;
  }

  
  Future<double> _calculateRemainingBudget(BudgetEntity budget) async {
    try {
      final transactionBloc = context.read<TransactionBloc>();
      
      
      final periodStart = BudgetCalculationUtils.calculateBudgetPeriodStart(budget);
      final periodEnd = BudgetCalculationUtils.calculateBudgetPeriodEnd(budget);
      
      
      final result = await transactionBloc.transactionUsecases.getTotalByBudgetAndDateRange(
        budget.id,
        periodStart,
        periodEnd,
      );
      
      return result.when(
        success: (totalSpent) {
          
          
          
          final remaining = budget.amount - totalSpent.abs();
          
          
          return remaining;
        },
        failure: (failure) {
          
          return budget.amount;
        },
      );
    } catch (e) {
      
      return budget.amount;
    }
  }

  
  String _formatCurrency(double amount) {
    final currencyBloc = context.read<CurrencyBloc>();
    final symbol = currencyBloc.selectedCurrency.symbol;
    final formattedAmount = _formatNumber(amount);
    return '$symbol $formattedAmount';
  }
  
  
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


  
  void _showNoBudgetDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            
            Text(
              AppLocalizations.of(context)!.noBudgetPlans,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            
            Text(
              AppLocalizations.of(context)!.createBudgetPlanDescription,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            
            Text(
              AppLocalizations.of(context)!.whatWouldYouLikeToDo,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push(AppConstants.budgetManagementRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF667eea),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.createBudgetPlan,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
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

              
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildFormSection(
                      l10n.transactionAmount,
                      BlocBuilder<CurrencyBloc, dynamic>(
                        builder: (context, currencyState) {
                          final currencyBloc = context.read<CurrencyBloc>();
                          final currencySymbol = currencyBloc.selectedCurrency.symbol;

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

              
              if (_selectedType == TransactionType.expense) ...[
                _buildFormSection(
                  l10n.transactionCategory,
                  BlocBuilder<BudgetManagementBloc, BudgetManagementState>(
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
                                        AppLocalizations.of(context)!.selectBudgetPlan,
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
              ],

              const SizedBox(height: 24),

              
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

              
              if (_selectedType == TransactionType.expense) ...[
                _buildBudgetPreviewSection(),
                const SizedBox(height: 24),
              ],

              
              const BannerAdWidget(
                maxHeight: 80, 
                margin: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),

              const SizedBox(height: 16),

              
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
          _selectedItemId = null; 
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
                if (true) ...[
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

    return BlocBuilder<BudgetManagementBloc, BudgetManagementState>(
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
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.budgetDetailsLoading),
                  ],
                ),
              );
            }

            final transactionItems = snapshot.data ?? [];
            final selectedItem = transactionItems
                .where((item) => item.id == _selectedItemId)
                .firstOrNull;

            if (selectedItem == null || !selectedItem.isBudgetPlan) {
              return const SizedBox(); 
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
                          isOverBudget ? '${AppLocalizations.of(context)!.overBudget}:' : 'Sisa Budget:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          isOverBudget 
                              ? _formatCurrency(remainingAfterTransaction.abs())
                              : _formatCurrency(remainingAfterTransaction),
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
    final budgetState = context.read<BudgetManagementBloc>().state;
    final transactionItems = await _getAvailableTransactionItems(budgetState);

    
    final realItems = transactionItems;
    
    if (realItems.isEmpty && _selectedType == TransactionType.expense) {
      _showNoBudgetDialog();
      return;
    }

    if (mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (modalContext) => _EnhancedBudgetSelector(
          transactionItems: transactionItems,
          selectedItemId: _selectedItemId,
          onItemSelected: (itemId) {
            setState(() {
              _selectedItemId = itemId;
            });
          },
          formatCurrency: _formatCurrency,
          onCreateBudget: () async {
            Navigator.pop(modalContext);
            await context.push(AppConstants.budgetManagementRoute);
            
            if (mounted) {
              _refreshBudgetData();
            }
          },
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

    
    if (_selectedType == TransactionType.expense && _selectedItemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectBudgetPlan),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      
      final title = _titleController.text.trim();
      final rawAmount = getRawNumber(_amountController.text);
      final amount = double.parse(rawAmount);
      final description = _descriptionController.text.trim();

      
      String? budgetId;
      if (!mounted) return;
      final budgetState = context.read<BudgetManagementBloc>().state;
      
      if (_selectedType == TransactionType.expense) {
        
        if (budgetState is BudgetManagementLoaded) {
          final transactionItems = await _getAvailableTransactionItems(budgetState);
          final selectedItem = transactionItems
              .where((item) => item.id == _selectedItemId)
              .firstOrNull;
              
          if (selectedItem != null && selectedItem.isBudgetPlan) {
            
            budgetId = selectedItem.budget!.id;
          }
        }
        
        if (budgetId == null) {
          throw Exception('Budget ID not found. Please select a valid budget plan.');
        }
      } else {
        
        
        budgetId = 'income_${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}_${DateTime.now().millisecondsSinceEpoch}';
      }

      
      final transaction = TransactionEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(), 
        title: title,
        description: description.isEmpty ? null : description,
        amount: _selectedType == TransactionType.expense ? -amount : amount, 
        budgetId: budgetId,
        type: _selectedType!,
        date: _selectedDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      

      
      if (!mounted) return;
      final transactionBloc = context.read<TransactionBloc>();
      final budgetBloc = context.read<BudgetManagementBloc>();
      await transactionBloc.transactionUsecases.addTransaction(transaction);

      
      if (mounted) {
        
        budgetBloc.add(const BudgetManagementDataRequested());
        
        
        transactionBloc.add(const TransactionDataRequested());
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

class _EnhancedBudgetSelector extends StatefulWidget {
  final List<TransactionItem> transactionItems;
  final String? selectedItemId;
  final ValueChanged<String> onItemSelected;
  final String Function(double) formatCurrency;
  final VoidCallback onCreateBudget;

  const _EnhancedBudgetSelector({
    required this.transactionItems,
    required this.selectedItemId,
    required this.onItemSelected,
    required this.formatCurrency,
    required this.onCreateBudget,
  });

  @override
  State<_EnhancedBudgetSelector> createState() => _EnhancedBudgetSelectorState();
}

class _EnhancedBudgetSelectorState extends State<_EnhancedBudgetSelector> {
  late TextEditingController _searchController;
  late List<TransactionItem> _filteredItems;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.transactionItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        if (query.isEmpty) {
          _filteredItems = widget.transactionItems;
        } else {
          _filteredItems = widget.transactionItems
              .where((item) {
                final searchQuery = query.toLowerCase();
                
                if (item.name.toLowerCase().contains(searchQuery)) {
                  return true;
                }
                
                if (item.description.toLowerCase().contains(searchQuery)) {
                  return true;
                }
                
                if (item.budget != null && item.budget!.description.toLowerCase().contains(searchQuery)) {
                  return true;
                }
                return false;
              })
              .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
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
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.selectBudgetPlan,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
          ),
          
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
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
                  borderSide: const BorderSide(color: Color(0xFF667eea)),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          
          const SizedBox(height: 16),
          
          
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filteredItems.length} dari ${widget.transactionItems.length} budget plans',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 8),
          
          
          if (widget.transactionItems.isEmpty) ...[
            
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667eea).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.noBudgetPlans,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.createBudgetPlanToTrack,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: widget.onCreateBudget,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF667eea),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          label: Text(
                            AppLocalizations.of(context)!.createBudgetPlan,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            
            Expanded(
              child: _filteredItems.isEmpty
                  ? _buildEmptySearchState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final transactionItem = _filteredItems[index];
                        final isSelected = transactionItem.id == widget.selectedItemId;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                widget.onItemSelected(transactionItem.id);
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
                                      child: Icon(
                                        transactionItem.icon,
                                        color: transactionItem.color,
                                        size: 20,
                                      ),
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
                                              if (transactionItem.isBudgetPlan && transactionItem.budget != null) ...[
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: _getPeriodColor(transactionItem.budget!.period).withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: _getPeriodColor(transactionItem.budget!.period).withValues(alpha: 0.3)),
                                                  ),
                                                  child: Text(
                                                    _getLocalizedPeriodName(transactionItem.budget!.period),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w500,
                                                      color: _getPeriodColor(transactionItem.budget!.period),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          if (transactionItem.isBudgetPlan) ...[
                                            Text(
                                              transactionItem.remainingAmount > 0 
                                                  ? 'Sisa: ${widget.formatCurrency(transactionItem.remainingAmount)} dari ${widget.formatCurrency(transactionItem.budget?.amount ?? 0)}'
                                                  : '${AppLocalizations.of(context)!.overBudget}: ${widget.formatCurrency(transactionItem.remainingAmount.abs())} dari ${widget.formatCurrency(transactionItem.budget?.amount ?? 0)}',
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
                      },
                    ),
            ),
          ],
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noBudgetsFound,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tryAdjustingSearchTerm,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
              child: Text(l10n.clearSearch),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedPeriodName(BudgetPeriod period) {
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

  Color _getPeriodColor(BudgetPeriod period) {
    switch (period) {
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