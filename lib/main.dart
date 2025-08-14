import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/localization/locale_bloc.dart';
import 'core/localization/locale_event.dart';
import 'core/services/currency_bloc.dart';
import 'core/services/currency_event.dart';
import 'core/services/ads_service.dart';
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
  ));
}

class CashFlowApp extends StatelessWidget {
  final LocaleBloc localeBloc;
  final CurrencyBloc currencyBloc;
  final BudgetManagementBloc budgetManagementBloc;
  final TransactionBloc transactionBloc;
  
  const CashFlowApp({
    super.key,
    required this.localeBloc,
    required this.currencyBloc,
    required this.budgetManagementBloc,
    required this.transactionBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: localeBloc),
        BlocProvider.value(value: currencyBloc),
        BlocProvider.value(value: budgetManagementBloc),
        BlocProvider.value(value: transactionBloc),
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
