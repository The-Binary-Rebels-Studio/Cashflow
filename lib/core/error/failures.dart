import 'package:equatable/equatable.dart';


abstract class AppFailure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppFailure({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, originalError];

  @override
  String toString() => 'AppFailure(message: $message, code: $code)';
}


class DatabaseFailure extends AppFailure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'DatabaseFailure(message: $message, code: $code)';
}


class NetworkFailure extends AppFailure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'NetworkFailure(message: $message, code: $code)';
}


class ValidationFailure extends AppFailure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.fieldErrors = const {},
  });

  @override
  List<Object?> get props => [...super.props, fieldErrors];

  @override
  String toString() => 'ValidationFailure(message: $message, fieldErrors: $fieldErrors)';
}


class BusinessLogicFailure extends AppFailure {
  const BusinessLogicFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'BusinessLogicFailure(message: $message, code: $code)';
}


class NotFoundFailure extends AppFailure {
  final String resourceType;
  final String resourceId;

  const NotFoundFailure({
    required this.resourceType,
    required this.resourceId,
    super.code,
    super.originalError,
    super.stackTrace,
  }) : super(message: '$resourceType with ID $resourceId not found');

  @override
  List<Object?> get props => [...super.props, resourceType, resourceId];

  @override
  String toString() => 'NotFoundFailure(resourceType: $resourceType, resourceId: $resourceId)';
}


class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'UnauthorizedFailure(message: $message)';
}


class ServerFailure extends AppFailure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];

  @override
  String toString() => 'ServerFailure(message: $message, statusCode: $statusCode)';
}


class CacheFailure extends AppFailure {
  const CacheFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'CacheFailure(message: $message)';
}


class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'UnexpectedFailure(message: $message)';
}


class TransactionFailure extends AppFailure {
  const TransactionFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'TransactionFailure(message: $message, code: $code)';
}

class TransactionNotFoundFailure extends NotFoundFailure {
  const TransactionNotFoundFailure(String transactionId)
      : super(resourceType: 'Transaction', resourceId: transactionId);
}

class InvalidTransactionDataFailure extends ValidationFailure {
  const InvalidTransactionDataFailure({
    super.message = 'Invalid transaction data',
    super.fieldErrors = const {},
    super.code,
    super.originalError,
    super.stackTrace,
  });
}


class BudgetFailure extends AppFailure {
  const BudgetFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'BudgetFailure(message: $message, code: $code)';
}

class BudgetNotFoundFailure extends NotFoundFailure {
  const BudgetNotFoundFailure(String budgetId)
      : super(resourceType: 'Budget', resourceId: budgetId);
}

class InsufficientBudgetFailure extends BusinessLogicFailure {
  final double availableAmount;
  final double requestedAmount;

  const InsufficientBudgetFailure({
    required this.availableAmount,
    required this.requestedAmount,
    super.code,
    super.originalError,
    super.stackTrace,
  }) : super(
          message: 'Insufficient budget. Available: $availableAmount, Requested: $requestedAmount',
        );

  @override
  List<Object?> get props => [...super.props, availableAmount, requestedAmount];
}


class CategoryFailure extends AppFailure {
  const CategoryFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'CategoryFailure(message: $message, code: $code)';
}

class CategoryNotFoundFailure extends NotFoundFailure {
  const CategoryNotFoundFailure(String categoryId)
      : super(resourceType: 'Category', resourceId: categoryId);
}