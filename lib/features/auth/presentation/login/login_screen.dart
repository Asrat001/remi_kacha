import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/core/theme/app_theme.dart';
import 'package:remi_kacha/core/utils/navigation_service.dart';
import 'package:remi_kacha/features/auth/provider/login/auth_provider.dart';
import 'package:remi_kacha/ui/widgets/forms/text_input.dart';
import 'package:remi_kacha/ui/widgets/logo_lable.dart';
import 'package:remi_kacha/ui/widgets/rounded_button.dart';

import '../registeration/register_screen.dart';

class LoginScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  void _submit(WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(authProvider.notifier)
          .login(_phoneController.text.trim(), _passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final padding = isWide ? 64.0 : 24.0;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            ref.read(authProvider.notifier).cancelRequest();
          },
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: IgnorePointer(
                    ignoring: authState.loading,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LogoLabel(size: 44, align: TextAlign.center),
                            Text(
                              "Login Into your  Account and Explore Unlimited Possibilities",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            RoundedTextFormField(
                              controller: _phoneController,
                              textInputType: TextInputType.phone,
                              prefixIcon: Icon(Icons.phone),
                              hintText: "Enter your phone number",
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Enter phone number';
                                } else if (!RegExp(
                                  r'^(09|07)\d{8}$',
                                ).hasMatch(v)) {
                                  return 'Invalid Ethiopian phone number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 4),
                            RoundedTextFormField(
                              controller: _passwordController,
                              enableObscureTextToggle: true,
                              hintText: "Enter your password",
                              prefixIcon: Icon(Icons.password),
                              validator:
                                  (v) =>
                                      v == null || v.length < 8
                                          ? 'Min 8 characters'
                                          : null,
                            ),
                            SizedBox(height: 16),
                            if (authState.error != null) ...[
                              Text(
                                authState.error!,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              SizedBox(height: 12),
                            ],
                            RoundedButton(
                              onPressed: () => {_submit(ref)},
                              label: "Login",
                              submitting: authState.loading,
                              padding: 18,
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed:
                                  () => {
                                    NavigationService.push(RegisterScreen()),
                                  },
                              child: Text.rich(
                                TextSpan(
                                  text: "Don\'t have an account?",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " Register",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
