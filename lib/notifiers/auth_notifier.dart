import 'package:flutter_riverpod/legacy.dart';
import '../models/user.dart';

enum AuthStatus { initial, loading, otpSent, authenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? verificationId;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.verificationId,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? verificationId,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      // Simulate API call for sending OTP
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        status: AuthStatus.otpSent,
        verificationId: "mock_verification_id",
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "Failed to send OTP",
      );
    }
  }

  Future<void> verifyOtp(String otp, String phoneNumber) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      // Simulate API call for OTP verification
      await Future.delayed(const Duration(seconds: 2));
      // Mock user upon successful OTP
      final mockUser = User(id: '123', phoneNumber: phoneNumber);
      state = state.copyWith(status: AuthStatus.authenticated, user: mockUser);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "Invalid OTP",
      );
    }
  }

  Future<void> completeSignup(User updatedUser) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      // Simulate API call to save user details
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "Failed to save profile",
      );
    }
  }

  void logout() {
    state = const AuthState(status: AuthStatus.initial);
  }
}
