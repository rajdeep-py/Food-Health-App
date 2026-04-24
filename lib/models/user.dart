class User {
  final String id;
  final String phoneNumber;
  final String? name;
  final int? age;
  final String? gender;
  final String? healthGoal; // e.g., Weight Loss, Muscle Gain, Maintenance
  final String? dietaryPreference; // e.g., Vegan, Keto, Balanced

  const User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.age,
    this.gender,
    this.healthGoal,
    this.dietaryPreference,
  });

  User copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    int? age,
    String? gender,
    String? healthGoal,
    String? dietaryPreference,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      healthGoal: healthGoal ?? this.healthGoal,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
    );
  }

  // Optionally, you can add fromJson and toJson methods if interacting with an API
}
