import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ms.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ms'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CashFlow'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CashFlow'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your expenses and manage your finances with ease'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get onboardingChooseLanguage;

  /// No description provided for @onboardingSelectPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get onboardingSelectPreferredLanguage;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingTrackExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Your Expenses'**
  String get onboardingTrackExpensesTitle;

  /// No description provided for @onboardingTrackExpensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor your spending habits and see where your money goes'**
  String get onboardingTrackExpensesSubtitle;

  /// No description provided for @onboardingSmartCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Categories'**
  String get onboardingSmartCategoriesTitle;

  /// No description provided for @onboardingSmartCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize your transactions with intelligent categorization'**
  String get onboardingSmartCategoriesSubtitle;

  /// No description provided for @onboardingFinancialInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Insights'**
  String get onboardingFinancialInsightsTitle;

  /// No description provided for @onboardingFinancialInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get detailed analytics and insights about your spending patterns'**
  String get onboardingFinancialInsightsSubtitle;

  /// No description provided for @onboardingSecurePrivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure & Private'**
  String get onboardingSecurePrivateTitle;

  /// No description provided for @onboardingSecurePrivateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your financial data is encrypted and stored securely on your device'**
  String get onboardingSecurePrivateSubtitle;

  /// No description provided for @onboardingCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Currency'**
  String get onboardingCurrencyTitle;

  /// No description provided for @onboardingCurrencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred currency for all transactions and calculations'**
  String get onboardingCurrencySubtitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportBug;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// No description provided for @cashflowManager.
  ///
  /// In en, this message translates to:
  /// **'Cashflow Manager'**
  String get cashflowManager;

  /// No description provided for @manageYourFinances.
  ///
  /// In en, this message translates to:
  /// **'Manage your finances'**
  String get manageYourFinances;

  /// No description provided for @debugInformation.
  ///
  /// In en, this message translates to:
  /// **'Debug Information'**
  String get debugInformation;

  /// No description provided for @copyDebugInfo.
  ///
  /// In en, this message translates to:
  /// **'Copy Debug Info'**
  String get copyDebugInfo;

  /// No description provided for @debugInfoCopied.
  ///
  /// In en, this message translates to:
  /// **'Debug info copied to clipboard'**
  String get debugInfoCopied;

  /// No description provided for @bugReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get bugReportTitle;

  /// No description provided for @bugReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve CashFlow by reporting bugs you encounter.'**
  String get bugReportSubtitle;

  /// No description provided for @bugDescription.
  ///
  /// In en, this message translates to:
  /// **'Bug Description'**
  String get bugDescription;

  /// No description provided for @bugTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Bug Title *'**
  String get bugTitleRequired;

  /// No description provided for @bugTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., App crashes when opening budget'**
  String get bugTitleHint;

  /// No description provided for @bugDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Bug Description *'**
  String get bugDescriptionRequired;

  /// No description provided for @bugDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what went wrong...'**
  String get bugDescriptionHint;

  /// No description provided for @bugDescriptionError.
  ///
  /// In en, this message translates to:
  /// **'Please describe the bug'**
  String get bugDescriptionError;

  /// No description provided for @stepsToReproduce.
  ///
  /// In en, this message translates to:
  /// **'Steps to Reproduce'**
  String get stepsToReproduce;

  /// No description provided for @stepsToReproduceRequired.
  ///
  /// In en, this message translates to:
  /// **'Steps to Reproduce *'**
  String get stepsToReproduceRequired;

  /// No description provided for @stepsToReproduceHint.
  ///
  /// In en, this message translates to:
  /// **'1. Go to...\n2. Click on...\n3. See error...'**
  String get stepsToReproduceHint;

  /// No description provided for @stepsToReproduceError.
  ///
  /// In en, this message translates to:
  /// **'Please provide steps to reproduce'**
  String get stepsToReproduceError;

  /// No description provided for @expectedBehavior.
  ///
  /// In en, this message translates to:
  /// **'Expected Behavior'**
  String get expectedBehavior;

  /// No description provided for @expectedBehaviorHint.
  ///
  /// In en, this message translates to:
  /// **'What should have happened?'**
  String get expectedBehaviorHint;

  /// No description provided for @debugInfoAutoIncluded.
  ///
  /// In en, this message translates to:
  /// **'This information will be automatically included:'**
  String get debugInfoAutoIncluded;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @buildMode.
  ///
  /// In en, this message translates to:
  /// **'Build Mode'**
  String get buildMode;

  /// No description provided for @submitBugReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Bug Report'**
  String get submitBugReport;

  /// No description provided for @bugReportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Bug report submitted successfully!'**
  String get bugReportSubmitted;

  /// No description provided for @bugReportSubmittedMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your report! Your feedback is incredibly valuable and helps us improve CashFlow for everyone.'**
  String get bugReportSubmittedMessage;

  /// No description provided for @bugReportSubmittingMessage.
  ///
  /// In en, this message translates to:
  /// **'Submitting your report...'**
  String get bugReportSubmittingMessage;

  /// No description provided for @bugReportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit bug report'**
  String get bugReportFailed;

  /// No description provided for @expectedBehaviorRequired.
  ///
  /// In en, this message translates to:
  /// **'Expected Behavior *'**
  String get expectedBehaviorRequired;

  /// No description provided for @expectedBehaviorError.
  ///
  /// In en, this message translates to:
  /// **'Please describe the expected behavior'**
  String get expectedBehaviorError;

  /// No description provided for @actualBehaviorRequired.
  ///
  /// In en, this message translates to:
  /// **'Actual Behavior *'**
  String get actualBehaviorRequired;

  /// No description provided for @actualBehaviorHint.
  ///
  /// In en, this message translates to:
  /// **'What actually happened?'**
  String get actualBehaviorHint;

  /// No description provided for @actualBehaviorError.
  ///
  /// In en, this message translates to:
  /// **'Please describe what actually happened'**
  String get actualBehaviorError;

  /// No description provided for @deviceInfoLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading device information...'**
  String get deviceInfoLoading;

  /// No description provided for @bugReportFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Please try again or contact support if the issue persists.'**
  String get bugReportFailedMessage;

  /// No description provided for @debugModeYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get debugModeYes;

  /// No description provided for @debugModeNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get debugModeNo;

  /// No description provided for @buildModeDebug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get buildModeDebug;

  /// No description provided for @buildModeRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get buildModeRelease;

  /// No description provided for @buildModeProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get buildModeProfile;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @malaysian.
  ///
  /// In en, this message translates to:
  /// **'Malay'**
  String get malaysian;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataPrivacy;

  /// No description provided for @backupRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export or import your data'**
  String get backupRestoreSubtitle;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// No description provided for @clearDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all your data permanently'**
  String get clearDataSubtitle;

  /// No description provided for @clearDataConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all data? This action cannot be undone.'**
  String get clearDataConfirmation;

  /// No description provided for @dataCleared.
  ///
  /// In en, this message translates to:
  /// **'Data cleared successfully'**
  String get dataCleared;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @receiveReminders.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders and updates'**
  String get receiveReminders;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get dailyReminders;

  /// No description provided for @dailyRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get reminded to track expenses'**
  String get dailyRemindersSubtitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @dashboardGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get dashboardGoodMorning;

  /// No description provided for @dashboardWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to your finances'**
  String get dashboardWelcomeBack;

  /// No description provided for @dashboardTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get dashboardTotalBalance;

  /// No description provided for @dashboardTrendFromLastMonth.
  ///
  /// In en, this message translates to:
  /// **'+12.5% from last month'**
  String get dashboardTrendFromLastMonth;

  /// No description provided for @dashboardIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get dashboardIncome;

  /// No description provided for @dashboardExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get dashboardExpenses;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardAddIncome.
  ///
  /// In en, this message translates to:
  /// **'Add\nIncome'**
  String get dashboardAddIncome;

  /// No description provided for @dashboardAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add\nExpense'**
  String get dashboardAddExpense;

  /// No description provided for @dashboardTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get dashboardTransfer;

  /// No description provided for @dashboardBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get dashboardBudget;

  /// No description provided for @dashboardSpendingCategories.
  ///
  /// In en, this message translates to:
  /// **'Spending Categories'**
  String get dashboardSpendingCategories;

  /// No description provided for @dashboardChartPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Chart Placeholder'**
  String get dashboardChartPlaceholder;

  /// No description provided for @dashboardFoodDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get dashboardFoodDining;

  /// No description provided for @dashboardTransportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get dashboardTransportation;

  /// No description provided for @dashboardShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get dashboardShopping;

  /// No description provided for @dashboardBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get dashboardBills;

  /// No description provided for @dashboardRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get dashboardRecentTransactions;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get dashboardSeeAll;

  /// No description provided for @dashboardStarbucksCoffee.
  ///
  /// In en, this message translates to:
  /// **'Starbucks Coffee'**
  String get dashboardStarbucksCoffee;

  /// No description provided for @dashboardGrabTransport.
  ///
  /// In en, this message translates to:
  /// **'Grab Transport'**
  String get dashboardGrabTransport;

  /// No description provided for @dashboardSalaryDeposit.
  ///
  /// In en, this message translates to:
  /// **'Salary Deposit'**
  String get dashboardSalaryDeposit;

  /// No description provided for @dashboardMoreTransactionsSoon.
  ///
  /// In en, this message translates to:
  /// **'More transactions coming soon'**
  String get dashboardMoreTransactionsSoon;

  /// No description provided for @dashboardNoSpendingDataYet.
  ///
  /// In en, this message translates to:
  /// **'No spending data yet'**
  String get dashboardNoSpendingDataYet;

  /// No description provided for @dashboardOverBudget.
  ///
  /// In en, this message translates to:
  /// **'over budget'**
  String get dashboardOverBudget;

  /// No description provided for @dashboardUsed.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get dashboardUsed;

  /// No description provided for @currencyUSD.
  ///
  /// In en, this message translates to:
  /// **'US Dollar (USD)'**
  String get currencyUSD;

  /// No description provided for @currencyEUR.
  ///
  /// In en, this message translates to:
  /// **'Euro (EUR)'**
  String get currencyEUR;

  /// No description provided for @currencyIDR.
  ///
  /// In en, this message translates to:
  /// **'Indonesian Rupiah (IDR)'**
  String get currencyIDR;

  /// No description provided for @currencyMYR.
  ///
  /// In en, this message translates to:
  /// **'Malaysian Ringgit (MYR)'**
  String get currencyMYR;

  /// No description provided for @currencyGBP.
  ///
  /// In en, this message translates to:
  /// **'British Pound (GBP)'**
  String get currencyGBP;

  /// No description provided for @currencyJPY.
  ///
  /// In en, this message translates to:
  /// **'Japanese Yen (JPY)'**
  String get currencyJPY;

  /// No description provided for @currencySGD.
  ///
  /// In en, this message translates to:
  /// **'Singapore Dollar (SGD)'**
  String get currencySGD;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencySettings.
  ///
  /// In en, this message translates to:
  /// **'Currency Settings'**
  String get currencySettings;

  /// No description provided for @changeCurrency.
  ///
  /// In en, this message translates to:
  /// **'Change Currency'**
  String get changeCurrency;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @noCurrenciesFound.
  ///
  /// In en, this message translates to:
  /// **'No currencies found'**
  String get noCurrenciesFound;

  /// No description provided for @tryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search'**
  String get tryAdjustingSearch;

  /// No description provided for @searchCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Search currencies...'**
  String get searchCurrencies;

  /// No description provided for @budgetManagement.
  ///
  /// In en, this message translates to:
  /// **'Budget Management'**
  String get budgetManagement;

  /// No description provided for @budgetCategories.
  ///
  /// In en, this message translates to:
  /// **'Budget Categories'**
  String get budgetCategories;

  /// No description provided for @budgetPlans.
  ///
  /// In en, this message translates to:
  /// **'Budget Plans'**
  String get budgetPlans;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @budgetOverview.
  ///
  /// In en, this message translates to:
  /// **'Budget Overview'**
  String get budgetOverview;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudget;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @budgetPeriodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get budgetPeriodWeekly;

  /// No description provided for @budgetPeriodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get budgetPeriodMonthly;

  /// No description provided for @budgetPeriodQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get budgetPeriodQuarterly;

  /// No description provided for @budgetPeriodYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get budgetPeriodYearly;

  /// No description provided for @createBudgetPlan.
  ///
  /// In en, this message translates to:
  /// **'Create Budget Plan'**
  String get createBudgetPlan;

  /// No description provided for @editBudgetPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget Plan'**
  String get editBudgetPlan;

  /// No description provided for @planYourSpending.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Spending'**
  String get planYourSpending;

  /// No description provided for @updateYourBudget.
  ///
  /// In en, this message translates to:
  /// **'Update Your Budget'**
  String get updateYourBudget;

  /// No description provided for @setBudgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Set spending limits to manage your finances better'**
  String get setBudgetDescription;

  /// No description provided for @modifyBudgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Modify your budget plan details'**
  String get modifyBudgetDescription;

  /// No description provided for @budgetName.
  ///
  /// In en, this message translates to:
  /// **'Budget Name'**
  String get budgetName;

  /// No description provided for @budgetNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a budget name'**
  String get budgetNameRequired;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategoryError;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @selectPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select Period'**
  String get selectPeriod;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Categories Available'**
  String get noCategoriesAvailable;

  /// No description provided for @createCategoriesFirst.
  ///
  /// In en, this message translates to:
  /// **'Please create some categories first'**
  String get createCategoriesFirst;

  /// No description provided for @noBudgetPlansYet.
  ///
  /// In en, this message translates to:
  /// **'No Budget Plans Yet'**
  String get noBudgetPlansYet;

  /// No description provided for @deleteBudgetPlan.
  ///
  /// In en, this message translates to:
  /// **'Delete Budget Plan'**
  String get deleteBudgetPlan;

  /// No description provided for @budgetCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget plan created successfully'**
  String get budgetCreatedSuccess;

  /// No description provided for @budgetUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget plan updated successfully'**
  String get budgetUpdatedSuccess;

  /// No description provided for @budgetDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget plan deleted successfully'**
  String get budgetDeletedSuccess;

  /// No description provided for @createNewBudgetPlan.
  ///
  /// In en, this message translates to:
  /// **'Create New Budget Plan'**
  String get createNewBudgetPlan;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortByAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get sortByAmount;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortByName;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortByDate;

  /// No description provided for @sortByCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get sortByCategory;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @setupBudgetDialog.
  ///
  /// In en, this message translates to:
  /// **'Set up a new budget to track your spending'**
  String get setupBudgetDialog;

  /// No description provided for @updateBudgetDialog.
  ///
  /// In en, this message translates to:
  /// **'Update your budget plan'**
  String get updateBudgetDialog;

  /// No description provided for @categoryTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoryTypeIncome;

  /// No description provided for @categoryTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get categoryTypeExpense;

  /// No description provided for @categoryFoodDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get categoryFoodDining;

  /// No description provided for @categoryFoodDiningDesc.
  ///
  /// In en, this message translates to:
  /// **'Restaurants, groceries, and food delivery'**
  String get categoryFoodDiningDesc;

  /// No description provided for @categoryTransportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get categoryTransportation;

  /// No description provided for @categoryTransportationDesc.
  ///
  /// In en, this message translates to:
  /// **'Gas, public transport, taxi, and car maintenance'**
  String get categoryTransportationDesc;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryShoppingDesc.
  ///
  /// In en, this message translates to:
  /// **'Clothing, electronics, and general shopping'**
  String get categoryShoppingDesc;

  /// No description provided for @categoryBillsUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills & Utilities'**
  String get categoryBillsUtilities;

  /// No description provided for @categoryBillsUtilitiesDesc.
  ///
  /// In en, this message translates to:
  /// **'Electricity, water, internet, phone bills'**
  String get categoryBillsUtilitiesDesc;

  /// No description provided for @categoryHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get categoryHealthcare;

  /// No description provided for @categoryHealthcareDesc.
  ///
  /// In en, this message translates to:
  /// **'Medical expenses, pharmacy, insurance'**
  String get categoryHealthcareDesc;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryEntertainmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Movies, games, subscriptions, hobbies'**
  String get categoryEntertainmentDesc;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryEducationDesc.
  ///
  /// In en, this message translates to:
  /// **'Books, courses, tuition, school supplies'**
  String get categoryEducationDesc;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categoryTravelDesc.
  ///
  /// In en, this message translates to:
  /// **'Hotels, flights, vacation expenses'**
  String get categoryTravelDesc;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categorySalaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Monthly salary and wages'**
  String get categorySalaryDesc;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @categoryFreelanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Freelance projects and gigs'**
  String get categoryFreelanceDesc;

  /// No description provided for @categoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get categoryBusiness;

  /// No description provided for @categoryBusinessDesc.
  ///
  /// In en, this message translates to:
  /// **'Business income and profit'**
  String get categoryBusinessDesc;

  /// No description provided for @categoryInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get categoryInvestment;

  /// No description provided for @categoryInvestmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Dividends, stock gains, crypto'**
  String get categoryInvestmentDesc;

  /// No description provided for @categoryBonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get categoryBonus;

  /// No description provided for @categoryBonusDesc.
  ///
  /// In en, this message translates to:
  /// **'Work bonus and incentives'**
  String get categoryBonusDesc;

  /// No description provided for @categoryOtherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other Income'**
  String get categoryOtherIncome;

  /// No description provided for @categoryOtherIncomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Other sources of income'**
  String get categoryOtherIncomeDesc;

  /// No description provided for @noBudgetPlansMessage.
  ///
  /// In en, this message translates to:
  /// **'Start managing your spending by creating budget plans.'**
  String get noBudgetPlansMessage;

  /// No description provided for @loadingBudgetPlans.
  ///
  /// In en, this message translates to:
  /// **'Loading budget plans...'**
  String get loadingBudgetPlans;

  /// No description provided for @deleteBudgetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{budgetName}\"? This action cannot be undone.'**
  String deleteBudgetConfirmation(String budgetName);

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @activePlans.
  ///
  /// In en, this message translates to:
  /// **'Active Plans'**
  String get activePlans;

  /// No description provided for @budgetNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Monthly Groceries'**
  String get budgetNameHint;

  /// No description provided for @budgetAmountHint.
  ///
  /// In en, this message translates to:
  /// **'2.000.000'**
  String get budgetAmountHint;

  /// No description provided for @budgetNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes about this budget...'**
  String get budgetNotesHint;

  /// No description provided for @budgetDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get budgetDescription;

  /// No description provided for @selectCategoryWithCount.
  ///
  /// In en, this message translates to:
  /// **'Select Category ({count})'**
  String selectCategoryWithCount(Object count);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @transactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get transactionTitle;

  /// No description provided for @transactionTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Lunch at restaurant'**
  String get transactionTitleHint;

  /// No description provided for @transactionTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Transaction title is required'**
  String get transactionTitleRequired;

  /// No description provided for @transactionAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionAmount;

  /// No description provided for @transactionAmountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get transactionAmountHint;

  /// No description provided for @transactionAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get transactionAmountRequired;

  /// No description provided for @transactionAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get transactionAmountInvalid;

  /// No description provided for @transactionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get transactionDescription;

  /// No description provided for @transactionDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes about this transaction...'**
  String get transactionDescriptionHint;

  /// No description provided for @transactionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionCategory;

  /// No description provided for @transactionCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get transactionCategoryRequired;

  /// No description provided for @transactionTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select transaction type'**
  String get transactionTypeRequired;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionDate;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get transactionType;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @budgetRemaining.
  ///
  /// In en, this message translates to:
  /// **'Budget Remaining'**
  String get budgetRemaining;

  /// No description provided for @budgetOverLimit.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get budgetOverLimit;

  /// No description provided for @budgetPreview.
  ///
  /// In en, this message translates to:
  /// **'Budget Preview'**
  String get budgetPreview;

  /// No description provided for @budgetUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get budgetUsed;

  /// No description provided for @budgetTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get budgetTotal;

  /// No description provided for @budgetAfterTransaction.
  ///
  /// In en, this message translates to:
  /// **'After this transaction'**
  String get budgetAfterTransaction;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveTransaction;

  /// No description provided for @transactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved successfully!'**
  String get transactionSaved;

  /// No description provided for @transactionSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save transaction'**
  String get transactionSaveFailed;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get filterThisWeek;

  /// No description provided for @filterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get filterThisMonth;

  /// No description provided for @filterThisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get filterThisYear;

  /// No description provided for @filterSpecificDate.
  ///
  /// In en, this message translates to:
  /// **'Specific Date'**
  String get filterSpecificDate;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @transactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteTransaction;

  /// No description provided for @deleteTransactionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get deleteTransactionConfirmation;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted successfully'**
  String get transactionDeleted;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @budgetImpact.
  ///
  /// In en, this message translates to:
  /// **'Budget Impact'**
  String get budgetImpact;

  /// No description provided for @currentBudgetUsage.
  ///
  /// In en, this message translates to:
  /// **'Current Budget Usage'**
  String get currentBudgetUsage;

  /// No description provided for @afterThisTransaction.
  ///
  /// In en, this message translates to:
  /// **'After this transaction'**
  String get afterThisTransaction;

  /// No description provided for @budgetStatus.
  ///
  /// In en, this message translates to:
  /// **'Budget Status'**
  String get budgetStatus;

  /// No description provided for @withinBudget.
  ///
  /// In en, this message translates to:
  /// **'Within Budget'**
  String get withinBudget;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get overBudget;

  /// No description provided for @budgetPlan.
  ///
  /// In en, this message translates to:
  /// **'Budget Plan'**
  String get budgetPlan;

  /// No description provided for @noBudgetPlan.
  ///
  /// In en, this message translates to:
  /// **'No budget plan'**
  String get noBudgetPlan;

  /// No description provided for @deleteConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteConfirmationTitle;

  /// No description provided for @deleteConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get deleteConfirmationMessage;

  /// No description provided for @deleteConfirmationWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmationWarning;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found'**
  String get transactionNotFound;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @editFunctionalityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit functionality coming soon'**
  String get editFunctionalityComingSoon;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingFilters;

  /// No description provided for @startAddingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Start adding your income and expenses'**
  String get startAddingTransactions;

  /// No description provided for @thisBudgetIsOverBy.
  ///
  /// In en, this message translates to:
  /// **'This budget is over by'**
  String get thisBudgetIsOverBy;

  /// No description provided for @selectBudget.
  ///
  /// In en, this message translates to:
  /// **'Select Budget'**
  String get selectBudget;

  /// No description provided for @showAllTransactions.
  ///
  /// In en, this message translates to:
  /// **'Show all transactions'**
  String get showAllTransactions;

  /// No description provided for @noBudgetPlans.
  ///
  /// In en, this message translates to:
  /// **'No Budget Plans'**
  String get noBudgetPlans;

  /// No description provided for @selectBudgetPlan.
  ///
  /// In en, this message translates to:
  /// **'Select Budget Plan'**
  String get selectBudgetPlan;

  /// No description provided for @searchBudgets.
  ///
  /// In en, this message translates to:
  /// **'Search budgets...'**
  String get searchBudgets;

  /// No description provided for @noBudgetsFound.
  ///
  /// In en, this message translates to:
  /// **'No budgets found'**
  String get noBudgetsFound;

  /// No description provided for @tryAdjustingSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search term'**
  String get tryAdjustingSearchTerm;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @budgetDetailsLoading.
  ///
  /// In en, this message translates to:
  /// **'Budget details loading...'**
  String get budgetDetailsLoading;

  /// No description provided for @calculatingRemaining.
  ///
  /// In en, this message translates to:
  /// **'Calculating remaining...'**
  String get calculatingRemaining;

  /// No description provided for @budgetCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} budgets'**
  String budgetCount(int count, int total);

  /// No description provided for @createBudgetPlanDescription.
  ///
  /// In en, this message translates to:
  /// **'To track expenses properly, you need to create budget plans first.'**
  String get createBudgetPlanDescription;

  /// No description provided for @whatWouldYouLikeToDo.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLikeToDo;

  /// No description provided for @createBudgetPlanToTrack.
  ///
  /// In en, this message translates to:
  /// **'Create budget plans first for better expense tracking.'**
  String get createBudgetPlanToTrack;

  /// No description provided for @currencyThousands.
  ///
  /// In en, this message translates to:
  /// **'K'**
  String get currencyThousands;

  /// No description provided for @currencyMillions.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get currencyMillions;

  /// No description provided for @currencyBillions.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get currencyBillions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @localDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Local Data Storage'**
  String get localDataStorage;

  /// No description provided for @dataStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'All your financial data is stored locally on your device. We do not collect, transmit, or store any personal information on external servers.'**
  String get dataStorageDescription;

  /// No description provided for @dataSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurityTitle;

  /// No description provided for @dataSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Your data remains private and secure on your device. You have full control over your information.'**
  String get dataSecurityDescription;

  /// No description provided for @dataControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Data Control'**
  String get dataControlTitle;

  /// No description provided for @dataControlDescription.
  ///
  /// In en, this message translates to:
  /// **'You can export, backup, or delete your data at any time through the app settings.'**
  String get dataControlDescription;

  /// No description provided for @noThirdPartySharing.
  ///
  /// In en, this message translates to:
  /// **'No Third-Party Sharing'**
  String get noThirdPartySharing;

  /// No description provided for @noThirdPartySharingDescription.
  ///
  /// In en, this message translates to:
  /// **'We never share your financial data with third parties, advertisers, or analytics services.'**
  String get noThirdPartySharingDescription;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @appPurpose.
  ///
  /// In en, this message translates to:
  /// **'App Purpose'**
  String get appPurpose;

  /// No description provided for @appPurposeDescription.
  ///
  /// In en, this message translates to:
  /// **'CashFlow is designed to help you manage your personal finances privately and securely on your device.'**
  String get appPurposeDescription;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get openSource;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @buildDate.
  ///
  /// In en, this message translates to:
  /// **'Build Date'**
  String get buildDate;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @acknowledgments.
  ///
  /// In en, this message translates to:
  /// **'Acknowledgments'**
  String get acknowledgments;

  /// No description provided for @shareSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Share Suggestion'**
  String get shareSuggestion;

  /// No description provided for @suggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Your Suggestion'**
  String get suggestionTitle;

  /// No description provided for @suggestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve the app by sharing your ideas and suggestions'**
  String get suggestionSubtitle;

  /// No description provided for @suggestionTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Suggestion Title *'**
  String get suggestionTitleRequired;

  /// No description provided for @suggestionTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Dark mode support, better navigation, new feature idea'**
  String get suggestionTitleHint;

  /// No description provided for @suggestionTitleError.
  ///
  /// In en, this message translates to:
  /// **'Please provide a suggestion title'**
  String get suggestionTitleError;

  /// No description provided for @suggestionDescription.
  ///
  /// In en, this message translates to:
  /// **'Suggestion Description *'**
  String get suggestionDescription;

  /// No description provided for @suggestionDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your suggestion in detail. What would you like to see improved, added, or changed in the app?'**
  String get suggestionDescriptionHint;

  /// No description provided for @suggestionDescriptionError.
  ///
  /// In en, this message translates to:
  /// **'Please provide a suggestion description'**
  String get suggestionDescriptionError;

  /// No description provided for @suggestionUseCase.
  ///
  /// In en, this message translates to:
  /// **'Why is this suggestion important? *'**
  String get suggestionUseCase;

  /// No description provided for @suggestionUseCaseHint.
  ///
  /// In en, this message translates to:
  /// **'Explain how this suggestion would help you and other users. What problem would it solve or what value would it add?'**
  String get suggestionUseCaseHint;

  /// No description provided for @suggestionUseCaseError.
  ///
  /// In en, this message translates to:
  /// **'Please explain why this suggestion is important'**
  String get suggestionUseCaseError;

  /// No description provided for @systemInformation.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInformation;

  /// No description provided for @systemInfoAutoIncluded.
  ///
  /// In en, this message translates to:
  /// **'System info will be included automatically'**
  String get systemInfoAutoIncluded;

  /// No description provided for @submitSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Submit Suggestion'**
  String get submitSuggestion;

  /// No description provided for @submittingSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submittingSuggestion;

  /// No description provided for @featureRequestCopied.
  ///
  /// In en, this message translates to:
  /// **'Feature request copied to clipboard! You can now paste it in your preferred communication channel.'**
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
  // Lookup logic when only language code is specified.
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
