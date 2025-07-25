
// Holds the user password input
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordProvider = StateProvider<String>((ref) => '');

final allRulesPassedProvider = Provider((ref) {
  return ref.watch(hasMinLengthProvider) &&
      ref.watch(hasUppercaseProvider) &&
      ref.watch(hasLowercaseProvider) &&
      ref.watch(hasDigitProvider) &&
      ref.watch(hasSpecialCharProvider);
});

// Derived providers for each rule
final hasMinLengthProvider = Provider((ref) => ref.watch(passwordProvider).length >= 8);
final hasUppercaseProvider = Provider((ref) => RegExp(r'[A-Z]').hasMatch(ref.watch(passwordProvider)));
final hasLowercaseProvider = Provider((ref) => RegExp(r'[a-z]').hasMatch(ref.watch(passwordProvider)));
final hasDigitProvider = Provider((ref) => RegExp(r'[0-9]').hasMatch(ref.watch(passwordProvider)));
final hasSpecialCharProvider = Provider((ref) => RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(ref.watch(passwordProvider)));