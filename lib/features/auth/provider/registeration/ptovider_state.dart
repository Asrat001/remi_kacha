class RegistrationState {
  final bool success;
  final int? userId;
  final bool loading;
  final String? error;
  const RegistrationState({
    this.success=false,
    this.loading = false,
    this.userId,
    this.error,
  });

  RegistrationState copyWith({bool? success, bool? loading, String? error,int ?userId}) =>
      RegistrationState(
        success: success??this.success,
        userId: userId,
        loading: loading ?? this.loading,
        error: error,
      );
}