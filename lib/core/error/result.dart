import 'failures.dart';


sealed class Result<T> {
  const Result();
  
  
  bool get isSuccess => this is Success<T>;
  
  
  bool get isFailure => this is Failure<T>;
  
  
  T? get value => switch (this) {
    Success(value: final v) => v,
    Failure() => null,
  };
  
  
  AppFailure? get failure => switch (this) {
    Success() => null,
    Failure(failure: final f) => f,
  };
  
  
  Result<U> map<U>(U Function(T value) mapper) {
    return switch (this) {
      Success(value: final v) => Success(mapper(v)),
      Failure(failure: final f) => Failure(f),
    };
  }
  
  
  Result<U> flatMap<U>(Result<U> Function(T value) mapper) {
    return switch (this) {
      Success(value: final v) => mapper(v),
      Failure(failure: final f) => Failure(f),
    };
  }
  
  
  U when<U>({
    required U Function(T value) success,
    required U Function(AppFailure failure) failure,
  }) {
    return switch (this) {
      Success(value: final v) => success(v),
      Failure(failure: final f) => failure(f),
    };
  }
  
  
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


extension ResultExtensions on Result {
  
  static Result<T> success<T>(T value) => Success(value);
  
  
  static Result<T> failure<T>(AppFailure failure) => Failure(failure);
}


Result<T> success<T>(T value) => Success(value);
Result<T> failure<T>(AppFailure failure) => Failure(failure);