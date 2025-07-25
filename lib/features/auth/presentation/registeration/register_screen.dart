import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remi_kacha/features/auth/presentation/registeration/profile_screen.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation_service.dart';
import '../../../../ui/widgets/forms/text_input.dart';
import '../../../../ui/widgets/logo_lable.dart';
import '../../../../ui/widgets/rounded_button.dart';
import '../../provider/login/auth_provider.dart';
import '../../provider/password_provider.dart';
import '../../provider/registeration/registeration_provider.dart';
import '../login/login_screen.dart';

class RegisterScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
   RegisterScreen({super.key});

  void _submit(WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(registrationProvider.notifier)
          .registerUser(phoneNumber: _phoneController.text.trim(), password:_passwordController.text);
    }
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registrationProvider);
    final isValid = ref.watch(allRulesPassedProvider);
    final theme=Theme.of(context);

    ref.listen(registrationProvider, (previous, next) {
      if (previous?.success != true && next.success == true) {
        if(next.userId!=null){
          NavigationService.pushReplacement(ProfileScreen(userId: next.userId!,));
        }
      }
    });

    return   LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final padding = isWide ? 64.0 : 24.0;
        return PopScope(
          canPop: !registrationState.loading,
          onPopInvokedWithResult: (didPop, result) {
            ref.read(authProvider.notifier).cancelRequest();
          },
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: IgnorePointer(
                    ignoring: registrationState.loading,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 0,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LogoLabel(size: 44, align: TextAlign.center),
                            Text("Create An Account and Explore Unlimited Possibilities",style:theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                            SizedBox(height: 24),
                            RoundedTextFormField(
                              controller: _phoneController,
                              textInputType: TextInputType.phone,
                              prefixIcon: Icon(Icons.phone),
                              hintText: "09165621**",
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Enter phone number';
                                  } else if (!RegExp(r'^(09|07)\d{8}$').hasMatch(v)) {
                                    return 'Invalid Ethiopian phone number';
                                  }
                                  return null;
                                }
                            ),
                            SizedBox(height: 10),
                            RoundedTextFormField(
                              controller: _passwordController,
                              enableObscureTextToggle: true,
                              prefixIcon: Icon(Icons.password),
                              hintText: "Enter your password",
                              onChanged: (val) => ref.read(passwordProvider.notifier).state = val,
                            ),
                            SizedBox(height: 10),
                            if (registrationState.error != null) ...[
                              Text(
                                registrationState.error!,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              SizedBox(height: 12),
                            ],
                            // Criteria List
                            _buildCriteria(
                              ref,
                              "Minimum 8 characters",
                              hasMinLengthProvider,
                            ),
                            _buildCriteria(
                              ref,
                              "At least 1 uppercase letter",
                              hasUppercaseProvider,
                            ),
                            _buildCriteria(
                              ref,
                              "At least 1 lowercase letter",
                              hasLowercaseProvider,
                            ),
                            _buildCriteria(
                              ref,
                              "At least 1 number",
                              hasDigitProvider,
                            ),
                            _buildCriteria(
                              ref,
                              "At least 1 special character",
                              hasSpecialCharProvider,
                            ),
                            SizedBox(height: 24),
                            RoundedButton(
                              onPressed:isValid ? () {_submit(ref);}:null,
                              label: "Register",
                              submitting: registrationState.loading,
                              padding: 18,
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: () => {
                                NavigationService.push(LoginScreen())
                              },
                                child: Text.rich(
                                    TextSpan(
                                        text: "Already have an account?",
                                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300,color: Colors.black),
                                        children: [
                                          TextSpan(text: " Login",style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400,color:AppColors.primary))
                                        ]
                                    )
                                )
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

  Widget _buildCriteria(WidgetRef ref, String text, ProviderBase<bool> provider) {
    final passed = ref.watch(provider);
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: passed ? Colors.green : Colors.grey,
          size: 15,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: passed ? Colors.green : Colors.grey,fontSize: 12),
        ),
      ],
    );
  }

}
