import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceLockProvider = StateNotifierProvider<BalanceLockNotifier, bool>(
  (ref) => BalanceLockNotifier(),
);

class BalanceLockNotifier extends StateNotifier<bool> {
  BalanceLockNotifier() : super(false);

  void toggle() => state = !state;
}
