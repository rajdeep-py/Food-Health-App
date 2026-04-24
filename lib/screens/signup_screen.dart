import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../models/user.dart';
import '../notifiers/auth_notifier.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedGender;
  double _weight = 70.0;
  double _height = 170.0;
  String? _selectedGoal;
  String? _selectedActivityLevel;
  String? _selectedDiet;
  final List<String> _selectedAllergies = [];

  final GlobalKey<FormState> _basicInfoKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0 && !_basicInfoKey.currentState!.validate()) {
      return;
    }
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSignup();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  void _completeSignup() {
    final authNotifier = ref.read(authProvider.notifier);
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      phoneNumber: _phoneController.text,
      name: _nameController.text,
      age: int.tryParse(_ageController.text),
      gender: _selectedGender,
      weight: _weight,
      height: _height,
      healthGoal: _selectedGoal,
      activityLevel: _selectedActivityLevel,
      dietaryPreference: _selectedDiet,
      allergies: _selectedAllergies,
    );
    authNotifier.completeSignup(user);
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPages, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // STEP 1: Basic Info
  Widget _buildBasicInfoStep(ThemeData theme) {
    return Form(
      key: _basicInfoKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tell us about yourself', style: theme.textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'We need some basic details to get started.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Full Name',
              prefixIcon: Icon(Iconsax.user_copy),
            ),
            validator: (value) => value!.isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Phone Number',
              prefixIcon: Icon(Iconsax.call_copy),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Enter your phone number' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Age',
                    prefixIcon: Icon(Iconsax.calendar_1_copy),
                  ),
                  validator: (value) => value!.isEmpty ? 'Age required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  hint: const Text('Gender'),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.profile_2user_copy),
                  ),
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // STEP 2: Body Metrics
  Widget _buildMetricsStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Body Metrics', style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          'To accurately calculate your needs.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Weight', style: theme.textTheme.titleLarge),
            Text(
              '${_weight.toStringAsFixed(1)} kg',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: _weight,
          min: 30,
          max: 150,
          divisions: 240,
          label: '${_weight.toStringAsFixed(1)} kg',
          onChanged: (value) => setState(() => _weight = value),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Height', style: theme.textTheme.titleLarge),
            Text(
              '${_height.toStringAsFixed(1)} cm',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: _height,
          min: 100,
          max: 220,
          divisions: 240,
          label: '${_height.toStringAsFixed(1)} cm',
          onChanged: (value) => setState(() => _height = value),
        ),
      ],
    );
  }

  // STEP 3: Goals
  Widget _buildGoalStep(ThemeData theme) {
    final goals = [
      {'title': 'Weight Loss', 'icon': Iconsax.chart_fail_copy},
      {'title': 'Muscle Gain', 'icon': Iconsax.weight_copy},
      {'title': 'Maintenance', 'icon': Iconsax.chart_2_copy},
      {'title': 'Better Health', 'icon': Iconsax.heart_copy},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What is your main goal?', style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          'We will personalize recommendations for you.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        ...goals.map((goal) {
          final title = goal['title'] as String;
          final icon = goal['icon'] as IconData;
          final isSelected = _selectedGoal == title;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _selectedGoal = title),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Iconsax.tick_circle_copy,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // STEP 4: Activity Level
  Widget _buildActivityStep(ThemeData theme) {
    final levels = [
      {'title': 'Sedentary', 'desc': 'Little to no exercise'},
      {'title': 'Light', 'desc': 'Light exercise 1-3 days/week'},
      {'title': 'Moderate', 'desc': 'Exercise 3-5 days/week'},
      {'title': 'Active', 'desc': 'Hard exercise 6-7 days/week'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Activity Level', style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          'How active are you on an average day?',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        ...levels.map((level) {
          final title = level['title'] as String;
          final desc = level['desc'] as String;
          final isSelected = _selectedActivityLevel == title;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _selectedActivityLevel = title),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(desc, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Iconsax.tick_circle_copy,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // STEP 5: Diet & Allergies
  Widget _buildDietStep(ThemeData theme) {
    final diets = [
      'Balanced',
      'Vegan',
      'Keto',
      'Paleo',
      'Vegetarian',
      'Pescatarian',
    ];
    final allergies = ['Dairy', 'Nuts', 'Gluten', 'Shellfish', 'Soy', 'Eggs'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dietary Preferences', style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text('Select your primary diet.', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: diets.map((diet) {
            final isSelected = _selectedDiet == diet;
            return ChoiceChip(
              label: Text(diet),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedDiet = selected ? diet : null);
              },
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
              showCheckmark: false,
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Text('Allergies', style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          'Select any ingredients you must avoid.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allergies.map((allergy) {
            final isSelected = _selectedAllergies.contains(allergy);
            return FilterChip(
              label: Text(allergy),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAllergies.add(allergy);
                  } else {
                    _selectedAllergies.remove(allergy);
                  }
                });
              },
              selectedColor: theme.colorScheme.error.withValues(alpha: 0.8),
              backgroundColor: theme.colorScheme.surface,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Signup Successful')));
        // Navigate to home here
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Explicitly use the theme background
      body: SafeArea(
        child: ResponsiveLayout(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.arrow_left_2_copy),
                      onPressed: _previousPage,
                    ),
                    Expanded(child: _buildProgressIndicator(theme)),
                    const SizedBox(width: 48), // Balance for back button
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildBasicInfoStep(theme),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildMetricsStep(theme),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildGoalStep(theme),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildActivityStep(theme),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildDietStep(theme),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: isLoading ? null : _nextPage,
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _currentPage == _totalPages - 1
                              ? 'Complete Setup'
                              : 'Next Step',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
