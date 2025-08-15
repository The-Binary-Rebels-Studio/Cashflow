import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/core/localization/locale_bloc.dart';
import 'package:cashflow/core/localization/locale_event.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/services/currency_event.dart';
import 'package:cashflow/core/services/data_deletion_service.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.settings,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SettingsSection(
                title: 'Preferences',
                children: [
                  BlocBuilder<LocaleBloc, Locale>(
                    builder: (context, locale) {
                      return _SettingsItem(
                        icon: Icons.language,
                        title: l10n.selectLanguage,
                        subtitle: _getLanguageDisplayName(locale.languageCode),
                        color: Colors.green,
                        onTap: () => _showLanguageDialog(),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  BlocBuilder<CurrencyBloc, CurrencyModel>(
                    builder: (context, currency) {
                      return _SettingsItem(
                        icon: Icons.attach_money,
                        title: 'Currency',
                        subtitle: '${currency.code} - ${currency.name}',
                        color: Colors.blue,
                        onTap: () => _showCurrencyDialog(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DangerZoneSection(l10n: l10n),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'App Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return AppLocalizations.of(context)!.english;
      case 'id':
        return AppLocalizations.of(context)!.indonesian;
      case 'ms':
        return AppLocalizations.of(context)!.malaysian;
      default:
        return AppLocalizations.of(context)!.english;
    }
  }

  void _showLanguageDialog() {
    final localeBloc = context.read<LocaleBloc>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.selectLanguage,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _LanguageOption(
                  title: AppLocalizations.of(context)!.english,
                  subtitle: 'English',
                  flag: '🇺🇸',
                  value: 'en',
                  groupValue: localeBloc.currentLocale.languageCode,
                  onChanged: (value) {
                    localeBloc.add(LocaleChanged(locale: Locale(value!)));
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(height: 1),
                _LanguageOption(
                  title: AppLocalizations.of(context)!.indonesian,
                  subtitle: 'Bahasa Indonesia',
                  flag: '🇮🇩',
                  value: 'id',
                  groupValue: localeBloc.currentLocale.languageCode,
                  onChanged: (value) {
                    localeBloc.add(LocaleChanged(locale: Locale(value!)));
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(height: 1),
                _LanguageOption(
                  title: AppLocalizations.of(context)!.malaysian,
                  subtitle: 'Bahasa Melayu',
                  flag: '🇲🇾',
                  value: 'ms',
                  groupValue: localeBloc.currentLocale.languageCode,
                  onChanged: (value) {
                    localeBloc.add(LocaleChanged(locale: Locale(value!)));
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCurrencyDialog() {
    final currencyBloc = context.read<CurrencyBloc>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Select Currency',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: CurrencyData.currencies.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final currency = CurrencyData.currencies[index];
                    return _CurrencyOption(
                      currency: currency,
                      isSelected: currency.code == currencyBloc.selectedCurrency.code,
                      onChanged: () {
                        currencyBloc.add(CurrencySelected(currency: currency));
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                    ? const Color(0xFF667eea).withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                      ? const Color(0xFF667eea) 
                      : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    flag,
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
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                          ? const Color(0xFF667eea) 
                          : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF667eea),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}


class _DangerZoneSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _DangerZoneSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Danger Zone',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.red[700],
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.clearData,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'This action cannot be undone',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showClearDataDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(l10n.clearData),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showClearDataDialog(BuildContext context) async {
    final dataDeletionService = GetIt.instance<DataDeletionService>();
    
    
    final stats = await dataDeletionService.getDataStatistics();
    final hasData = await dataDeletionService.hasUserData();
    
    if (!hasData) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user data to clear'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(l10n.clearData),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.clearDataConfirmation,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data to be deleted:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    if (stats.transactionCount > 0)
                      _DataItem(
                        icon: Icons.receipt_long,
                        label: 'Transactions',
                        count: stats.transactionCount,
                      ),
                    if (stats.budgetCount > 0)
                      _DataItem(
                        icon: Icons.account_balance_wallet,
                        label: 'Budgets',
                        count: stats.budgetCount,
                      ),
                    if (stats.categoryCount > 0)
                      _DataItem(
                        icon: Icons.category,
                        label: 'Categories',
                        count: stats.categoryCount,
                      ),
                    _DataItem(
                      icon: Icons.settings,
                      label: 'App Settings',
                      count: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'This action cannot be undone!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => _performDataDeletion(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.clearData),
            ),
          ],
        );
      },
    );
  }

  void _performDataDeletion(BuildContext context) async {
    Navigator.of(context).pop(); 
    
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Clearing data...'),
          ],
        ),
      ),
    );
    
    try {
      final dataDeletionService = GetIt.instance<DataDeletionService>();
      final success = await dataDeletionService.clearAllData();
      
      Navigator.of(context).pop(); 
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(l10n.dataCleared),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Failed to clear data. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); 
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('An error occurred while clearing data'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

class _DataItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;

  const _DataItem({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.red[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $count ${count == 1 ? 'item' : 'items'}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyOption extends StatelessWidget {
  final CurrencyModel currency;
  final bool isSelected;
  final VoidCallback onChanged;

  const _CurrencyOption({
    required this.currency,
    required this.isSelected,
    required this.onChanged,
  });

  String _getCurrencyFlag(String code) {
    const flagMap = {
      'USD': '🇺🇸', 'EUR': '🇪🇺', 'IDR': '🇮🇩', 'MYR': '🇲🇾', 'SGD': '🇸🇬',
      'GBP': '🇬🇧', 'JPY': '🇯🇵', 'CNY': '🇨🇳', 'AUD': '🇦🇺', 'CAD': '🇨🇦',
      'CHF': '🇨🇭', 'INR': '🇮🇳', 'KRW': '🇰🇷', 'THB': '🇹🇭', 'PHP': '🇵🇭',
      'VND': '🇻🇳', 'BRL': '🇧🇷', 'ARS': '🇦🇷', 'CLP': '🇨🇱', 'COP': '🇨🇴',
      'MXN': '🇲🇽', 'ZAR': '🇿🇦', 'EGP': '🇪🇬', 'NGN': '🇳🇬', 'TRY': '🇹🇷',
      'RUB': '🇷🇺', 'PLN': '🇵🇱', 'CZK': '🇨🇿', 'HUF': '🇭🇺', 'SEK': '🇸🇪',
      'NOK': '🇳🇴', 'DKK': '🇩🇰', 'NZD': '🇳🇿', 'HKD': '🇭🇰', 'TWD': '🇹🇼',
    };
    return flagMap[code] ?? '💰';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onChanged,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                    ? const Color(0xFF667eea).withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                      ? const Color(0xFF667eea) 
                      : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _getCurrencyFlag(currency.code),
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
                      currency.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                          ? const Color(0xFF667eea) 
                          : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${currency.code} - ${currency.country}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                currency.symbol,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected 
                    ? const Color(0xFF667eea) 
                    : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF667eea),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}