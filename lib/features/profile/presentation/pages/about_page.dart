import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/constants/app_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
                        l10n.about,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(32.0),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppConstants.appName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.appPurposeDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${l10n.version} ${AppConstants.appVersion}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
                      "Fitur Utama",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.trending_up,
                            title: "Lacak Transaksi",
                            description: "Monitor semua pemasukan dan pengeluaran",
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.pie_chart,
                            title: "Analisis Budget",
                            description: "Visualisasi pengeluaran dengan chart",
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.language,
                            title: "Multi Bahasa",
                            description: "Indonesia, English, Melayu",
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.storage,
                            title: "Data Lokal",
                            description: "Semua data tersimpan di perangkat",
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
                      "Informasi Aplikasi",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _InfoSection(
                      icon: Icons.info_outline,
                      title: l10n.appPurpose,
                      content: l10n.appPurposeDescription,
                      isExpanded: true,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _InfoSection(
                      icon: Icons.security,
                      title: l10n.dataSecurityTitle,
                      content: l10n.dataSecurityDescription,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _InfoSection(
                      icon: Icons.code,
                      title: l10n.openSource,
                      content: "CashFlow adalah aplikasi open source yang dikembangkan dengan Flutter. Kode sumber tersedia untuk transparansi dan kontribusi komunitas.",
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Dibuat dengan ❤️ oleh",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Binary Rebels Studio",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Terima kasih telah menggunakan CashFlow!\nJika ada feedback atau saran, jangan ragu untuk menghubungi kami.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
                  ],
                ),
              ),
              
              
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "CashFlow v${AppConstants.appVersion}\n© 2025 Binary Rebels Studio",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
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

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 13,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatefulWidget {
  final IconData icon;
  final String title;
  final String content;
  final bool isExpanded;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.content,
    this.isExpanded = false,
  });

  @override
  State<_InfoSection> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<_InfoSection> {
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
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