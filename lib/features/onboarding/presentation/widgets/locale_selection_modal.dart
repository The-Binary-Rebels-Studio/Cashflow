import 'package:flutter/material.dart';
import 'package:cashflow/core/models/locale_model.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class LocaleSelectionModal extends StatefulWidget {
  final LocaleModel? selectedLocale;
  final Function(LocaleModel) onLocaleSelected;

  const LocaleSelectionModal({
    super.key,
    this.selectedLocale,
    required this.onLocaleSelected,
  });

  @override
  State<LocaleSelectionModal> createState() => _LocaleSelectionModalState();
}

class _LocaleSelectionModalState extends State<LocaleSelectionModal> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  l10n.onboardingChooseLanguage,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingSelectPreferredLanguage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: LocaleData.supportedLocales.length,
                itemBuilder: (context, index) {
                  final localeModel = LocaleData.supportedLocales[index];
                  final isSelected = localeModel == widget.selectedLocale;
                  
                  return _buildLocaleTile(localeModel, isSelected);
                },
              ),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocaleTile(LocaleModel localeModel, bool isSelected) {
    return GestureDetector(
      onTap: () {
        widget.onLocaleSelected(localeModel);
        Navigator.of(context).pop();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2)
              : Border.all(color: Colors.transparent, width: 2),
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
                  localeModel.flag,
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
                    localeModel.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    localeModel.nativeName,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            
            
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1.0 : 0.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Color(0xFF667eea),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showLocaleSelectionModal({
  required BuildContext context,
  LocaleModel? selectedLocale,
  required Function(LocaleModel) onLocaleSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => LocaleSelectionModal(
      selectedLocale: selectedLocale,
      onLocaleSelected: onLocaleSelected,
    ),
  );
}