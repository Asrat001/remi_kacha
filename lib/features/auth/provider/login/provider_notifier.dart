
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/auth/provider/login/provider_state.dart';
import '../../data/models/user_model.dart';
import '../../data/repos/user_repository.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final UserRepository userRepository;
  AuthNotifier({required this.userRepository}) : super(const AuthState());

  Future<void> login(String phoneNumber, String password) async {

    state = state.copyWith(loading: true, error: null);
    final result = await userRepository.login(phoneNumber: phoneNumber, password: password);
    result.fold((failure) => {
      state=state.copyWith(error: failure.message,loading: false)
    }, (user) async{
      state=state.copyWith(error:null,loading: false,isAuthenticated: true,user: user);
    });
  }

  bool profileNotCompleted(UserModel user) {
    return user.email.isEmpty&&user.pin.isEmpty&&user.name.isEmpty;
  }

  void logout() {
    state = const AuthState();
  }

  void cancelRequest() {
    state = const AuthState();
  }
}