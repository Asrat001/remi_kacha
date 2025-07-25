import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final int? id;
  final int senderId;
  final String recipient;
  final String? bank;
  final String? accountNo;
  final double amount;
  final String currency;
  final String timestamp;

  const TransactionModel({
    this.id,
    required this.senderId,
    required this.recipient,
    this.bank,
    this.accountNo,
    required this.amount,
    required this.currency,
    required this.timestamp,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      senderId: map['sender_id'],
      recipient: map['recipient'],
      bank: map['bank'],
      accountNo: map['account_no'],
      amount: map['amount'],
      currency: map['currency'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'recipient': recipient,
      'bank': bank,
      'account_no': accountNo,
      'amount': amount,
      'currency': currency,
      'timestamp': timestamp,
    };
  }

  TransactionModel copyWith({
    int? id,
    int? senderId,
    String? recipient,
    String? bank,
    String? accountNo,
    double? amount,
    String? currency,
    String? timestamp,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      recipient: recipient ?? this.recipient,
      bank: bank ?? this.bank,
      accountNo: accountNo ?? this.accountNo,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
    id,
    senderId,
    recipient,
    bank,
    accountNo,
    amount,
    currency,
    timestamp,
  ];
}
