/// Generic API response model following REST API best practices
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final ApiError? error;
  final ApiMeta? meta;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
      error: json['error'] != null 
          ? ApiError.fromJson(json['error']) 
          : null,
      meta: json['meta'] != null 
          ? ApiMeta.fromJson(json['meta']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'error': error?.toJson(),
      'meta': meta?.toJson(),
    };
  }
}

/// API error model for standardized error handling
class ApiError {
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  final List<ValidationError>? validationErrors;

  const ApiError({
    required this.code,
    required this.message,
    this.details,
    this.validationErrors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      details: json['details'],
      validationErrors: json['validation_errors'] != null
          ? (json['validation_errors'] as List)
              .map((e) => ValidationError.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'details': details,
      'validation_errors': validationErrors?.map((e) => e.toJson()).toList(),
    };
  }
}

/// Validation error for field-specific errors
class ValidationError {
  final String field;
  final String message;
  final String? code;

  const ValidationError({
    required this.field,
    required this.message,
    this.code,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      field: json['field'] ?? '',
      message: json['message'] ?? '',
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'message': message,
      'code': code,
    };
  }
}

/// API metadata for pagination and additional info
class ApiMeta {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final String? timestamp;
  final String? version;

  const ApiMeta({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.timestamp,
    this.version,
  });

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      timestamp: json['timestamp'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
      'timestamp': timestamp,
      'version': version,
    };
  }
}