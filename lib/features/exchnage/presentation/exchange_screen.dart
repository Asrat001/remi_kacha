import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/exchnage/data/models/exchange_rate_model.dart';
import '../../../core/utils/number_utils.dart';
import '../../../ui/widgets/forms/drop_down_menu.dart';
import '../../../ui/widgets/forms/text_input.dart';
import '../../../ui/widgets/rounded_button.dart';
import '../provider/exchange_provider.dart';

class ExchangeScreen extends ConsumerStatefulWidget {
  const ExchangeScreen({super.key});

  @override
  ConsumerState<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends ConsumerState<ExchangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  ExchangeRate? _fromCurrency;
  ExchangeRate? _toCurrency;

  void _onExchange() {
    if (_fromCurrency != null &&
        _toCurrency != null &&
        amountController.text.isNotEmpty) {
      ref
          .read(exchangeNotifierProvider.notifier)
          .convert(
            fromCurrency: _fromCurrency!.currencyCode,
            toCurrency: _toCurrency!.currencyCode,
            amount: double.tryParse(amountController.text) ?? 0,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final exchangeState = ref.watch(exchangeNotifierProvider);
    final rates = exchangeState.allRates;
    return PopScope(
      canPop: !exchangeState.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text("Exchange Rate")),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        RoundedTextFormField(
                          controller: amountController,
                          hintText: "Amount",
                          textInputType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        ExchangeRateDropdown(
                          items: rates,
                          label: "From",
                          selectedItem: _fromCurrency,
                          onChanged: (ExchangeRate? val) {
                            setState(() => _fromCurrency = val);
                          },
                        ),
                        const SizedBox(height: 16),
                        ExchangeRateDropdown(
                          items: rates,
                          label: "To",
                          selectedItem: _toCurrency,
                          onChanged: (value) {
                            setState(() => _toCurrency = value);
                          },
                        ),
                        const SizedBox(height: 16),
                        if (exchangeState.convertedAmount != null)
                          Text(
                            "Converted Amount: ${NumberUtils.formatCompact(exchangeState.convertedAmount!)} ${_toCurrency?.currencyCode ?? ''}",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                          ),
                        const SizedBox(height: 26),
                        RoundedButton(
                          onPressed: _onExchange,
                          label: "Exchange",
                          submitting: exchangeState.isLoading,
                          padding: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
