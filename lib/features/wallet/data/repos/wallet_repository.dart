
import '../../../../core/utils/database_service.dart';
import '../models/wallet_model.dart';

class WalletRepository {
  final dbHelper = DatabaseService.instance;


  // Get wallet by user_id
  Future<Wallet?> getWalletByUserId(int userId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'wallets',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return Wallet.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Update wallet balance
  Future<int> updateBalance(int walletId, double newBalance) async {
    final db = await dbHelper.database;
    return await db.update(
      'wallets',
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [walletId],
    );
  }

  // Delete wallet
  Future<int> deleteWallet(int walletId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'wallets',
      where: 'id = ?',
      whereArgs: [walletId],
    );
  }


  Future<List<Wallet>> getAllWallets() async {
    final db = await dbHelper.database;
    final result = await db.query('wallets');
    return result.map((e) => Wallet.fromMap(e)).toList();
  }
}
