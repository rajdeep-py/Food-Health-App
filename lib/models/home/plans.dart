import 'package:flutter/material.dart';

class MealPlan {
  final String mealType; // e.g., Breakfast, Lunch
  final String foodName; // e.g., Oatmeal & Berries
  final int calories;
  final Color healthColor; // e.g., Colors.green, Colors.orange
  final bool isLogged;

  const MealPlan({
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.healthColor,
    this.isLogged = false,
  });
}
