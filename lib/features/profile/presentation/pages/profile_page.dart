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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settings,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _ProfileHeaderCard(l10n: l10n),
              const SizedBox(height: 24),
              _MenuSection(l10n: l10n),
              const SizedBox(height: 24),
              _DebugSection(
                l10n: l10n,
                onCopyDebugInfo: _copyDebugInfo,
                buildDebugInfoTile: _buildDebugInfoTile,
              ),
            ],
          ),
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

class _ProfileHeaderCard extends StatelessWidget {
  final AppLocalizations l10n;

  const _ProfileHeaderCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Pengaturan",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Kelola aplikasi dan preferensi Anda",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _MenuSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.settings,
            title: l10n.settings,
            color: Colors.blue,
            onTap: () => context.push(AppConstants.settingsRoute),
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.bug_report,
            title: l10n.reportBug,
            color: Colors.orange,
            onTap: () => context.push(AppConstants.bugReportRoute),
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.feedback_outlined,
            title: l10n.shareSuggestion,
            color: Colors.green,
            onTap: () => context.push('/feature-request'),
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.privacy_tip,
            title: l10n.privacyPolicy,
            color: Colors.purple,
            onTap: () => context.push(AppConstants.privacyPolicyRoute),
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.info,
            title: l10n.about,
            color: Colors.green,
            onTap: () => context.push(AppConstants.aboutRoute),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
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
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}

class _DebugSection extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onCopyDebugInfo;
  final Widget Function(String, String) buildDebugInfoTile;

  const _DebugSection({
    required this.l10n,
    required this.onCopyDebugInfo,
    required this.buildDebugInfoTile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: EdgeInsets.zero,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.code,
            color: Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          l10n.debugInformation,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        children: [
          const Divider(height: 1),
          buildDebugInfoTile(l10n.appName, AppConstants.appName),
          buildDebugInfoTile(l10n.appVersion, AppConstants.appVersion),
          buildDebugInfoTile('Build Number', '1'),
          buildDebugInfoTile(l10n.platform, Platform.operatingSystem),
          buildDebugInfoTile('Platform Version', Platform.operatingSystemVersion),
          buildDebugInfoTile('Debug Mode', kDebugMode ? l10n.debugModeYes : l10n.debugModeNo),
          buildDebugInfoTile('Release Mode', kReleaseMode ? l10n.debugModeYes : l10n.debugModeNo),
          buildDebugInfoTile('Profile Mode', kProfileMode ? l10n.debugModeYes : l10n.debugModeNo),
          buildDebugInfoTile('Database', AppConstants.databaseName),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCopyDebugInfo,
                icon: const Icon(Icons.copy),
                label: Text(l10n.copyDebugInfo),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}