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
  /// **'What should have happened instead?'**
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

  /// No description provided for @generateBugReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Bug Report'**
  String get generateBugReport;

  /// No description provided for @bugReportCopied.
  ///
  /// In en, this message translates to:
  /// **'Bug report copied to clipboard! You can now paste it in an email or message.'**
  String get bugReportCopied;

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
