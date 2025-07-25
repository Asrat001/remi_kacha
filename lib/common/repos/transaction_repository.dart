import '../../core/utils/database_service.dart';
import '../../features/exchnage/data/repo/exchange_repository.dart';
import '../../features/wallet/data/models/wallet_model.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final dbHelper = DatabaseService.instance;
  final ExchangeRepository exchangeRepository = ExchangeRepository();





  Future<void> sendMoney({
    required int senderUserId,
    required String recipient,
    required String recipientPhone,
    String? bank,
    required String accountNo,
    required double amount,
    required String currency,
    required String walletCurrency
  }) async {
    final db = await dbHelper.database;
    // 1. Fetch sender's wallet
    final senderWallet = await getWalletByUserId(senderUserId,walletCurrency);

    if (senderWallet==null) {
      throw Exception("Sender wallet not found");
    }
    //2 covert amount to wallet currency
    final convertedAmount = await exchangeRepository.convertCurrency(fromCurrency: walletCurrency, toCurrency: currency, amount: amount);

    if(convertedAmount==null){
      throw Exception("Transaction Rate Not Found");
    }

    final currentBalance = senderWallet.balance;

    if (currentBalance < convertedAmount) {
      throw Exception("Insufficient balance");
    }

    await db.transaction((txn) async {

      // 2. Deduct balance from wallet
      await txn.update(
        'wallets',
        {'balance': currentBalance - amount},
        where: 'user_id = ? AND currency = ?',
        whereArgs: [senderUserId, walletCurrency],
      );

      // 3. Insert transaction record
      final transaction = TransactionModel(
        senderId: senderUserId,
        recipient: recipient,
        bank: bank,
        accountNo: accountNo,
        amount: amount,
        currency: currency,
        timestamp: DateTime.now().toIso8601String(),
      );

      await txn.insert('transactions', transaction.toMap());
    });
  }



  Future<List<TransactionModel>> getTransactionsForUser(int userId) async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'transactions',
      where: 'sender_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return result.map((row) => TransactionModel(
      id: row['id'] as int,
      senderId: row['sender_id'] as int,
      recipient: row['recipient'] as String,
      bank: row['bank'] as String?,
      accountNo: row['account_no'] as String?,
      amount: row['amount'] as double,
      currency: row['currency'] as String,
      timestamp: row['timestamp'] as String,
    )).toList();
  }


  // Get wallet by user_id
  Future<Wallet?> getWalletByUserId(int userId,String currency) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'wallets',
      where: 'user_id = ? AND currency = ?',
      whereArgs: [userId, currency],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Wallet.fromMap(result.first);
    } else {
      return null;
    }
  }




}


