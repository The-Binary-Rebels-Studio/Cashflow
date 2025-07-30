import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashflow/core/localization/locale_manager.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(AppLocalizations.of(context)!.language),
          Card(
            child: Column(
              children: [
                Consumer<LocaleManager>(
                  builder: (context, localeManager, child) {
                    return ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(AppLocalizations.of(context)!.selectLanguage),
                      subtitle: Text(_getLanguageDisplayName(localeManager.currentLocale.languageCode)),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showLanguageDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(AppLocalizations.of(context)!.appearance),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: Text(AppLocalizations.of(context)!.theme),
                  subtitle: Text(AppLocalizations.of(context)!.systemDefault),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Implement theme selection
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_size),
                  title: Text(AppLocalizations.of(context)!.fontSize),
                  subtitle: Text(AppLocalizations.of(context)!.medium),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Implement font size selection
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(AppLocalizations.of(context)!.dataPrivacy),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: Text(AppLocalizations.of(context)!.backupRestore),
                  subtitle: Text(AppLocalizations.of(context)!.backupRestoreSubtitle),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Implement backup/restore
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(AppLocalizations.of(context)!.clearData),
                  subtitle: Text(AppLocalizations.of(context)!.clearDataSubtitle),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showClearDataDialog(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(AppLocalizations.of(context)!.notifications),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: Text(AppLocalizations.of(context)!.enableNotifications),
                  subtitle: Text(AppLocalizations.of(context)!.receiveReminders),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement notification toggle
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.today),
                  title: Text(AppLocalizations.of(context)!.dailyReminders),
                  subtitle: Text(AppLocalizations.of(context)!.dailyRemindersSubtitle),
                  value: false,
                  onChanged: (value) {
                    // TODO: Implement daily reminder toggle
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
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
    final localeManager = context.read<LocaleManager>();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.english),
                value: 'en',
                groupValue: localeManager.currentLocale.languageCode,
                onChanged: (value) {
                  localeManager.changeLocale(Locale(value!));
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.indonesian),
                value: 'id',
                groupValue: localeManager.currentLocale.languageCode,
                onChanged: (value) {
                  localeManager.changeLocale(Locale(value!));
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.malaysian),
                value: 'ms',
                groupValue: localeManager.currentLocale.languageCode,
                onChanged: (value) {
                  localeManager.changeLocale(Locale(value!));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.clearData),
          content: Text(AppLocalizations.of(context)!.clearDataConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement clear data functionality
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.dataCleared),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.clearData),
            ),
          ],
        );
      },
    );
  }
}