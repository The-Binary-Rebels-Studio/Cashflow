import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/models/suggestion_model.dart';
import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';
import '../bloc/feedback_state.dart';

class SuggestionPageClean extends StatelessWidget {
  const SuggestionPageClean({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<FeedbackBloc>(),
      child: const _SuggestionPageView(),
    );
  }
}

class _SuggestionPageView extends StatefulWidget {
  const _SuggestionPageView();

  @override
  State<_SuggestionPageView> createState() => _SuggestionPageViewState();
}

class _SuggestionPageViewState extends State<_SuggestionPageView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  
  SuggestionCategory _selectedCategory = SuggestionCategory.feature;
  SuggestionPriority _selectedPriority = SuggestionPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Suggestion'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSuggestionSuccess) {
            _showSuccessDialog(state.message);
          } else if (state is FeedbackError) {
            _showErrorDialog(state.userMessage);
          }
        },
        child: SafeArea(
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
                  _buildCategoryField(),
                  const SizedBox(height: 16),
                  _buildPriorityField(),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue[600],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Share Your Ideas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Help us improve CashFlow by sharing your feature suggestions and ideas. Your feedback is valuable to us!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
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
        labelText: 'Suggestion Title *',
        hintText: 'e.g., Add Dark Mode Support',
        prefixIcon: const Icon(Icons.title),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title for your suggestion';
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
        labelText: 'Description *',
        hintText: 'Describe your suggestion in detail...',
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
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

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
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
            child: DropdownButton<SuggestionCategory>(
              value: _selectedCategory,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (SuggestionCategory? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
              items: SuggestionCategory.values.map((category) {
                return DropdownMenuItem<SuggestionCategory>(
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

  Widget _buildPriorityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: SuggestionPriority.values.map((priority) {
            final isSelected = _selectedPriority == priority;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPriority = priority;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? _getPriorityColor(priority).withValues(alpha: 0.1)
                        : Colors.grey[100],
                    border: Border.all(
                      color: isSelected 
                          ? _getPriorityColor(priority)
                          : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getPriorityIcon(priority),
                        color: isSelected 
                            ? _getPriorityColor(priority)
                            : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        priority.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected 
                              ? _getPriorityColor(priority)
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
          'Provide your contact details if you\'d like us to follow up on your suggestion.',
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
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) {
        final isLoading = state is FeedbackLoading;
        
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitSuggestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(state.message ?? 'Submitting...'),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 8),
                      Text(
                        'Submit Suggestion',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(SuggestionCategory category) {
    switch (category) {
      case SuggestionCategory.feature:
        return Icons.add_box_outlined;
      case SuggestionCategory.improvement:
        return Icons.trending_up;
      case SuggestionCategory.ui:
        return Icons.design_services;
      case SuggestionCategory.performance:
        return Icons.speed;
      case SuggestionCategory.integration:
        return Icons.extension;
      case SuggestionCategory.other:
        return Icons.more_horiz;
    }
  }

  IconData _getPriorityIcon(SuggestionPriority priority) {
    switch (priority) {
      case SuggestionPriority.low:
        return Icons.keyboard_arrow_down;
      case SuggestionPriority.medium:
        return Icons.remove;
      case SuggestionPriority.high:
        return Icons.keyboard_arrow_up;
      case SuggestionPriority.critical:
        return Icons.priority_high;
    }
  }

  Color _getPriorityColor(SuggestionPriority priority) {
    switch (priority) {
      case SuggestionPriority.low:
        return Colors.green;
      case SuggestionPriority.medium:
        return Colors.orange;
      case SuggestionPriority.high:
        return Colors.red;
      case SuggestionPriority.critical:
        return Colors.purple;
    }
  }

  void _submitSuggestion() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final suggestion = SuggestionModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      priority: _selectedPriority,
      userEmail: _emailController.text.trim().isEmpty 
          ? null 
          : _emailController.text.trim(),
      userName: _nameController.text.trim().isEmpty 
          ? null 
          : _nameController.text.trim(),
    );

    context.read<FeedbackBloc>().add(
      FeedbackSuggestionSubmitted(suggestion: suggestion),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),
        title: const Text('Success!'),
        content: Text(message),
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