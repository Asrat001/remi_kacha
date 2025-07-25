
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/auth/data/models/user_model.dart';
import 'package:remi_kacha/features/send_money/provider/transaction_state.dart';
import 'package:remi_kacha/features/send_money/provider/transaction_submit_provider.dart';
import '../../../common/repos/transaction_repository.dart';

class TransactionNotifier extends FamilyAsyncNotifier<TransactionState,UserModel> {

  late final TransactionRepository repository;


  @override
  Future<TransactionState> build(UserModel user) async {
    // Initialize repository (read from provider)
    repository = ref.read(transactionRepository);
    return TransactionState(
      wallet:await  repository.getWalletByUserId(user.id, user.currency),
      transactions: await repository.getTransactionsForUser(user.id),
    );
  }

  // Method to handle money transfer
  Future<void> sendMoney({
    required String recipientName,
    required int senderUserId,
    required String recipientPhone,
    required String bank,
    required String accountNumber,
    required double amount,
    required String currency,
    required String walletCurrency
  }) async {
    state = const AsyncValue.loading(); // Set loading state
    try {
     Future.delayed(Duration(milliseconds: 800));
      final transaction = await repository.sendMoney(
        recipient: recipientName,
        recipientPhone: recipientPhone,
        senderUserId: senderUserId,
        bank: bank,
        accountNo: accountNumber,
        amount: amount,
        currency: currency,
        walletCurrency: walletCurrency
      );

      // Update state with new balance and transaction
      state = AsyncValue.data(
        TransactionState(
          wallet: await repository.getWalletByUserId(arg.id, currency),
          transactions:await repository.getTransactionsForUser(arg.id),
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}