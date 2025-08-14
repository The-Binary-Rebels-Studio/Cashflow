/// Model for feature suggestion submission and response
class SuggestionModel {
  final String? id;
  final String title;
  final String description;
  final SuggestionCategory category;
  final SuggestionPriority priority;
  final String? userEmail;
  final String? userName;
  final SuggestionStatus? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  const SuggestionModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.userEmail,
    this.userName,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: SuggestionCategory.fromString(json['category'] ?? ''),
      priority: SuggestionPriority.fromString(json['priority'] ?? ''),
      userEmail: json['user_email'],
      userName: json['user_name'],
      status: json['status'] != null 
          ? SuggestionStatus.fromString(json['status']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.value,
      'priority': priority.value,
      'user_email': userEmail,
      'user_name': userName,
      'status': status?.value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create request payload for submission (excludes server-managed fields)
  Map<String, dynamic> toRequestJson() {
    return {
      'title': title,
      'description': description,
      'category': category.value,
      'priority': priority.value,
      'user_email': userEmail,
      'user_name': userName,
      'metadata': metadata,
    };
  }

  SuggestionModel copyWith({
    String? id,
    String? title,
    String? description,
    SuggestionCategory? category,
    SuggestionPriority? priority,
    String? userEmail,
    String? userName,
    SuggestionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return SuggestionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Enum for suggestion categories
enum SuggestionCategory {
  feature('feature'),
  improvement('improvement'),
  ui('ui'),
  performance('performance'),
  integration('integration'),
  other('other');

  const SuggestionCategory(this.value);
  final String value;

  static SuggestionCategory fromString(String value) {
    return SuggestionCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SuggestionCategory.other,
    );
  }

  String get displayName {
    switch (this) {
      case SuggestionCategory.feature:
        return 'New Feature';
      case SuggestionCategory.improvement:
        return 'Improvement';
      case SuggestionCategory.ui:
        return 'UI/UX';
      case SuggestionCategory.performance:
        return 'Performance';
      case SuggestionCategory.integration:
        return 'Integration';
      case SuggestionCategory.other:
        return 'Other';
    }
  }
}

/// Enum for suggestion priority levels
enum SuggestionPriority {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  const SuggestionPriority(this.value);
  final String value;

  static SuggestionPriority fromString(String value) {
    return SuggestionPriority.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SuggestionPriority.medium,
    );
  }

  String get displayName {
    switch (this) {
      case SuggestionPriority.low:
        return 'Low';
      case SuggestionPriority.medium:
        return 'Medium';
      case SuggestionPriority.high:
        return 'High';
      case SuggestionPriority.critical:
        return 'Critical';
    }
  }
}

/// Enum for suggestion status (server-managed)
enum SuggestionStatus {
  submitted('submitted'),
  underReview('under_review'),
  accepted('accepted'),
  rejected('rejected'),
  implemented('implemented');

  const SuggestionStatus(this.value);
  final String value;

  static SuggestionStatus fromString(String value) {
    return SuggestionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SuggestionStatus.submitted,
    );
  }

  String get displayName {
    switch (this) {
      case SuggestionStatus.submitted:
        return 'Submitted';
      case SuggestionStatus.underReview:
        return 'Under Review';
      case SuggestionStatus.accepted:
        return 'Accepted';
      case SuggestionStatus.rejected:
        return 'Rejected';
      case SuggestionStatus.implemented:
        return 'Implemented';
    }
  }
}