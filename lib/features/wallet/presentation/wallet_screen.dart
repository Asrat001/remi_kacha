import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/provider/login/auth_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return  Scaffold(
      body: Center(child: Text("Wallet Scrren ${authState.user?.phoneNumber}  ${authState.user?.name}  ${authState.user?.pin}"),),
    );
  }
}
