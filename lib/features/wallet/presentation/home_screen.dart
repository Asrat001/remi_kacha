
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/core/utils/navigation_service.dart';
import 'package:remi_kacha/core/utils/number_utils.dart';
import 'package:remi_kacha/features/auth/provider/login/auth_provider.dart';
import 'package:remi_kacha/features/send_money/provider/transaction_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../ui/widgets/cards/build_transaction_item.dart';
import '../../exchnage/presentation/exchange_screen.dart';
import '../../send_money/presentation/send_money.dart';
import '../../send_money/provider/transaction_submit_provider.dart';
import '../balance_lock_provider.dart';
import '../data/models/wallet_model.dart';


class HomeScreen extends ConsumerWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final authState = ref.read(authProvider);
    final user=authState.user;
    final transactionState=ref.watch(transactionProvider(user!));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(transactionProvider(user).notifier).refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 15),
                    _buildHeader(user.name),
                    const SizedBox(height: 15),
                     _buildBalanceCard(transactionState,ref),
                    const SizedBox(height: 20),
                    _buildIncomeOutcomeCard()
                  ],
                ),
              ),
            ),
            _buildSectionHeader("Transactions", "See All", () {}),
            _buildTransactionsList(transactionState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning!",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Image.asset("assets/icons/Bell_pin.png"),
      ],
    );
  }

  Widget _buildBalanceCard(AsyncValue<TransactionState> txState,WidgetRef ref) {
    final isVisible = ref.watch(balanceLockProvider);
    final lockNotifier = ref.read(balanceLockProvider.notifier);

    return Container(
      width: double.maxFinite,
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -30,
            bottom: -60,
            child: Container(
              width: 91,
              height: 91,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -1,
            right: -1,
            child: Image.asset("assets/icons/Shape.png"),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balance!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                   txState.when(data: (data){
                     final wallet=data.wallet;
                     if(wallet==null){
                       return Text("Refresh to see balance");
                     }
                    return Row(
                       children: [
                         Expanded(
                           child: Text(
                             isVisible
                                 ? "${NumberUtils.formatCompact(wallet.balance)} ${wallet.currency}"
                                 : "*********",
                             style: TextStyle(
                               fontSize: 24,
                               fontWeight: FontWeight.w300,
                               color: Colors.white,
                             ),
                           ),
                         ),
                         IconButton(
                           icon: Icon(
                             isVisible ? Icons.visibility_off : Icons.visibility,
                             color: Colors.white70,
                           ),
                           onPressed: lockNotifier.toggle,
                         ),
                       ],
                     );
                   },
                    error: (error,stackTrace){
                     return Text("error loading balance");
                    },
                       loading: (){
                     return CircularProgressIndicator();
                       }
                   )
                  ],
                ),
                InkWell(
                  overlayColor:
                  const WidgetStatePropertyAll(Colors.transparent),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const WalletPage(),
                    //   ),
                    // );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Wallets",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 38,
                        icon: const Icon(
                          Icons.arrow_circle_right,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeOutcomeCard() {
    return Container(
      width: double.maxFinite,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -10,
            top: -10,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Color(0XFFBFA2CA),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIncomeOutcomeDetail(
                   title:  "Send Money", icon: Icon(Icons.send,color: Colors.white),onTap: (){
                     NavigationService.push(SendMoneyScreen());
                }),
                Container(width: 1, color: const Color(0XFFCFCFCF)),
                _buildIncomeOutcomeDetail(
                  title:   "Exchange Rates", icon: Icon(Icons.currency_exchange,color: Colors.white,),onTap: (){
                 NavigationService.push(ExchangeScreen());
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
  //
  Widget _buildIncomeOutcomeDetail(
  {required String title, required Icon icon,required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, String actionText, Function()? onTap) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            InkWell(
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              onTap: onTap,
              child: Text(
                actionText,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTransactionsList(AsyncValue<TransactionState> txState) {

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 300,
          child: txState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (transactionState) {
              final transactions=transactionState.transactions;
              if (transactions.isEmpty) {
                return const Center(child: Text("No Transactions"));
              }
              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (_, index) {
                  final transaction = transactions[index];
                  return BuildTransactionItem(
                    name: transaction.recipient,
                    price: transaction.amount.toStringAsFixed(2),
                    description:
                    "${transaction.bank ?? ''} / ID ${transaction.id ?? ''}",
                    bgColor: Colors.orange,
                    nameImage: 'desktop',
                    time: transaction.timestamp,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

}