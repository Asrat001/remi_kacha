import 'package:flutter/material.dart';
import 'package:remi_kacha/features/auth/presentation/registeration/pin_screen.dart';

import '../../../../core/constant.dart';
import '../../../../core/utils/navigation_service.dart';
import '../../../../ui/widgets/forms/text_input.dart';
import '../../../../ui/widgets/rounded_button.dart';

class ProfileScreen extends StatelessWidget {
  final int userId;
  ProfileScreen({super.key, required this.userId});
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  void _next() async {
    if (_formKey.currentState?.validate() ?? false) {
      NavigationService.pushReplacement(
        PinScreen(
          email: _emailController.text,
          name: _nameController.text,
          userId: userId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final padding = isWide ? 64.0 : 24.0;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {},
          child: Scaffold(
            body: SafeArea(
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
                          "Set Up Your Personal Information",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Kyc flow",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 24),
                        RoundedTextFormField(
                          controller: _nameController,
                          textInputType: TextInputType.text,
                          prefixIcon: Icon(Icons.person),
                          hintText: "Eg: Asrat Adane",
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Enter phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        RoundedTextFormField(
                          controller: _emailController,
                          prefixIcon: Icon(Icons.email),
                          hintText: "Eg: asrat@gmail",
                          validator: emailValidator,
                        ),
                        Spacer(),
                        RoundedButton(
                          onPressed: () {
                            _next();
                          },
                          label: "Next",
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
        );
      },
    );
  }
}
