import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconCodePoint;
  final String colorValue;
  final CategoryType type;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconCodePoint,
    required this.colorValue,
    required this.type,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? iconCodePoint,
    String? colorValue,
    CategoryType? type,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        description,
        iconCodePoint,
        colorValue,
        type,
        isActive,
        createdAt,
        updatedAt,
      ];
}

enum CategoryType {
  income('income'),
  expense('expense');

  const CategoryType(this.value);
  final String value;

  static CategoryType fromString(String value) {
    switch (value) {
      case 'income':
        return CategoryType.income;
      case 'expense':
        return CategoryType.expense;
      default:
        throw ArgumentError('Invalid category type: $value');
    }
  }
}