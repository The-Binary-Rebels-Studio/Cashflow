import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        l10n.privacyPolicy,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(24.0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.white, size: 32),
                    const SizedBox(height: 16),
                    Text(
                      l10n.dataSecurityTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.dataSecurityDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hal Penting",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    
                    Row(
                      children: [
                        Expanded(
                          child: _KeyBenefitCard(
                            icon: Icons.storage_outlined,
                            title: "100% Lokal",
                            subtitle: "Data tersimpan di perangkat Anda",
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _KeyBenefitCard(
                            icon: Icons.privacy_tip_outlined,
                            title: "Privacy First",
                            subtitle: "Data keuangan tidak dibagikan",
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _KeyBenefitCard(
                            icon: Icons.admin_panel_settings_outlined,
                            title: "Kendali Penuh",
                            subtitle: "Anda yang mengatur data",
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _KeyBenefitCard(
                            icon: Icons.security_outlined,
                            title: "Aman & Privat",
                            subtitle: "Enkripsi tingkat bank",
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Detail Kebijakan",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _DetailSection(
                      icon: Icons.storage,
                      title: l10n.localDataStorage,
                      content: l10n.dataStorageDescription,
                      isExpanded: true,
                    ),

                    const SizedBox(height: 16),

                    _DetailSection(
                      icon: Icons.admin_panel_settings,
                      title: l10n.dataControlTitle,
                      content: l10n.dataControlDescription,
                    ),

                    const SizedBox(height: 16),

                    _DetailSection(
                      icon: Icons.ads_click,
                      title: "Iklan & Tracking",
                      content:
                          "Kami menampilkan iklan untuk mendukung biaya operasional aplikasi. Ads mediation menggunakan tracking untuk personalisasi iklan, namun data keuangan sensitif Anda (transaksi, saldo, budget) tetap privat dan tidak pernah dibagikan dengan pengiklan.",
                    ),

                    const SizedBox(height: 16),

                    _DetailSection(
                      icon: Icons.apps,
                      title: l10n.appPurpose,
                      content: l10n.appPurposeDescription,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.contact_support_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.contactUs,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Punya pertanyaan? Hubungi kami",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'hello@binaryrebels.studio',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeyBenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _KeyBenefitCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatefulWidget {
  final IconData icon;
  final String title;
  final String content;
  final bool isExpanded;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.content,
    this.isExpanded = false,
  });

  @override
  State<_DetailSection> createState() => _DetailSectionState();
}

class _DetailSectionState extends State<_DetailSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey[600],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.content,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.6,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
