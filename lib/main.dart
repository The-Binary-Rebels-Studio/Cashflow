import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/localization/locale_manager.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependencies();
  
  final localeManager = getIt<LocaleManager>();
  await localeManager.loadSavedLocale();
  
  runApp(CashFlowApp(localeManager: localeManager));
}

class CashFlowApp extends StatelessWidget {
  final LocaleManager localeManager;
  
  const CashFlowApp({super.key, required this.localeManager});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: localeManager,
      child: Consumer<LocaleManager>(
        builder: (context, localeManager, child) {
          return MaterialApp.router(
            title: 'CashFlow',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
            locale: localeManager.currentLocale,
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
