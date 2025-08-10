import 'result.dart';
import 'failures.dart';

/// Adapter to maintain backward compatibility while introducing Result pattern
/// This allows gradual migration from exception-based to Result-based error handling
class ResultAdapter {
  /// Convert a Result<T> back to the old exception-throwing pattern
  /// Use this temporarily while migrating existing code
  static Future<T> unwrapOrThrow<T>(Future<Result<T>> resultFuture) async {
    final result = await resultFuture;
    
    return result.when(
      success: (value) => value,
      failure: (failure) => throw _convertFailureToException(failure),
    );
  }
  
  /// Convert synchronous Result<T> to value or throw exception
  static T unwrapOrThrowSync<T>(Result<T> result) {
    return result.when(
      success: (value) => value,
      failure: (failure) => throw _convertFailureToException(failure),
    );
  }
  
  /// Wrap exception-throwing code in Result pattern
  static Future<Result<T>> wrapAsyncOperation<T>(Future<T> Function() operation) async {
    try {
      final value = await operation();
      return success(value);
    } catch (e, stackTrace) {
      return failure(_convertExceptionToFailure(e, stackTrace));
    }
  }
  
  /// Wrap synchronous operation in Result pattern
  static Result<T> wrapSyncOperation<T>(T Function() operation) {
    try {
      final value = operation();
      return success(value);
    } catch (e, stackTrace) {
      return failure(_convertExceptionToFailure(e, stackTrace));
    }
  }
  
  /// Convert AppFailure to appropriate Exception for backward compatibility
  static Exception _convertFailureToException(AppFailure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure:
        return Exception('Validation error: ${failure.message}');
      case NotFoundFailure:
        return Exception('Not found: ${failure.message}');
      case NetworkFailure:
        return Exception('Network error: ${failure.message}');
      case DatabaseFailure:
        return Exception('Database error: ${failure.message}');
      case BusinessLogicFailure:
        return Exception('Business logic error: ${failure.message}');
      default:
        return Exception(failure.message);
    }
  }
  
  /// Convert Exception to appropriate AppFailure
  static AppFailure _convertExceptionToFailure(dynamic exception, StackTrace? stackTrace) {
    final errorMessage = exception.toString();
    
    if (exception is ArgumentError) {
      return ValidationFailure(
        message: errorMessage,
        originalError: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is StateError) {
      return BusinessLogicFailure(
        message: errorMessage,
        originalError: exception,
        stackTrace: stackTrace,
      );
    } else if (errorMessage.toLowerCase().contains('network')) {
      return NetworkFailure(
        message: errorMessage,
        originalError: exception,
        stackTrace: stackTrace,
      );
    } else if (errorMessage.toLowerCase().contains('database') || 
               errorMessage.toLowerCase().contains('sql')) {
      return DatabaseFailure(
        message: errorMessage,
        originalError: exception,
        stackTrace: stackTrace,
      );
    } else {
      return UnexpectedFailure(
        message: errorMessage,
        originalError: exception,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Extension methods to easily adapt existing use cases
extension ResultAdapterExtensions<T> on Future<Result<T>> {
  /// Convert Result to exception-throwing for backward compatibility
  Future<T> unwrapOrThrow() => ResultAdapter.unwrapOrThrow(this);
}

extension SyncResultAdapterExtensions<T> on Result<T> {
  /// Convert Result to exception-throwing for backward compatibility
  T unwrapOrThrow() => ResultAdapter.unwrapOrThrowSync(this);
}

/// Mixin for use cases that want to provide both Result and exception-based APIs
mixin ResultCompatibilityMixin {
  /// Wrap an operation to provide both APIs during migration
  Future<T> compatibleCall<T>(Future<Result<T>> resultOperation) async {
    return await ResultAdapter.unwrapOrThrow(resultOperation);
  }
  
  /// Get the Result version of the operation
  Future<Result<T>> resultCall<T>(Future<Result<T>> resultOperation) async {
    return await resultOperation;
  }
}

/// Example of how to modify existing use cases gradually
/// 
/// Before (exception-based):
/// ```dart
/// class GetTransactionTotalUseCase {
///   Future<double> call(String categoryId) async {
///     final total = await repository.getTotal(categoryId);
///     return total;
///   }
/// }
/// ```
/// 
/// During migration (both APIs):
/// ```dart
/// class GetTransactionTotalUseCase with ResultCompatibilityMixin {
///   // New Result-based method
///   Future<Result<double>> callWithResult(String categoryId) async {
///     return wrapAsyncOperation(() => repository.getTotal(categoryId));
///   }
///   
///   // Backward compatible method
///   Future<double> call(String categoryId) async {
///     return compatibleCall(callWithResult(categoryId));
///   }
/// }
/// ```
/// 
/// After migration (Result-only):
/// ```dart
/// class GetTransactionTotalUseCase {
///   Future<Result<double>> call(String categoryId) async {
///     // Full Result implementation
///   }
/// }
/// ```