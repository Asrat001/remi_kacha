import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/auth/presentation/login/login_screen.dart';
import 'package:remi_kacha/features/auth/provider/login/auth_provider.dart';

import '../../../../core/utils/navigation_service.dart';
import '../../../../ui/widgets/forms/text_input.dart';
import '../../../../ui/widgets/rounded_button.dart';
import '../../../wallet/presentation/wallet_screen.dart';
import '../../provider/registeration/registeration_provider.dart';

class PinScreen extends ConsumerWidget {
  final String name;
  final String email;
  final int userId;
  PinScreen({
    super.key,
    required this.name,
    required this.email,
    required this.userId,
  });
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  void _submit(WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(registrationProvider.notifier)
          .updateUserData(
            name: name,
            email: email,
            pin: _pinController.text.trim(),
            userId: userId,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registrationProvider);
    final theme = Theme.of(context);

    ref.listen(registrationProvider, (previous, next) {
      if (next.success == true) {
        NavigationService.pushReplacement(LoginScreen());
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final padding = isWide ? 64.0 : 24.0;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {},
          child: Scaffold(
            body: SafeArea(
              child: IgnorePointer(
                ignoring: registrationState.loading,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 0,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Set Up Your Pin ",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Almost There !!",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 24),
                          RoundedTextFormField(
                            controller: _pinController,
                            textInputType: TextInputType.number,
                            prefixIcon: Icon(Icons.pin),
                            hintText: "Enter secure 4 digit pin",
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Enter Pin number';
                              } else if (v.length != 4) {
                                return "Please Enter 4 Digit Pin";
                              }
                              return null;
                            },
                          ),

                          Spacer(),
                          RoundedButton(
                            onPressed: () {
                              _submit(ref);
                            },
                            submitting: registrationState.loading,
                            label: "Complete",
                            padding: 18,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
