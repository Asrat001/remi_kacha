
import 'package:remi_kacha/common/models/transaction_model.dart';
import 'package:remi_kacha/features/wallet/data/models/wallet_model.dart';


class TransactionState {
  final Wallet? wallet;
  final List<TransactionModel> transactions;

  TransactionState({
     this.wallet,
    required this.transactions,
  });

  TransactionState copyWith({
    Wallet? wallet,
    List<TransactionModel>? transactions,
  }) {
    return TransactionState(
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
    );
  }
}

