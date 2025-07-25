import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final int? id;
  final int userId;
  final double balance;
  final String currency;

  const Wallet({
    this.id,
    required this.userId,
    required this.balance,
    required this.currency,
  });

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'],
      userId: map['user_id'],
      balance: map['balance'],
      currency: map['currency'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'currency': currency,
    };
  }

  Wallet copyWith({
    int? id,
    int? userId,
    double? balance,
    String? currency,
  }) {
    return Wallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [id, userId, balance, currency];
}
