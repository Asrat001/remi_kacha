import 'package:remi_kacha/features/auth/data/models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool loading;
  final String? error;
  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.loading = false,
    this.error,
  });

  AuthState copyWith({bool? isAuthenticated,UserModel? user, bool? loading, String? error}) =>
      AuthState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        user: user,
        loading: loading ?? this.loading,
        error: error,
      );
}