import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/auth/provider/registeration/ptovider_state.dart';
import '../../data/repos/user_repository.dart';

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final UserRepository userRepository;
  RegistrationNotifier({required this.userRepository}) : super(const RegistrationState());

  Future<void> registerUser({
    required String phoneNumber,
    required String password,
   }) async {
    state = state.copyWith(loading: true, error: null);
    final result = await userRepository.registerUser(phoneNumber: phoneNumber, password: password,);
    result.fold((failure) => {
      state=state.copyWith(error: failure.message,loading: false)
    }, (success) => {
      state=state.copyWith(error:null,loading: false,success: true,userId: success)
    });
  }

  Future<void> updateUserData({
    required String name,
    required String email,
    required String pin,
    required int userId
  }) async {
    state = state.copyWith(loading: true, error: null);
    final result = await userRepository.updateUserById(pin: pin, email: email,name: name, userId: userId);
    result.fold((failure) => {
      state=state.copyWith(error: failure.message,loading: false)
    }, (success) => {
      state=state.copyWith(error:null,loading: false,success: true)
    });
  }

  void cancelRequest() {
    state = const RegistrationState();
  }
}