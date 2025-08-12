import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_bloc.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_event.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_state.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity_extensions.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/services/currency_event.dart';

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

// Helper function to format number with thousands separator
String formatNumberWithSeparator(double number) {
  final formatter = ThousandsSeparatorInputFormatter();
  final intValue = number.toInt().toString();

  // Use formatter to add separators
  final textEditingValue = TextEditingValue(text: intValue);
  final formattedValue = formatter.formatEditUpdate(
    const TextEditingValue(text: ''),
    textEditingValue,
  );

  return formattedValue.text;
}

class CreateBudgetPage extends StatelessWidget {
  final BudgetEntity? budget;

  const CreateBudgetPage({super.key, this.budget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<BudgetManagementBloc>()),
        BlocProvider.value(value: getIt<CurrencyBloc>()),
      ],
      child: _CreateBudgetView(budget: budget),
    );
  }
}

class _CreateBudgetView extends StatefulWidget {
  final BudgetEntity? budget;

  const _CreateBudgetView({this.budget});

  @override
  State<_CreateBudgetView> createState() => _CreateBudgetViewState();
}

class _CreateBudgetViewState extends State<_CreateBudgetView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategoryId;
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize budget management data to load categories
    context.read<BudgetManagementBloc>().add(const BudgetManagementInitialized());
    // Initialize currency service to load saved currency
    context.read<CurrencyBloc>().add(const CurrencyInitialized());

    if (widget.budget != null) {
      _nameController.text = widget.budget!.name;
      // Format amount with thousands separator for display
      _amountController.text = formatNumberWithSeparator(widget.budget!.amount);
      _descriptionController.text = widget.budget!.description;
      _selectedCategoryId = widget.budget!.categoryId;
      _selectedPeriod = widget.budget!.period;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.budget != null;

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
          isEditing
              ? AppLocalizations.of(context)!.editBudgetPlan
              : AppLocalizations.of(context)!.createBudgetPlan,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(),
            ),
        ],
      ),
      body: BlocConsumer<BudgetManagementBloc, BudgetManagementState>(
        listener: (context, state) {
          if (state is BudgetManagementOperationSuccess) {
            // Show success message
            String localizedMessage;
            switch (state.message) {
              case 'budgetCreatedSuccess':
                localizedMessage = AppLocalizations.of(context)!.budgetCreatedSuccess;
                break;
              case 'budgetUpdatedSuccess':
                localizedMessage = AppLocalizations.of(context)!.budgetUpdatedSuccess;
                break;
              case 'budgetDeletedSuccess':
                localizedMessage = AppLocalizations.of(context)!.budgetDeletedSuccess;
                break;
              default:
                localizedMessage = state.message; // Fallback to original message
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizedMessage),
                backgroundColor: Colors.green,
              ),
            );
            // Close the page after successful operation
            context.pop();
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
          return SingleChildScrollView(
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
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
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
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isEditing
                              ? AppLocalizations.of(context)!.updateYourBudget
                              : AppLocalizations.of(context)!.planYourSpending,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isEditing
                              ? AppLocalizations.of(
                                  context,
                                )!.modifyBudgetDescription
                              : AppLocalizations.of(
                                  context,
                                )!.setBudgetDescription,
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

                  // Budget Name
                  _buildFormSection(
                    AppLocalizations.of(context)!.budgetName,
                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration(
                        hintText: AppLocalizations.of(context)!.budgetNameHint,
                        prefixIcon: Icons.edit_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(
                            context,
                          )!.budgetNameRequired;
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category Selection
                  _buildFormSection(
                    AppLocalizations.of(context)!.category,
                    BlocBuilder<BudgetManagementBloc, BudgetManagementState>(
                      builder: (context, state) {
                        final categories = state is BudgetManagementLoaded
                            ? state.expenseCategories
                            : <CategoryEntity>[];
                        final validCategories = categories
                            .where(
                              (category) =>
                                  category.id.isNotEmpty &&
                                  category.name.isNotEmpty &&
                                  category.colorValue.isNotEmpty &&
                                  category.iconCodePoint.isNotEmpty &&
                                  category.type == CategoryType.expense,
                            )
                            .toList();

                        final selectedCategory = validCategories
                            .where((cat) => cat.id == _selectedCategoryId)
                            .firstOrNull;

                        return GestureDetector(
                          onTap: () => _showCategoryPicker(validCategories),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: _buildContainerDecoration(),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.category_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                if (selectedCategory != null) ...[
                                  _buildCategoryDisplay(selectedCategory),
                                ] else ...[
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.selectCategory,
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
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Amount and Period Row
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildFormSection(
                          AppLocalizations.of(context)!.amount,
                          BlocBuilder<CurrencyBloc, dynamic>(
                            builder: (context, currencyState) {
                              final currencyBloc = context
                                  .read<CurrencyBloc>();
                              final currencySymbol =
                                  currencyBloc.selectedCurrency.symbol;

                              return TextFormField(
                                controller: _amountController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(
                                    context,
                                  )!.budgetAmountHint,
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
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
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
                                    return AppLocalizations.of(
                                      context,
                                    )!.enterAmount;
                                  }
                                  // Remove thousands separators for validation
                                  final rawValue = getRawNumber(value);
                                  final amount = double.tryParse(rawValue);
                                  if (amount == null || amount <= 0) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.invalidAmount;
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
                          AppLocalizations.of(context)!.period,
                          GestureDetector(
                            onTap: _showPeriodPicker,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: _buildContainerDecoration(),
                              child: Row(
                                children: [
                                  Icon(
                                    _getPeriodIcon(_selectedPeriod),
                                    size: 16,
                                    color: const Color(0xFF667eea),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _formatPeriod(_selectedPeriod),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Colors.grey,
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

                  // Description
                  _buildFormSection(
                    AppLocalizations.of(context)!.budgetDescription,
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.budgetNotesHint,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 64,
                          ), // Sesuaikan untuk multiline
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

                  const SizedBox(height: 40),

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
                          onPressed: _isLoading ? null : _saveBudgetPlan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667eea),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      isEditing ? l10n.update : l10n.add,
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
          );
        },
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
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, size: 20, color: Colors.grey),
      prefixText: prefixText,
      prefixStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
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

  Widget _buildCategoryDisplay(CategoryEntity category) {
    Color categoryColor;
    try {
      categoryColor = Color(int.parse(category.colorValue));
    } catch (e) {
      categoryColor = Colors.grey;
    }

    IconData iconData;
    try {
      iconData = IconData(
        int.parse(category.iconCodePoint),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      iconData = Icons.category;
    }

    return Expanded(
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(iconData, color: categoryColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.localizedName(context),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'EXP',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: categoryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker(List<CategoryEntity> categories) {
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
                    AppLocalizations.of(
                      context,
                    )!.selectCategoryWithCount(categories.length),
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
            // Categories List or Empty State
            Expanded(
              child: categories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Categories Available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please create some categories first',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category.id == _selectedCategoryId;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedCategoryId = category.id;
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
                                      ? const Color(
                                          0xFF667eea,
                                        ).withValues(alpha: 0.05)
                                      : Colors.white,
                                ),
                                child: _buildCategoryDisplay(category),
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

  void _showPeriodPicker() {
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
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.selectPeriod,
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
            // Periods List
            ...BudgetPeriod.values.map((period) {
              final isSelected = period == _selectedPeriod;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPeriod = period;
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
                          Icon(
                            _getPeriodIcon(period),
                            color: isSelected
                                ? const Color(0xFF667eea)
                                : Colors.grey[600],
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _formatPeriod(period),
                              style: TextStyle(
                                fontSize: 18,
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
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.delete_outline, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.deleteBudgetPlan),
          ],
        ),
        content: Text(
          AppLocalizations.of(
            context,
          )!.deleteBudgetConfirmation(widget.budget?.name ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BudgetManagementBloc>().add(BudgetDeleteRequested(
                id: widget.budget!.id,
              ));
              Navigator.of(context).pop(); // Close dialog
              // Don't manually close screen - let BlocConsumer handle success state
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _saveBudgetPlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate category selection
    if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectCategory),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      // Remove thousands separators before parsing
      final rawAmount = getRawNumber(_amountController.text);
      final amount = double.parse(rawAmount);
      final description = _descriptionController.text.trim();

      final bloc = context.read<BudgetManagementBloc>();

      if (widget.budget != null) {
        final updatedBudget = BudgetEntity(
          id: widget.budget!.id,
          name: name,
          description: description,
          categoryId: _selectedCategoryId!,
          amount: amount,
          period: _selectedPeriod,
          startDate: widget.budget!.startDate,
          endDate: widget.budget!.endDate,
          createdAt: widget.budget!.createdAt,
          updatedAt: DateTime.now(),
        );
        bloc.add(BudgetUpdateRequested(budget: updatedBudget));
      } else {
        bloc.add(BudgetCreateRequested(
          name: name,
          description: description,
          categoryId: _selectedCategoryId!,
          amount: amount,
          period: _selectedPeriod,
        ));
      }

      // Success will be handled by BlocConsumer listener
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.error}: ${e.toString()}',
            ),
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

  String _formatPeriod(BudgetPeriod period) {
    return period.localizedDisplayName(context);
  }

  IconData _getPeriodIcon(BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        return Icons.calendar_view_week;
      case BudgetPeriod.monthly:
        return Icons.calendar_month;
      case BudgetPeriod.quarterly:
        return Icons.calendar_view_month;
      case BudgetPeriod.yearly:
        return Icons.calendar_today;
    }
  }
}
