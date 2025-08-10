import 'failures.dart';

/// A sealed class representing the result of an operation that can either succeed or fail.
/// This provides a type-safe way to handle errors without throwing exceptions.
sealed class Result<T> {
  const Result();
  
  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;
  
  /// Returns true if this is a failure result
  bool get isFailure => this is Failure<T>;
  
  /// Returns the value if this is a success, null otherwise
  T? get value => switch (this) {
    Success(value: final v) => v,
    Failure() => null,
  };
  
  /// Returns the failure if this is a failure, null otherwise
  AppFailure? get failure => switch (this) {
    Success() => null,
    Failure(failure: final f) => f,
  };
  
  /// Maps the value if this is a success, otherwise returns the failure
  Result<U> map<U>(U Function(T value) mapper) {
    return switch (this) {
      Success(value: final v) => Success(mapper(v)),
      Failure(failure: final f) => Failure(f),
    };
  }
  
  /// Flat maps the value if this is a success, otherwise returns the failure
  Result<U> flatMap<U>(Result<U> Function(T value) mapper) {
    return switch (this) {
      Success(value: final v) => mapper(v),
      Failure(failure: final f) => Failure(f),
    };
  }
  
  /// Executes the appropriate callback based on the result type
  U when<U>({
    required U Function(T value) success,
    required U Function(AppFailure failure) failure,
  }) {
    return switch (this) {
      Success(value: final v) => success(v),
      Failure(failure: final f) => failure(f),
    };
  }
  
  /// Executes the appropriate callback based on the result type (void version)
  void fold({
    required void Function(T value) onSuccess,
    required void Function(AppFailure failure) onFailure,
  }) {
    switch (this) {
      case Success(value: final v):
        onSuccess(v);
      case Failure(failure: final f):
        onFailure(f);
    }
  }
}

/// Represents a successful operation result
final class Success<T> extends Result<T> {
  @override
  final T value;
  
  const Success(this.value);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'Success($value)';
}

/// Represents a failed operation result
final class Failure<T> extends Result<T> {
  @override
  final AppFailure failure;
  
  const Failure(this.failure);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;
  
  @override
  int get hashCode => failure.hashCode;
  
  @override
  String toString() => 'Failure($failure)';
}

/// Convenience methods for creating Result instances
extension ResultExtensions on Result {
  /// Creates a successful result
  static Result<T> success<T>(T value) => Success(value);
  
  /// Creates a failed result
  static Result<T> failure<T>(AppFailure failure) => Failure(failure);
}

/// Convenience constructors
Result<T> success<T>(T value) => Success(value);
Result<T> failure<T>(AppFailure failure) => Failure(failure);