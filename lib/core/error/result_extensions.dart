import 'package:flutter_bloc/flutter_bloc.dart';
import 'result.dart';
import 'failures.dart';


extension ResultBlocExtensions<T> on Result<T> {
  
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


extension MultipleResultsExtensions on List<Result> {
  
  
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


class ResultHelper {
  
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