import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cashflow/core/constants/app_constants.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.cashflowManager,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.manageYourFinances,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(AppLocalizations.of(context)!.settings),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push(AppConstants.settingsRoute);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(AppLocalizations.of(context)!.categories),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to categories
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bug_report),
                    title: Text(AppLocalizations.of(context)!.reportBug),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push(AppConstants.bugReportRoute);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(AppLocalizations.of(context)!.about),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to about
                    },
                  ),
                  const Divider(),
                  ExpansionTile(
                    leading: const Icon(Icons.bug_report),
                    title: Text(AppLocalizations.of(context)!.debugInformation),
                    children: [
                      _buildDebugInfoTile(AppLocalizations.of(context)!.appName, AppConstants.appName),
                      _buildDebugInfoTile(AppLocalizations.of(context)!.appVersion, AppConstants.appVersion),
                      _buildDebugInfoTile('Build Number', '1'),
                      _buildDebugInfoTile(AppLocalizations.of(context)!.platform, Platform.operatingSystem),
                      _buildDebugInfoTile('Platform Version', Platform.operatingSystemVersion),
                      _buildDebugInfoTile('Debug Mode', kDebugMode ? AppLocalizations.of(context)!.debugModeYes : AppLocalizations.of(context)!.debugModeNo),
                      _buildDebugInfoTile('Release Mode', kReleaseMode ? AppLocalizations.of(context)!.debugModeYes : AppLocalizations.of(context)!.debugModeNo),
                      _buildDebugInfoTile('Profile Mode', kProfileMode ? AppLocalizations.of(context)!.debugModeYes : AppLocalizations.of(context)!.debugModeNo),
                      _buildDebugInfoTile('Database', AppConstants.databaseName),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _copyDebugInfo();
                          },
                          icon: const Icon(Icons.copy),
                          label: Text(AppLocalizations.of(context)!.copyDebugInfo),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugInfoTile(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      dense: true,
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        // Show snackbar would require context, so we'll skip it for now
      },
    );
  }

  void _copyDebugInfo() {
    final debugInfo = '''
Debug Information:
- App Name: ${AppConstants.appName}
- Version: ${AppConstants.appVersion}
- Build Number: 1
- Platform: ${Platform.operatingSystem}
- Platform Version: ${Platform.operatingSystemVersion}
- Debug Mode: ${kDebugMode ? 'Yes' : 'No'}
- Release Mode: ${kReleaseMode ? 'Yes' : 'No'}
- Profile Mode: ${kProfileMode ? 'Yes' : 'No'}
- Database: ${AppConstants.databaseName}
''';
    
    Clipboard.setData(ClipboardData(text: debugInfo));
  }

}