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
  final int _totalPages = 3;

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGoal;
  String? _selectedDiet;

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
      healthGoal: _selectedGoal,
      dietaryPreference: _selectedDiet,
    );
    authNotifier.completeSignup(user);
    // Note: listening to authProvider handles navigation on success
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
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Age',
              prefixIcon: Icon(Iconsax.calendar_1_copy),
            ),
            validator: (value) => value!.isEmpty ? 'Enter your age' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalStep(ThemeData theme) {
    final goals = [
      'Weight Loss',
      'Muscle Gain',
      'Maintenance',
      'Better Health',
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
          final isSelected = _selectedGoal == goal;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _selectedGoal = goal),
              borderRadius: BorderRadius.circular(16),
              child: Container(
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
                      child: Text(
                        goal,
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

  Widget _buildDietStep(ThemeData theme) {
    final diets = ['Balanced', 'Vegan', 'Keto', 'Paleo', 'Vegetarian'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Any dietary preferences?', style: theme.textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          'This helps us filter out what you can\'t eat.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: diets.map((diet) {
            final isSelected = _selectedDiet == diet;
            return InkWell(
              onTap: () => setState(() => _selectedDiet = diet),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  diet,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
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
                      child: _buildGoalStep(theme),
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
