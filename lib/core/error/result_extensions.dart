import 'package:flutter_bloc/flutter_bloc.dart';
import 'result.dart';
import 'failures.dart';

/// Extension methods for working with Result in Bloc context
extension ResultBlocExtensions<T> on Result<T> {
  /// Handle the result and emit appropriate states
  void handleResult<State>({
    required Emitter<State> emit,
    required State Function(T value) onSuccess,
    required State Function(AppFailure failure) onFailure,
  }) {
    fold(
      onSuccess: (value) => emit(onSuccess(value)),
      onFailure: (failure) => emit(onFailure(failure)),
    );
  }
  
  /// Handle the result asynchronously and emit appropriate states
  Future<void> handleResultAsync<State>({
    required Emitter<State> emit,
    required Future<State> Function(T value) onSuccess,
    required State Function(AppFailure failure) onFailure,
  }) async {
    fold(
      onSuccess: (value) async {
        final state = await onSuccess(value);
        emit(state);
      },
      onFailure: (failure) => emit(onFailure(failure)),
    );
  }
}

/// Extension for handling multiple Results
extension MultipleResultsExtensions on List<Result> {
  /// Combines multiple results into a single result
  /// Returns success only if all results are successful
  Result<List<T>> combineResults<T>() {
    final List<T> values = [];
    
    for (final result in this) {
      if (result.isFailure) {
        return failure<List<T>>(result.failure!);
      }
      values.add(result.value as T);
    }
    
    return success(values);
  }
}

/// Helper functions for common result operations
class ResultHelper {
  /// Execute a function and wrap the result in a Result type
  static Future<Result<T>> execute<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return success(result);
    } catch (e, stackTrace) {
      return failure(UnexpectedFailure(
        message: e.toString(),
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
  
  /// Execute a void function and return a successful Result<void>
  static Future<Result<void>> executeVoid(Future<void> Function() operation) async {
    try {
      await operation();
      return success<void>(null);
    } catch (e, stackTrace) {
      return failure(UnexpectedFailure(
        message: e.toString(),
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
  
  /// Convert a nullable result to a Result with appropriate failure
  static Result<T> fromNullable<T>(
    T? value, {
    required AppFailure Function() onNull,
  }) {
    if (value == null) {
      return failure(onNull());
    }
    return success(value);
  }
}