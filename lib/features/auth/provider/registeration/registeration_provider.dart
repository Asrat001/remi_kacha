
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/auth/provider/registeration/provider_notifier.dart';
import 'package:remi_kacha/features/auth/provider/registeration/ptovider_state.dart';
import '../login/auth_provider.dart';

final registrationProvider = StateNotifierProvider<RegistrationNotifier, RegistrationState>(
      (ref) => RegistrationNotifier(userRepository: ref.read(authRepositoryProvider)),
);
