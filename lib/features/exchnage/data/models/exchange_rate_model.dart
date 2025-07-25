import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String currencyCode;
  final double rate;
  final String timestamp;

  const ExchangeRate({
    required this.currencyCode,
    required this.rate,
    required this.timestamp,
  });

  factory ExchangeRate.fromMap(Map<String, dynamic> map) {
    return ExchangeRate(
      currencyCode: map['currency_code'],
      rate: (map['rate'] as num).toDouble(),
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currency_code': currencyCode,
      'rate': rate,
      'timestamp': timestamp,
    };
  }

  @override
  List<Object> get props => [currencyCode];
}
