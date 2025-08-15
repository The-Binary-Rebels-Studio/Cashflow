import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/core/constants/app_constants.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';
import '../bloc/feedback_state.dart';
import '../dto/suggestion_dto.dart';

class FeatureRequestPage extends StatefulWidget {
  const FeatureRequestPage({super.key});

  @override
  State<FeatureRequestPage> createState() => _FeatureRequestPageState();
}

class _FeatureRequestPageState extends State<FeatureRequestPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _useCaseController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  String get _deviceInfoString =>
      '''
App: ${AppConstants.appName}
Version: ${AppConstants.appVersion}
Platform: ${Platform.operatingSystem}
Platform Version: ${Platform.operatingSystemVersion}
Debug Mode: ${kDebugMode ? 'Yes' : 'No'}
Database: ${AppConstants.databaseName}
Generated: ${DateTime.now().toIso8601String()}''';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _useCaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.shareSuggestion,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSuggestionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
            _titleController.clear();
            _descriptionController.clear();
            _useCaseController.clear();
          } else if (state is FeedbackError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.userMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.feedback_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.suggestionTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.suggestionSubtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              
              _buildFormSection(
                l10n.suggestionTitleRequired,
                TextFormField(
                  controller: _titleController,
                  decoration: _buildInputDecoration(
                    hintText: l10n.suggestionTitleHint,
                    prefixIcon: const Icon(
                      Icons.title_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.suggestionTitleError;
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              
              _buildFormSection(
                l10n.suggestionDescription,
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: _buildInputDecoration(
                    hintText: l10n.suggestionDescriptionHint,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 98),
                      child: Icon(
                        Icons.description_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.suggestionDescriptionError;
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              
              _buildFormSection(
                l10n.suggestionUseCase,
                TextFormField(
                  controller: _useCaseController,
                  maxLines: 4,
                  decoration: _buildInputDecoration(
                    hintText: l10n.suggestionUseCaseHint,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 64),
                      child: Icon(
                        Icons.help_outline,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.suggestionUseCaseError;
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              
              _buildFormSection(
                l10n.systemInformation,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.systemInfoAutoIncluded,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _deviceInfoString,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'monospace',
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: BlocBuilder<FeedbackBloc, FeedbackState>(
                  builder: (context, state) {
                    final isLoading = state is FeedbackLoading;
                    return ElevatedButton.icon(
                      onPressed: isLoading ? null : _submitFeatureRequest,
                      icon: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.send_outlined, size: 24),
                      label: Text(
                        isLoading ? l10n.submittingSuggestion : l10n.submitSuggestion,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        child,
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required Widget prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
    );
  }

  void _submitFeatureRequest() {
    if (!_formKey.currentState!.validate()) return;

    final suggestion = SuggestionDto(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      useCase: _useCaseController.text.trim(),
    );

    context.read<FeedbackBloc>().add(
      FeedbackSuggestionSubmitted(suggestion: suggestion),
    );
  }
}