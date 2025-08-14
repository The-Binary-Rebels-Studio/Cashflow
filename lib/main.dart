import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/localization/locale_bloc.dart';
import 'core/localization/locale_event.dart';
import 'core/services/currency_bloc.dart';
import 'core/services/currency_event.dart';
import 'core/services/ads_service.dart';
import 'core/services/app_open_ad_manager.dart';
import 'features/budget_management/presentation/bloc/budget_management_bloc.dart';
import 'features/budget_management/presentation/bloc/budget_management_event.dart';
import 'features/transaction/presentation/bloc/transaction_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependencies();
  
  // Initialize Ads Service
  final adsService = getIt<AdsService>();
  await adsService.initialize();
  
  // Initialize App Open Ad Manager
  final appOpenAdManager = getIt<AppOpenAdManager>();
  await appOpenAdManager.initialize();
  
  final localeBloc = getIt<LocaleBloc>();
  localeBloc.add(const LocaleLoaded());
  
  final currencyBloc = getIt<CurrencyBloc>();
  currencyBloc.add(const CurrencyInitialized());
  
  final budgetManagementBloc = getIt<BudgetManagementBloc>();
  budgetManagementBloc.add(const BudgetManagementInitialized());
  
  final transactionBloc = getIt<TransactionBloc>();
  
  runApp(CashFlowApp(
    localeBloc: localeBloc,
    currencyBloc: currencyBloc,
    budgetManagementBloc: budgetManagementBloc,
    transactionBloc: transactionBloc,
    appOpenAdManager: appOpenAdManager,
  ));
}

class CashFlowApp extends StatefulWidget {
  final LocaleBloc localeBloc;
  final CurrencyBloc currencyBloc;
  final BudgetManagementBloc budgetManagementBloc;
  final TransactionBloc transactionBloc;
  final AppOpenAdManager appOpenAdManager;
  
  const CashFlowApp({
    super.key,
    required this.localeBloc,
    required this.currencyBloc,
    required this.budgetManagementBloc,
    required this.transactionBloc,
    required this.appOpenAdManager,
  });

  @override
  State<CashFlowApp> createState() => _CashFlowAppState();
}

class _CashFlowAppState extends State<CashFlowApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.appOpenAdManager.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !AppOpenAdManager.isAdShowing) {
      widget.appOpenAdManager.showAdIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.localeBloc),
        BlocProvider.value(value: widget.currencyBloc),
        BlocProvider.value(value: widget.budgetManagementBloc),
        BlocProvider.value(value: widget.transactionBloc),
      ],
      child: BlocBuilder<LocaleBloc, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'CashFlow',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleBloc.supportedLocales,
          );
        },
      ),
    );
  }
}
