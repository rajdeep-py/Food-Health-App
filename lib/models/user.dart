class User {
  final String id;
  final String phoneNumber;
  final String? name;
  final int? age;
  final String? gender;
  final String? healthGoal; // e.g., Weight Loss, Muscle Gain, Maintenance
  final String? dietaryPreference; // e.g., Vegan, Keto, Balanced
  final double? weight; // in kg
  final double? height; // in cm
  final String? activityLevel; // Sedentary, Light, Moderate, Active
  final List<String>? allergies;

  const User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.age,
    this.gender,
    this.healthGoal,
    this.dietaryPreference,
    this.weight,
    this.height,
    this.activityLevel,
    this.allergies,
  });

  User copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    int? age,
    String? gender,
    String? healthGoal,
    String? dietaryPreference,
    double? weight,
    double? height,
    String? activityLevel,
    List<String>? allergies,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      healthGoal: healthGoal ?? this.healthGoal,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      allergies: allergies ?? this.allergies,
    );
  }
}
