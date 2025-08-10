import 'package:flutter/material.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconCodePoint,
    required super.colorValue,
    required super.type,
    super.isActive = true,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      iconCodePoint: map['icon_code_point'] as String,
      colorValue: map['color_value'] as String,
      type: CategoryType.fromString(map['type'] as String),
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      iconCodePoint: entity.iconCodePoint,
      colorValue: entity.colorValue,
      type: entity.type,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_code_point': iconCodePoint,
      'color_value': colorValue,
      'type': type.value,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  IconData get icon {
    return IconData(
      int.parse(iconCodePoint),
      fontFamily: 'MaterialIcons',
    );
  }

  Color get color {
    return Color(int.parse(colorValue));
  }

  @override
  CategoryModel copyWith({
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
    return CategoryModel(
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
}

class PredefinedCategories {
  static const List<Map<String, dynamic>> expenseCategories = [
    {
      'name': 'Food & Dining',
      'description': 'Restaurants, groceries, and food delivery',
      'icon_code_point': '0xe57d', // Icons.restaurant
      'color_value': '0xFFFF9800', // Orange
    },
    {
      'name': 'Transportation',
      'description': 'Gas, public transport, taxi, and car maintenance',
      'icon_code_point': '0xe539', // Icons.directions_car
      'color_value': '0xFF2196F3', // Blue
    },
    {
      'name': 'Shopping',
      'description': 'Clothing, electronics, and general shopping',
      'icon_code_point': '0xe59c', // Icons.shopping_cart
      'color_value': '0xFFE91E63', // Pink
    },
    {
      'name': 'Bills & Utilities',
      'description': 'Electricity, water, internet, phone bills',
      'icon_code_point': '0xe8e5', // Icons.receipt_long
      'color_value': '0xFF9C27B0', // Purple
    },
    {
      'name': 'Healthcare',
      'description': 'Medical expenses, pharmacy, insurance',
      'icon_code_point': '0xe559', // Icons.local_hospital
      'color_value': '0xFFF44336', // Red
    },
    {
      'name': 'Entertainment',
      'description': 'Movies, games, subscriptions, hobbies',
      'icon_code_point': '0xe01d', // Icons.movie
      'color_value': '0xFF673AB7', // Deep Purple
    },
    {
      'name': 'Education',
      'description': 'Books, courses, tuition, school supplies',
      'icon_code_point': '0xe80c', // Icons.school
      'color_value': '0xFF3F51B5', // Indigo
    },
    {
      'name': 'Travel',
      'description': 'Hotels, flights, vacation expenses',
      'icon_code_point': '0xe539', // Icons.flight
      'color_value': '0xFF00BCD4', // Cyan
    },
  ];

  static const List<Map<String, dynamic>> incomeCategories = [
    {
      'name': 'Salary',
      'description': 'Monthly salary and wages',
      'icon_code_point': '0xe8e6', // Icons.work
      'color_value': '0xFF4CAF50', // Green
    },
    {
      'name': 'Freelance',
      'description': 'Freelance projects and gigs',
      'icon_code_point': '0xe8e6', // Icons.laptop
      'color_value': '0xFF8BC34A', // Light Green
    },
    {
      'name': 'Business',
      'description': 'Business income and profit',
      'icon_code_point': '0xe2bc', // Icons.business
      'color_value': '0xFF4CAF50', // Green
    },
    {
      'name': 'Investment',
      'description': 'Dividends, stock gains, crypto',
      'icon_code_point': '0xe8e8', // Icons.trending_up
      'color_value': '0xFF4CAF50', // Green
    },
    {
      'name': 'Bonus',
      'description': 'Work bonus and incentives',
      'icon_code_point': '0xe8e2', // Icons.card_giftcard
      'color_value': '0xFF4CAF50', // Green
    },
    {
      'name': 'Other Income',
      'description': 'Other sources of income',
      'icon_code_point': '0xe263', // Icons.attach_money
      'color_value': '0xFF4CAF50', // Green
    },
  ];
}