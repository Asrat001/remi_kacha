import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repo/exchange_repository.dart';
import 'exchange_state.dart';

class ExchangeNotifier extends StateNotifier<ExchangeState> {
  final ExchangeRepository repository;

  ExchangeNotifier(this.repository) : super(const ExchangeState());

  Future<void> convert({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await repository.convertCurrency(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        amount: amount,
      );

      if (result != null) {
        state = state.copyWith(
          isLoading: false,
          convertedAmount: result,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Rate not found",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchAndInsertExchangeRates() async {
    try {
      await repository.fetchAndInsertExchangeRates();
    } catch (e) {
     print(e);
    }
  }

  Future<void> fetchAllExchangeRates() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final rates = await repository.getAllExchangeRates();
      state = state.copyWith(isLoading: false, allRates: rates);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
