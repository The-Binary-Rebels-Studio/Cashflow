import 'result.dart';
import 'failures.dart';


class ResultAdapter {
  
  
  static Future<T> unwrapOrThrow<T>(Future<Result<T>> resultFuture) async {
    final result = await resultFuture;
    
    return result.when(
      success: (value) => value,
      failure: (failure) => throw _convertFailureToException(failure),
    );
  }
  
  
  static T unwrapOrThrowSync<T>(Result<T> result) {
    return result.when(
      success: (value) => value,
      failure: (failure) => throw _convertFailureToException(failure),
    );
  }
  
  
  static Future<Result<T>> wrapAsyncOperation<T>(Future<T> Function() operation) async {
    try {
      final value = await operation();
      return success(value);
    } catch (e, stackTrace) {
      return failure(_convertExceptionToFailure(e, stackTrace));
    }
  }
  
  
  static Result<T> wrapSyncOperation<T>(T Function() operation) {
    try {
      final value = operation();
      return success(value);
    } catch (e, stackTrace) {
      return failure(_convertExceptionToFailure(e, stackTrace));
    }
  }
  
  
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


extension ResultAdapterExtensions<T> on Future<Result<T>> {
  
  Future<T> unwrapOrThrow() => ResultAdapter.unwrapOrThrow(this);
}

extension SyncResultAdapterExtensions<T> on Result<T> {
  
  T unwrapOrThrow() => ResultAdapter.unwrapOrThrowSync(this);
}


mixin ResultCompatibilityMixin {
  
  Future<T> compatibleCall<T>(Future<Result<T>> resultOperation) async {
    return await ResultAdapter.unwrapOrThrow(resultOperation);
  }
  
  
  Future<Result<T>> resultCall<T>(Future<Result<T>> resultOperation) async {
    return await resultOperation;
  }
}


