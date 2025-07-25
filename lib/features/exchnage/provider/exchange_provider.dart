import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repo/exchange_repository.dart';
import 'exchange_notifire.dart';
import 'exchange_state.dart';

final exchangeRepositoryProvider = Provider<ExchangeRepository>((ref) {
  return ExchangeRepository();
});

final exchangeNotifierProvider =
StateNotifierProvider<ExchangeNotifier, ExchangeState>((ref) {
  final repo = ref.read(exchangeRepositoryProvider);
  return ExchangeNotifier(repo);
});