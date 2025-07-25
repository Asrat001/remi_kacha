import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/auth/data/repos/user_repository.dart';
import 'package:remi_kacha/features/auth/provider/login/provider_state.dart';
import 'package:remi_kacha/features/auth/provider/login/provider_notifier.dart';




// Provide the repository
final authRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);

final authProvider = StateNotifierProvider.autoDispose<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(userRepository: ref.read(authRepositoryProvider)),
);
