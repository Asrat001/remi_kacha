import 'package:equatable/equatable.dart';
import '../data/models/exchange_rate_model.dart';

class ExchangeState extends Equatable {
  final bool isLoading;
  final double? convertedAmount;
  final String? errorMessage;
  final List<ExchangeRate> allRates;

  const ExchangeState({
    this.isLoading = false,
    this.convertedAmount,
    this.errorMessage,
    this.allRates=const[],
  });

  ExchangeState copyWith({
    bool? isLoading,
    double? convertedAmount,
    String? errorMessage,
    List<ExchangeRate>? allRates,
  }) {
    return ExchangeState(
      isLoading: isLoading ?? this.isLoading,
      convertedAmount: convertedAmount,
      errorMessage: errorMessage,
      allRates: allRates ?? this.allRates,
    );
  }

  @override
  List<Object?> get props => [isLoading, convertedAmount, errorMessage, allRates];
}
