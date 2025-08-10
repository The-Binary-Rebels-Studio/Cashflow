import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/features/budget_management/data/models/predefined_categories_data.dart';
import 'package:cashflow/features/budget_management/data/models/category_model.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';

@injectable
class LocalizedCategoryService {
  
  List<CategoryModel> getLocalizedExpenseCategories(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final now = DateTime.now();
    
    return PredefinedCategoriesData.expenseCategories.map((categoryData) {
      final nameKey = categoryData['nameKey'] as String;
      final descKey = categoryData['descriptionKey'] as String;
      
      // Get localized text based on key
      String name = _getLocalizedText(localizations, nameKey);
      String description = _getLocalizedText(localizations, descKey);
      
      return CategoryModel(
        id: _generateId(),
        name: name,
        description: description,
        iconCodePoint: categoryData['icon_code_point'] as String,
        colorValue: categoryData['color_value'] as String,
        type: CategoryType.expense,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
    }).toList();
  }
  
  List<CategoryModel> getLocalizedIncomeCategories(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final now = DateTime.now();
    
    return PredefinedCategoriesData.incomeCategories.map((categoryData) {
      final nameKey = categoryData['nameKey'] as String;
      final descKey = categoryData['descriptionKey'] as String;
      
      // Get localized text based on key
      String name = _getLocalizedText(localizations, nameKey);
      String description = _getLocalizedText(localizations, descKey);
      
      return CategoryModel(
        id: _generateId(),
        name: name,
        description: description,
        iconCodePoint: categoryData['icon_code_point'] as String,
        colorValue: categoryData['color_value'] as String,
        type: CategoryType.income,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
    }).toList();
  }
  
  String _getLocalizedText(AppLocalizations localizations, String key) {
    switch (key) {
      // Expense categories
      case 'categoryFoodDining': return localizations.categoryFoodDining;
      case 'categoryFoodDiningDesc': return localizations.categoryFoodDiningDesc;
      case 'categoryTransportation': return localizations.categoryTransportation;
      case 'categoryTransportationDesc': return localizations.categoryTransportationDesc;
      case 'categoryShopping': return localizations.categoryShopping;
      case 'categoryShoppingDesc': return localizations.categoryShoppingDesc;
      case 'categoryBillsUtilities': return localizations.categoryBillsUtilities;
      case 'categoryBillsUtilitiesDesc': return localizations.categoryBillsUtilitiesDesc;
      case 'categoryHealthcare': return localizations.categoryHealthcare;
      case 'categoryHealthcareDesc': return localizations.categoryHealthcareDesc;
      case 'categoryEntertainment': return localizations.categoryEntertainment;
      case 'categoryEntertainmentDesc': return localizations.categoryEntertainmentDesc;
      case 'categoryEducation': return localizations.categoryEducation;
      case 'categoryEducationDesc': return localizations.categoryEducationDesc;
      case 'categoryTravel': return localizations.categoryTravel;
      case 'categoryTravelDesc': return localizations.categoryTravelDesc;
      
      // Income categories
      case 'categorySalary': return localizations.categorySalary;
      case 'categorySalaryDesc': return localizations.categorySalaryDesc;
      case 'categoryFreelance': return localizations.categoryFreelance;
      case 'categoryFreelanceDesc': return localizations.categoryFreelanceDesc;
      case 'categoryBusiness': return localizations.categoryBusiness;
      case 'categoryBusinessDesc': return localizations.categoryBusinessDesc;
      case 'categoryInvestment': return localizations.categoryInvestment;
      case 'categoryInvestmentDesc': return localizations.categoryInvestmentDesc;
      case 'categoryBonus': return localizations.categoryBonus;
      case 'categoryBonusDesc': return localizations.categoryBonusDesc;
      case 'categoryOtherIncome': return localizations.categoryOtherIncome;
      case 'categoryOtherIncomeDesc': return localizations.categoryOtherIncomeDesc;
      
      default: return key; // Fallback to key if not found
    }
  }
  
  String _generateId() {
    return 'cat_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
  }
}