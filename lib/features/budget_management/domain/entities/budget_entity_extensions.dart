import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'budget_entity.dart';
import 'category_entity.dart';

extension BudgetPeriodLocalization on BudgetPeriod {
  String localizedDisplayName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case BudgetPeriod.weekly:
        return localizations.budgetPeriodWeekly;
      case BudgetPeriod.monthly:
        return localizations.budgetPeriodMonthly;
      case BudgetPeriod.quarterly:
        return localizations.budgetPeriodQuarterly;
      case BudgetPeriod.yearly:
        return localizations.budgetPeriodYearly;
    }
  }
}

extension CategoryTypeLocalization on CategoryType {
  String localizedDisplayName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case CategoryType.income:
        return localizations.categoryTypeIncome;
      case CategoryType.expense:
        return localizations.categoryTypeExpense;
    }
  }
}

extension CategoryEntityLocalization on CategoryEntity {
  String localizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // Map English category names to localized keys
    switch (name.toLowerCase()) {
      case 'food & dining':
        return localizations.categoryFoodDining;
      case 'transportation':
        return localizations.categoryTransportation;
      case 'shopping':
        return localizations.categoryShopping;
      case 'bills & utilities':
        return localizations.categoryBillsUtilities;
      case 'healthcare':
        return localizations.categoryHealthcare;
      case 'entertainment':
        return localizations.categoryEntertainment;
      case 'education':
        return localizations.categoryEducation;
      case 'travel':
        return localizations.categoryTravel;
      case 'salary':
        return localizations.categorySalary;
      case 'freelance':
        return localizations.categoryFreelance;
      case 'business':
        return localizations.categoryBusiness;
      case 'investment':
        return localizations.categoryInvestment;
      case 'bonus':
        return localizations.categoryBonus;
      case 'other income':
        return localizations.categoryOtherIncome;
      default:
        // Fallback to original name if no localization found
        return name;
    }
  }
}