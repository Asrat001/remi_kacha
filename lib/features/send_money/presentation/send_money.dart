
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/auth/data/models/user_model.dart';
import 'package:remi_kacha/ui/widgets/bottomsheet/pin_input_bottom_sheet.dart';
import '../../../ui/widgets/forms/drop_down_menu.dart';
import '../../../ui/widgets/forms/text_input.dart';
import '../../../ui/widgets/rounded_button.dart';
import '../../auth/provider/login/auth_provider.dart';
import '../../exchnage/data/models/exchange_rate_model.dart';
import '../../exchnage/provider/exchange_provider.dart';
import '../provider/transaction_state.dart';
import '../provider/transaction_submit_provider.dart';


class SendMoneyScreen extends ConsumerStatefulWidget {

  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final recipientController = TextEditingController();
  final recipientPhoneController = TextEditingController();
  final bankController = TextEditingController();
  final accountNoController = TextEditingController();
  final amountController = TextEditingController();
  ExchangeRate? _selectedCurrency;

  @override
  void dispose() {
    recipientController.dispose();
    recipientPhoneController.dispose();
    bankController.dispose();
    accountNoController.dispose();
    amountController.dispose();
    super.dispose();
  }


  void _submit(UserModel sender) {
    if (_formKey.currentState!.validate()&& _selectedCurrency != null) {
      showModalBottomSheet(
          context: context,
          builder: (_)=>PinInputBottomSheet(onPinMatched: (){
            ref.read(transactionProvider(sender).notifier).sendMoney(
                recipientName: recipientController.text,
                recipientPhone: recipientPhoneController.text,
                senderUserId: sender.id,
                bank: bankController.text,
                accountNumber: accountNoController.text,
                amount: double.parse(amountController.text),
                currency: _selectedCurrency!.currencyCode,
                walletCurrency: sender.currency
            );
            _formKey.currentState?.reset();
          }, correctPin: sender.pin,)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sate = ref.read(authProvider);
    final user=sate.user;
    final exchangeState = ref.read(exchangeNotifierProvider);
    final txtState=ref.watch(transactionProvider(user!));
    final rates=exchangeState.allRates;

// Listen to transactionProvider for side effects
    ref.listen<AsyncValue<TransactionState>>(
      transactionProvider(user),
          (previous, next) {
         if(next.isLoading){
           showDialog(
             context: context,
             barrierDismissible: false,
             builder: (_) => const Center(child: CircularProgressIndicator()),
           );
         }
        if (previous?.isLoading == true && next is AsyncData) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text("Success"),
              content: Text("Money sent successfully."),
            ),
          );
        }
        // Show error snackbar on failure
        if (next is AsyncError) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Error"),
              content: Text(next.error.toString()),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Send Money")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return PopScope(
            canPop: !txtState.isLoading,//make it conditional
            onPopInvokedWithResult: (didPop, result) {
              // ref.read(authProvider.notifier).cancelRequest();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: IgnorePointer(
                    ignoring: txtState.isLoading,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 16,
                        children: [
                          const SizedBox(height:10),
                          RoundedTextFormField(
                            controller: recipientController,
                            prefixIcon: Icon(Icons.person, color: Colors.grey.shade600),
                            hintText: "Recipient Name",
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                          RoundedTextFormField(
                            controller: recipientPhoneController,
                            prefixIcon: Icon(Icons.phone_android, color: Colors.grey.shade600),
                            hintText: "Recipient Phone",
                            textInputType: TextInputType.number,
                            validator: (v) {
                              if(v == null || v.isEmpty){
                               return 'Required';
                              }
                              else if(!RegExp(r'^(09|07)\d{8}$').hasMatch(v)){
                                return 'Invalid  phone number';
                              }
                              return null;
                            }
                          ),
                          RoundedTextFormField(
                            prefixIcon: Icon(Icons.account_balance, color: Colors.grey.shade600),
                            hintText: "Bank Name",
                            controller: bankController,
                          ),
                          RoundedTextFormField(
                            prefixIcon: Icon(Icons.numbers, color: Colors.grey.shade600),
                            hintText: "Account Number",
                            controller: accountNoController,
                            textInputType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                          RoundedTextFormField(
                            prefixIcon: Icon(Icons.money, color: Colors.grey.shade600),
                            hintText: "Amount",
                            controller: amountController,
                            textInputType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                          ExchangeRateDropdown(
                            items: rates,
                            selectedItem: _selectedCurrency,
                            onChanged: (ExchangeRate? val) {
                              setState(() => _selectedCurrency = val);
                            },
                          ),
                          const SizedBox(height: 24),
                          RoundedButton(
                            onPressed: user != null ? () => _submit(user) : null,
                            label: "Send",
                            submitting:txtState.isLoading,
                            padding: 18,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}