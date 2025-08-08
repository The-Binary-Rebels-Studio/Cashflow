import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/core/constants/app_constants.dart';
import 'package:cashflow/core/di/injection.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/core/models/locale_model.dart';
import 'package:cashflow/core/localization/locale_manager.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/currency_selection_modal.dart';
import '../widgets/locale_selection_modal.dart';
import '../../domain/entities/onboarding_settings.dart';
import '../../domain/usecases/save_onboarding_settings.dart';
import '../../../localization/domain/usecases/change_locale.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  CurrencyModel _selectedCurrency = CurrencyData.currencies.first;
  late LocaleModel _selectedLocale;

  @override
  void initState() {
    super.initState();
    // Initialize selected locale based on current app locale
    final localeManager = context.read<LocaleManager>();
    final currentLocale = localeManager.currentLocale;
    _selectedLocale = LocaleData.getLocaleByCode(currentLocale.languageCode) ?? LocaleData.supportedLocales.first;
  }

  List<OnboardingData> _getPages(AppLocalizations l10n) {
    return [
      OnboardingData(
        title: l10n.onboardingTrackExpensesTitle,
        subtitle: l10n.onboardingTrackExpensesSubtitle,
        icon: Icons.trending_up,
        color: Colors.blue,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      OnboardingData(
        title: l10n.onboardingSmartCategoriesTitle,
        subtitle: l10n.onboardingSmartCategoriesSubtitle,
        icon: Icons.category_outlined,
        color: Colors.green,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
        ),
      ),
      OnboardingData(
        title: l10n.onboardingFinancialInsightsTitle,
        subtitle: l10n.onboardingFinancialInsightsSubtitle,
        icon: Icons.analytics_outlined,
        color: Colors.purple,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8360c3), Color(0xFF2ebf91)],
        ),
      ),
      OnboardingData(
        title: l10n.onboardingSecurePrivateTitle,
        subtitle: l10n.onboardingSecurePrivateSubtitle,
        icon: Icons.security_outlined,
        color: Colors.orange,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        ),
      ),
      OnboardingData(
        title: 'Choose Language',
        subtitle: 'Select your preferred language for the app',
        icon: Icons.language,
        color: Colors.blue,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        isLocalePage: true,
      ),
      OnboardingData(
        title: l10n.onboardingCurrencyTitle,
        subtitle: l10n.onboardingCurrencySubtitle,
        icon: Icons.attach_money,
        color: Colors.teal,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF56ab2f), Color(0xFFa8e6cf)],
        ),
        isCurrencyPage: true,
      ),
    ];
  }

  void _completeOnboarding(BuildContext context) async {
    final onboardingSettings = OnboardingSettings(
      selectedCurrency: _selectedCurrency,
      selectedLocale: _selectedLocale,
    );
    
    final saveOnboardingSettings = getIt<SaveOnboardingSettings>();
    await saveOnboardingSettings(onboardingSettings);
    
    if (context.mounted) {
      context.go(AppConstants.mainRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _getPages(l10n);
    
    return BlocProvider(
      create: (context) => getIt<OnboardingCubit>(),
      child: Builder(
        builder: (context) => BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingCompleted) {
              context.go(AppConstants.mainRoute);
            }
          },
          child: _buildOnboardingView(context, l10n, pages),
        ),
      ),
    );
  }

  Widget _buildOnboardingView(BuildContext context, AppLocalizations l10n, List<OnboardingData> pages) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: pages[_currentPage].gradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => _completeOnboarding(context),
                    child: Text(
                      l10n.onboardingSkip,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(pages[index], l10n);
                  },
                ),
              ),
              
              // Page indicators
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicators
                    Row(
                      children: List.generate(
                        pages.length,
                        (index) => _buildIndicator(index == _currentPage),
                      ),
                    ),
                    
                    // Next/Get Started button
                    _buildActionButton(context, l10n, pages),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPage(OnboardingData data, AppLocalizations l10n) {
    if (data.isCurrencyPage) {
      return _buildCurrencyPage(data, l10n);
    }
    
    if (data.isLocalePage) {
      return _buildLocalePage(data, l10n);
    }
    
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Animated icon container
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 64,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Subtitle
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCurrencyPage(OnboardingData data, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Icon and title section
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 54,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Selected currency display
          _buildSelectedCurrencyCard(),
          
          const SizedBox(height: 24),
          
          // Select currency button
          _buildSelectCurrencyButton(l10n),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLocalePage(OnboardingData data, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Icon and title section
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 54,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Selected locale display
          _buildSelectedLocaleCard(),
          
          const SizedBox(height: 24),
          
          // Select locale button
          _buildSelectLocaleButton(l10n),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSelectedCurrencyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _selectedCurrency.symbol,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCurrency.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_selectedCurrency.country} • ${_selectedCurrency.code}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedLocaleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _selectedLocale.flag,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedLocale.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _selectedLocale.nativeName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCurrencyButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showCurrencySelectionModal(
            context: context,
            selectedCurrency: _selectedCurrency,
            onCurrencySelected: (currency) {
              setState(() {
                _selectedCurrency = currency;
              });
            },
          );
        },
        icon: const Icon(Icons.tune),
        label: Text(l10n.changeCurrency),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectLocaleButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showLocaleSelectionModal(
            context: context,
            selectedLocale: _selectedLocale,
            onLocaleSelected: (locale) async {
              // Update the app's locale in real-time using clean architecture
              final changeLocale = getIt<ChangeLocale>();
              await changeLocale(locale.locale);
              
              setState(() {
                _selectedLocale = locale;
              });
            },
          );
        },
        icon: const Icon(Icons.language),
        label: Text(l10n.changeLanguage),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.white 
            : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, AppLocalizations l10n, List<OnboardingData> pages) {
    final isLastPage = _currentPage == pages.length - 1;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            if (isLastPage) {
              _completeOnboarding(context);
            } else {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLastPage ? 24 : 16,
              vertical: 16,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLastPage) ...[
                  Text(
                    l10n.getStarted,
                    style: TextStyle(
                      color: pages[_currentPage].color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Icon(
                  isLastPage ? Icons.check : Icons.arrow_forward,
                  color: pages[_currentPage].color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final LinearGradient gradient;
  final bool isCurrencyPage;
  final bool isLocalePage;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradient,
    this.isCurrencyPage = false,
    this.isLocalePage = false,
  });
}