import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ms.dart';


abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  
  
  
  
  
  
  
  
  
  
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ms'),
  ];

  
  
  
  
  String get appName;

  
  
  
  
  String get welcomeTitle;

  
  
  
  
  String get welcomeSubtitle;

  
  
  
  
  String get getStarted;

  
  
  
  
  String get onboardingChooseLanguage;

  
  
  
  
  String get onboardingSelectPreferredLanguage;

  
  
  
  
  String get onboardingSkip;

  
  
  
  
  String get onboardingTrackExpensesTitle;

  
  
  
  
  String get onboardingTrackExpensesSubtitle;

  
  
  
  
  String get onboardingSmartCategoriesTitle;

  
  
  
  
  String get onboardingSmartCategoriesSubtitle;

  
  
  
  
  String get onboardingFinancialInsightsTitle;

  
  
  
  
  String get onboardingFinancialInsightsSubtitle;

  
  
  
  
  String get onboardingSecurePrivateTitle;

  
  
  
  
  String get onboardingSecurePrivateSubtitle;

  
  
  
  
  String get onboardingCurrencyTitle;

  
  
  
  
  String get onboardingCurrencySubtitle;

  
  
  
  
  String get home;

  
  
  
  
  String get transactions;

  
  
  
  
  String get profile;

  
  
  
  
  String get settings;

  
  
  
  
  String get categories;

  
  
  
  
  String get reportBug;

  
  
  
  
  String get helpSupport;

  
  
  
  
  String get about;

  
  
  
  
  String get backupRestore;

  
  
  
  
  String get cashflowManager;

  
  
  
  
  String get manageYourFinances;

  
  
  
  
  String get debugInformation;

  
  
  
  
  String get copyDebugInfo;

  
  
  
  
  String get debugInfoCopied;

  
  
  
  
  String get bugReportTitle;

  
  
  
  
  String get bugReportSubtitle;

  
  
  
  
  String get bugDescription;

  
  
  
  
  String get bugTitleRequired;

  
  
  
  
  String get bugTitleHint;

  
  
  
  
  String get bugDescriptionRequired;

  
  
  
  
  String get bugDescriptionHint;

  
  
  
  
  String get bugDescriptionError;

  
  
  
  
  String get stepsToReproduce;

  
  
  
  
  String get stepsToReproduceRequired;

  
  
  
  
  String get stepsToReproduceHint;

  
  
  
  
  String get stepsToReproduceError;

  
  
  
  
  String get expectedBehavior;

  
  
  
  
  String get expectedBehaviorHint;

  
  
  
  
  String get debugInfoAutoIncluded;

  
  
  
  
  String get appVersion;

  
  
  
  
  String get platform;

  
  
  
  
  String get buildMode;

  
  
  
  
  String get submitBugReport;

  
  
  
  
  String get bugReportSubmitted;

  
  
  
  
  String get bugReportSubmittedMessage;

  
  
  
  
  String get bugReportSubmittingMessage;

  
  
  
  
  String get bugReportFailed;

  
  
  
  
  String get expectedBehaviorRequired;

  
  
  
  
  String get expectedBehaviorError;

  
  
  
  
  String get actualBehaviorRequired;

  
  
  
  
  String get actualBehaviorHint;

  
  
  
  
  String get actualBehaviorError;

  
  
  
  
  String get deviceInfoLoading;

  
  
  
  
  String get bugReportFailedMessage;

  
  
  
  
  String get debugModeYes;

  
  
  
  
  String get debugModeNo;

  
  
  
  
  String get buildModeDebug;

  
  
  
  
  String get buildModeRelease;

  
  
  
  
  String get buildModeProfile;

  
  
  
  
  String get notSpecified;

  
  
  
  
  String get language;

  
  
  
  
  String get selectLanguage;

  
  
  
  
  String get english;

  
  
  
  
  String get indonesian;

  
  
  
  
  String get malaysian;

  
  
  
  
  String get appearance;

  
  
  
  
  String get theme;

  
  
  
  
  String get systemDefault;

  
  
  
  
  String get fontSize;

  
  
  
  
  String get medium;

  
  
  
  
  String get dataPrivacy;

  
  
  
  
  String get backupRestoreSubtitle;

  
  
  
  
  String get clearData;

  
  
  
  
  String get clearDataSubtitle;

  
  
  
  
  String get clearDataConfirmation;

  
  
  
  
  String get dataCleared;

  
  
  
  
  String get notifications;

  
  
  
  
  String get enableNotifications;

  
  
  
  
  String get receiveReminders;

  
  
  
  
  String get dailyReminders;

  
  
  
  
  String get dailyRemindersSubtitle;

  
  
  
  
  String get cancel;

  
  
  
  
  String get ok;

  
  
  
  
  String get dashboardGoodMorning;

  
  
  
  
  String get dashboardWelcomeBack;

  
  
  
  
  String get dashboardTotalBalance;

  
  
  
  
  String get dashboardTrendFromLastMonth;

  
  
  
  
  String get dashboardIncome;

  
  
  
  
  String get dashboardExpenses;

  
  
  
  
  String get dashboardQuickActions;

  
  
  
  
  String get dashboardAddIncome;

  
  
  
  
  String get dashboardAddExpense;

  
  
  
  
  String get dashboardTransfer;

  
  
  
  
  String get dashboardBudget;

  
  
  
  
  String get dashboardSpendingCategories;

  
  
  
  
  String get dashboardChartPlaceholder;

  
  
  
  
  String get dashboardFoodDining;

  
  
  
  
  String get dashboardTransportation;

  
  
  
  
  String get dashboardShopping;

  
  
  
  
  String get dashboardBills;

  
  
  
  
  String get dashboardRecentTransactions;

  
  
  
  
  String get dashboardSeeAll;

  
  
  
  
  String get dashboardStarbucksCoffee;

  
  
  
  
  String get dashboardGrabTransport;

  
  
  
  
  String get dashboardSalaryDeposit;

  
  
  
  
  String get dashboardMoreTransactionsSoon;

  
  
  
  
  String get currencyUSD;

  
  
  
  
  String get currencyEUR;

  
  
  
  
  String get currencyIDR;

  
  
  
  
  String get currencyMYR;

  
  
  
  
  String get currencyGBP;

  
  
  
  
  String get currencyJPY;

  
  
  
  
  String get currencySGD;

  
  
  
  
  String get selectCurrency;

  
  
  
  
  String get currency;

  
  
  
  
  String get currencySettings;

  
  
  
  
  String get changeCurrency;

  
  
  
  
  String get changeLanguage;

  
  
  
  
  String get noCurrenciesFound;

  
  
  
  
  String get tryAdjustingSearch;

  
  
  
  
  String get searchCurrencies;

  
  
  
  
  String get budgetManagement;

  
  
  
  
  String get budgetCategories;

  
  
  
  
  String get budgetPlans;

  
  
  
  
  String get add;

  
  
  
  
  String get update;

  
  
  
  
  String get budgetOverview;

  
  
  
  
  String get totalBudget;

  
  
  
  
  String get spent;

  
  
  
  
  String get remaining;

  
  
  
  
  String get progress;

  
  
  
  
  String get edit;

  
  
  
  
  String get delete;

  
  
  
  
  String get budgetPeriodWeekly;

  
  
  
  
  String get budgetPeriodMonthly;

  
  
  
  
  String get budgetPeriodQuarterly;

  
  
  
  
  String get budgetPeriodYearly;

  
  
  
  
  String get createBudgetPlan;

  
  
  
  
  String get editBudgetPlan;

  
  
  
  
  String get planYourSpending;

  
  
  
  
  String get updateYourBudget;

  
  
  
  
  String get setBudgetDescription;

  
  
  
  
  String get modifyBudgetDescription;

  
  
  
  
  String get budgetName;

  
  
  
  
  String get budgetNameRequired;

  
  
  
  
  String get category;

  
  
  
  
  String get selectCategory;

  
  
  
  
  String get selectCategoryError;

  
  
  
  
  String get amount;

  
  
  
  
  String get enterAmount;

  
  
  
  
  String get invalidAmount;

  
  
  
  
  String get period;

  
  
  
  
  String get selectPeriod;

  
  
  
  
  String get noCategoriesAvailable;

  
  
  
  
  String get createCategoriesFirst;

  
  
  
  
  String get noBudgetPlansYet;

  
  
  
  
  String get deleteBudgetPlan;

  
  
  
  
  String get budgetCreatedSuccess;

  
  
  
  
  String get budgetUpdatedSuccess;

  
  
  
  
  String get budgetDeletedSuccess;

  
  
  
  
  String get createNewBudgetPlan;

  
  
  
  
  String get sortBy;

  
  
  
  
  String get sortByAmount;

  
  
  
  
  String get sortByName;

  
  
  
  
  String get sortByDate;

  
  
  
  
  String get sortByCategory;

  
  
  
  
  String get ascending;

  
  
  
  
  String get descending;

  
  
  
  
  String get setupBudgetDialog;

  
  
  
  
  String get updateBudgetDialog;

  
  
  
  
  String get categoryTypeIncome;

  
  
  
  
  String get categoryTypeExpense;

  
  
  
  
  String get categoryFoodDining;

  
  
  
  
  String get categoryFoodDiningDesc;

  
  
  
  
  String get categoryTransportation;

  
  
  
  
  String get categoryTransportationDesc;

  
  
  
  
  String get categoryShopping;

  
  
  
  
  String get categoryShoppingDesc;

  
  
  
  
  String get categoryBillsUtilities;

  
  
  
  
  String get categoryBillsUtilitiesDesc;

  
  
  
  
  String get categoryHealthcare;

  
  
  
  
  String get categoryHealthcareDesc;

  
  
  
  
  String get categoryEntertainment;

  
  
  
  
  String get categoryEntertainmentDesc;

  
  
  
  
  String get categoryEducation;

  
  
  
  
  String get categoryEducationDesc;

  
  
  
  
  String get categoryTravel;

  
  
  
  
  String get categoryTravelDesc;

  
  
  
  
  String get categorySalary;

  
  
  
  
  String get categorySalaryDesc;

  
  
  
  
  String get categoryFreelance;

  
  
  
  
  String get categoryFreelanceDesc;

  
  
  
  
  String get categoryBusiness;

  
  
  
  
  String get categoryBusinessDesc;

  
  
  
  
  String get categoryInvestment;

  
  
  
  
  String get categoryInvestmentDesc;

  
  
  
  
  String get categoryBonus;

  
  
  
  
  String get categoryBonusDesc;

  
  
  
  
  String get categoryOtherIncome;

  
  
  
  
  String get categoryOtherIncomeDesc;

  
  
  
  
  String get noBudgetPlansMessage;

  
  
  
  
  String get loadingBudgetPlans;

  
  
  
  
  String deleteBudgetConfirmation(String budgetName);

  
  
  
  
  String get pleaseSelectCategory;

  
  
  
  
  String get activePlans;

  
  
  
  
  String get budgetNameHint;

  
  
  
  
  String get budgetAmountHint;

  
  
  
  
  String get budgetNotesHint;

  
  
  
  
  String get budgetDescription;

  
  
  
  
  String selectCategoryWithCount(Object count);

  
  
  
  
  String get error;

  
  
  
  
  String get addTransaction;

  
  
  
  
  String get addIncome;

  
  
  
  
  String get addExpense;

  
  
  
  
  String get transactionTitle;

  
  
  
  
  String get transactionTitleHint;

  
  
  
  
  String get transactionTitleRequired;

  
  
  
  
  String get transactionAmount;

  
  
  
  
  String get transactionAmountHint;

  
  
  
  
  String get transactionAmountRequired;

  
  
  
  
  String get transactionAmountInvalid;

  
  
  
  
  String get transactionDescription;

  
  
  
  
  String get transactionDescriptionHint;

  
  
  
  
  String get transactionCategory;

  
  
  
  
  String get transactionCategoryRequired;

  
  
  
  
  String get transactionTypeRequired;

  
  
  
  
  String get others;

  
  
  
  
  String get transactionDate;

  
  
  
  
  String get transactionType;

  
  
  
  
  String get income;

  
  
  
  
  String get expense;

  
  
  
  
  String get budgetRemaining;

  
  
  
  
  String get budgetOverLimit;

  
  
  
  
  String get budgetPreview;

  
  
  
  
  String get budgetUsed;

  
  
  
  
  String get budgetTotal;

  
  
  
  
  String get budgetAfterTransaction;

  
  
  
  
  String get saveTransaction;

  
  
  
  
  String get transactionSaved;

  
  
  
  
  String get transactionSaveFailed;

  
  
  
  
  String get filterToday;

  
  
  
  
  String get filterThisWeek;

  
  
  
  
  String get filterThisMonth;

  
  
  
  
  String get filterThisYear;

  
  
  
  
  String get filterSpecificDate;

  
  
  
  
  String get dateToday;

  
  
  
  
  String get dateYesterday;

  
  
  
  
  String get transactionDetails;

  
  
  
  
  String get deleteTransaction;

  
  
  
  
  String get deleteTransactionConfirmation;

  
  
  
  
  String get transactionDeleted;

  
  
  
  
  String get editTransaction;

  
  
  
  
  String get budgetImpact;

  
  
  
  
  String get currentBudgetUsage;

  
  
  
  
  String get afterThisTransaction;

  
  
  
  
  String get budgetStatus;

  
  
  
  
  String get withinBudget;

  
  
  
  
  String get overBudget;

  
  
  
  
  String get budgetPlan;

  
  
  
  
  String get noBudgetPlan;

  
  
  
  
  String get deleteConfirmationTitle;

  
  
  
  
  String get deleteConfirmationMessage;

  
  
  
  
  String get deleteConfirmationWarning;

  
  
  
  
  String get all;

  
  
  
  
  String get balance;

  
  
  
  
  String get retry;

  
  
  
  
  String get transactionNotFound;

  
  
  
  
  String get details;

  
  
  
  
  String get type;

  
  
  
  
  String get description;

  
  
  
  
  String get time;

  
  
  
  
  String get budget;

  
  
  
  
  String get timeline;

  
  
  
  
  String get created;

  
  
  
  
  String get lastUpdated;

  
  
  
  
  String get editFunctionalityComingSoon;

  
  
  
  
  String get noTransactionsFound;

  
  
  
  
  String get tryAdjustingFilters;

  
  
  
  
  String get startAddingTransactions;

  
  
  
  
  String get thisBudgetIsOverBy;

  
  
  
  
  String get selectBudget;

  
  
  
  
  String get showAllTransactions;

  
  
  
  
  String get noBudgetPlans;

  
  
  
  
  String get selectBudgetPlan;

  
  
  
  
  String get searchBudgets;

  
  
  
  
  String get noBudgetsFound;

  
  
  
  
  String get tryAdjustingSearchTerm;

  
  
  
  
  String get clearSearch;

  
  
  
  
  String get budgetDetailsLoading;

  
  
  
  
  String get calculatingRemaining;

  
  
  
  
  String budgetCount(int count, int total);

  
  
  
  
  String get createBudgetPlanDescription;

  
  
  
  
  String get whatWouldYouLikeToDo;

  
  
  
  
  String get createBudgetPlanToTrack;

  
  
  
  
  String get currencyThousands;

  
  
  
  
  String get currencyMillions;

  
  
  
  
  String get currencyBillions;

  
  
  
  
  String get privacyPolicy;

  
  
  
  
  String get termsOfService;

  
  
  
  
  String get dataUsage;

  
  
  
  
  String get localDataStorage;

  
  
  
  
  String get dataStorageDescription;

  
  
  
  
  String get dataSecurityTitle;

  
  
  
  
  String get dataSecurityDescription;

  
  
  
  
  String get dataControlTitle;

  
  
  
  
  String get dataControlDescription;

  
  
  
  
  String get noThirdPartySharing;

  
  
  
  
  String get noThirdPartySharingDescription;

  
  
  
  
  String get contactUs;

  
  
  
  
  String get appPurpose;

  
  
  
  
  String get appPurposeDescription;

  
  
  
  
  String get openSource;

  
  
  
  
  String get version;

  
  
  
  
  String get buildDate;

  
  
  
  
  String get developer;

  
  
  
  
  String get acknowledgments;

  
  
  
  
  String get shareSuggestion;

  
  
  
  
  String get suggestionTitle;

  
  
  
  
  String get suggestionSubtitle;

  
  
  
  
  String get suggestionTitleRequired;

  
  
  
  
  String get suggestionTitleHint;

  
  
  
  
  String get suggestionTitleError;

  
  
  
  
  String get suggestionDescription;

  
  
  
  
  String get suggestionDescriptionHint;

  
  
  
  
  String get suggestionDescriptionError;

  
  
  
  
  String get suggestionUseCase;

  
  
  
  
  String get suggestionUseCaseHint;

  
  
  
  
  String get suggestionUseCaseError;

  
  
  
  
  String get systemInformation;

  
  
  
  
  String get systemInfoAutoIncluded;

  
  
  
  
  String get submitSuggestion;

  
  
  
  
  String get submittingSuggestion;

  
  
  
  
  String get featureRequestCopied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ms':
      return AppLocalizationsMs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
