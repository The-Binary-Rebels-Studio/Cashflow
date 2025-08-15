import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:cashflow/l10n/app_localizations.dart';
import 'package:cashflow/core/models/bug_report_model.dart';
import 'package:cashflow/features/profile/presentation/bloc/feedback_bloc.dart';
import 'package:cashflow/features/profile/presentation/bloc/feedback_event.dart';
import 'package:cashflow/features/profile/presentation/bloc/feedback_state.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({super.key});

  @override
  State<BugReportPage> createState() => _BugReportPageState();
}

class BugReportPageWrapper extends StatelessWidget {
  const BugReportPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<FeedbackBloc>(),
      child: const BugReportPage(),
    );
  }
}

class _BugReportPageState extends State<BugReportPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _expectedController = TextEditingController();
  final TextEditingController _actualController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DeviceInfo? _deviceInfo;

  @override
  void initState() {
    super.initState();
    // Request device info when page loads
    context.read<FeedbackBloc>().add(const FeedbackDeviceInfoRequested());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    _expectedController.dispose();
    _actualController.dispose();
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
          l10n.reportBug,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackBugReportSuccess) {
            _showSuccessToast(state.message);
          } else if (state is FeedbackError) {
            _showErrorToast(l10n.bugReportFailed);
          } else if (state is FeedbackDeviceInfoSuccess) {
            setState(() {
              _deviceInfo = state.deviceInfo;
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667eea).withValues(alpha: 0.3),
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
                          Icons.bug_report,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.bugReportTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.bugReportSubtitle,
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

                // Bug Title
                _buildFormSection(
                  l10n.bugTitleRequired,
                  TextFormField(
                    controller: _titleController,
                    decoration: _buildInputDecoration(
                      hintText: l10n.bugTitleHint,
                      prefixIcon: Icon(
                        Icons.title_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.bugDescriptionError;
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Bug Description
                _buildFormSection(
                  l10n.bugDescription,
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: _buildInputDecoration(
                      hintText: l10n.bugDescriptionHint,
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
                        return l10n.bugDescriptionError;
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Steps to Reproduce
                _buildFormSection(
                  l10n.stepsToReproduce,
                  TextFormField(
                    controller: _stepsController,
                    maxLines: 4,
                    decoration: _buildInputDecoration(
                      hintText: l10n.stepsToReproduceHint,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 64),
                        child: Icon(
                          Icons.format_list_numbered,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.stepsToReproduceError;
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Expected Behavior
                _buildFormSection(
                  l10n.expectedBehaviorRequired,
                  TextFormField(
                    controller: _expectedController,
                    maxLines: 3,
                    decoration: _buildInputDecoration(
                      hintText: l10n.expectedBehaviorHint,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 48),
                        child: Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.expectedBehaviorError;
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Actual Behavior
                _buildFormSection(
                  l10n.actualBehaviorRequired,
                  TextFormField(
                    controller: _actualController,
                    maxLines: 3,
                    decoration: _buildInputDecoration(
                      hintText: l10n.actualBehaviorHint,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 48),
                        child: Icon(
                          Icons.error_outline,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.actualBehaviorError;
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Device Info
                _buildFormSection(
                  l10n.debugInformation,
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
                              l10n.debugInfoAutoIncluded,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_deviceInfo != null) ...[
                          Text(
                            'Platform: ${_deviceInfo!.platform}\n'
                            'OS Version: ${_deviceInfo!.osVersion}\n'
                            'App Version: ${_deviceInfo!.appVersion}\n'
                            'Device Model: ${_deviceInfo!.deviceModel}\n'
                            'Locale: ${_deviceInfo!.locale ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'monospace',
                              height: 1.4,
                            ),
                          ),
                        ] else ...[
                          Text(
                            l10n.deviceInfoLoading,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'monospace',
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Submit Button
                BlocBuilder<FeedbackBloc, FeedbackState>(
                  builder: (context, state) {
                    final isLoading = state is FeedbackLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _submitBugReport,
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
                          isLoading
                              ? l10n.bugReportSubmittingMessage
                              : l10n.submitBugReport,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667eea),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: const Color(
                            0xFF667eea,
                          ).withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  },
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
        borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
    );
  }

  void _submitBugReport() {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate() || _deviceInfo == null) {
      if (_deviceInfo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deviceInfoLoading),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final bugReport = BugReportModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      stepsToReproduce: _stepsController.text.trim(),
      expectedBehavior: _expectedController.text.trim(),
      actualBehavior: _actualController.text.trim(),
      deviceInfo: _deviceInfo!,
    );

    context.read<FeedbackBloc>().add(
      FeedbackBugReportSubmitted(bugReport: bugReport),
    );
  }

  void _showSuccessToast(String message) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.bugReportSubmitted),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Navigate back after showing toast
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _showErrorToast(String localizedMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizedMessage),
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
}
