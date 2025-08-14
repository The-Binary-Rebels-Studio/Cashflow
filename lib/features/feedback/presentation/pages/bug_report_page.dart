import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/core/services/feedback_api_service.dart';
import 'package:cashflow/core/models/bug_report_model.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({super.key});

  @override
  State<BugReportPage> createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();
  final _expectedController = TextEditingController();
  final _actualController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  
  BugSeverity _selectedSeverity = BugSeverity.medium;
  BugCategory _selectedCategory = BugCategory.functionality;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    _expectedController.dispose();
    _actualController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Bug'),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildTitleField(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildStepsField(),
                const SizedBox(height: 16),
                _buildExpectedBehaviorField(),
                const SizedBox(height: 16),
                _buildActualBehaviorField(),
                const SizedBox(height: 16),
                _buildCategoryField(),
                const SizedBox(height: 16),
                _buildSeverityField(),
                const SizedBox(height: 24),
                _buildContactSection(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report_outlined,
                color: Colors.red[600],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Report a Bug',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Help us fix issues by providing detailed information about the bug you encountered.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Bug Title *',
        hintText: 'e.g., App crashes when adding transaction',
        prefixIcon: const Icon(Icons.title),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title for the bug';
        }
        if (value.trim().length < 10) {
          return 'Title must be at least 10 characters long';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Bug Description *',
        hintText: 'Describe the bug in detail...',
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please provide a detailed description';
        }
        if (value.trim().length < 20) {
          return 'Description must be at least 20 characters long';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildStepsField() {
    return TextFormField(
      controller: _stepsController,
      decoration: InputDecoration(
        labelText: 'Steps to Reproduce *',
        hintText: '1. Open app\n2. Navigate to...\n3. Click on...',
        prefixIcon: const Icon(Icons.list_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please provide steps to reproduce the bug';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildExpectedBehaviorField() {
    return TextFormField(
      controller: _expectedController,
      decoration: InputDecoration(
        labelText: 'Expected Behavior *',
        hintText: 'What should have happened?',
        prefixIcon: const Icon(Icons.check_circle_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignLabelWithHint: true,
      ),
      maxLines: 2,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please describe the expected behavior';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildActualBehaviorField() {
    return TextFormField(
      controller: _actualController,
      decoration: InputDecoration(
        labelText: 'Actual Behavior *',
        hintText: 'What actually happened?',
        prefixIcon: const Icon(Icons.error_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignLabelWithHint: true,
      ),
      maxLines: 2,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please describe what actually happened';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bug Category *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BugCategory>(
              value: _selectedCategory,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (BugCategory? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
              items: BugCategory.values.map((category) {
                return DropdownMenuItem<BugCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(category.displayName),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: BugSeverity.values.map((severity) {
            final isSelected = _selectedSeverity == severity;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSeverity = severity;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? _getSeverityColor(severity).withValues(alpha: 0.1)
                        : Colors.grey[100],
                    border: Border.all(
                      color: isSelected 
                          ? _getSeverityColor(severity)
                          : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getSeverityIcon(severity),
                        color: isSelected 
                            ? _getSeverityColor(severity)
                            : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        severity.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected 
                              ? _getSeverityColor(severity)
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Provide your contact details if you\'d like us to follow up on this bug report.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Your Name',
            hintText: 'John Doe',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'john@example.com',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitBugReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Submitting...'),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send),
                  SizedBox(width: 8),
                  Text(
                    'Submit Bug Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getCategoryIcon(BugCategory category) {
    switch (category) {
      case BugCategory.crash:
        return Icons.warning;
      case BugCategory.ui:
        return Icons.design_services;
      case BugCategory.functionality:
        return Icons.settings;
      case BugCategory.performance:
        return Icons.speed;
      case BugCategory.data:
        return Icons.storage;
      case BugCategory.security:
        return Icons.security;
      case BugCategory.other:
        return Icons.more_horiz;
    }
  }

  IconData _getSeverityIcon(BugSeverity severity) {
    switch (severity) {
      case BugSeverity.low:
        return Icons.info_outline;
      case BugSeverity.medium:
        return Icons.warning_amber;
      case BugSeverity.high:
        return Icons.error_outline;
      case BugSeverity.critical:
        return Icons.dangerous;
    }
  }

  Color _getSeverityColor(BugSeverity severity) {
    switch (severity) {
      case BugSeverity.low:
        return Colors.green;
      case BugSeverity.medium:
        return Colors.orange;
      case BugSeverity.high:
        return Colors.red;
      case BugSeverity.critical:
        return Colors.purple;
    }
  }

  Future<void> _submitBugReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final feedbackService = GetIt.instance<FeedbackApiService>();
      final deviceInfo = await feedbackService.getCurrentDeviceInfo();
      
      final bugReport = BugReportModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        stepsToReproduce: _stepsController.text.trim(),
        expectedBehavior: _expectedController.text.trim(),
        actualBehavior: _actualController.text.trim(),
        severity: _selectedSeverity,
        category: _selectedCategory,
        deviceInfo: deviceInfo,
        userEmail: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        userName: _nameController.text.trim().isEmpty 
            ? null 
            : _nameController.text.trim(),
      );

      final response = await feedbackService.submitBugReport(bugReport);

      if (response.success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(response.message);
      }
    } catch (e) {
      _showErrorDialog('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),
        title: const Text('Success!'),
        content: const Text(
          'Your bug report has been submitted successfully. Thank you for helping us improve CashFlow!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.error,
          color: Colors.red,
          size: 48,
        ),
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}