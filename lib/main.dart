import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/localization/locale_manager.dart';
import 'core/services/currency_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependencies();
  
  final localeManager = getIt<LocaleManager>();
  await localeManager.loadSavedLocale();
  
  final currencyService = getIt<CurrencyService>();
  await currencyService.initializeService();
  
  runApp(CashFlowApp(
    localeManager: localeManager,
    currencyService: currencyService,
  ));
}

class CashFlowApp extends StatelessWidget {
  final LocaleManager localeManager;
  final CurrencyService currencyService;
  
  const CashFlowApp({
    super.key,
    required this.localeManager,
    required this.currencyService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: localeManager),
        BlocProvider.value(value: currencyService),
      ],
      child: BlocBuilder<LocaleManager, Locale>(
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
            supportedLocales: LocaleManager.supportedLocales,
          );
        },
      ),
    );
  }
}
