import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/send_money/provider/transaction_notifier.dart';
import 'package:remi_kacha/features/send_money/provider/transaction_state.dart';
import '../../../common/repos/transaction_repository.dart';
import '../../auth/data/models/user_model.dart';

// Provide the repository
final transactionRepository = Provider<TransactionRepository>(
  (ref) => TransactionRepository(),
);

// Define the provider with family modifier

final transactionProvider = AsyncNotifierProvider.family<TransactionNotifier, TransactionState, UserModel>(
      () => TransactionNotifier(),
);
