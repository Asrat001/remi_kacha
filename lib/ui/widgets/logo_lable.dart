import 'package:flutter/material.dart';
import 'package:remi_kacha/core/theme/app_theme.dart';

class LogoLabel extends StatelessWidget {
  final double size;
  final TextAlign align;
  const LogoLabel({super.key, this.size = 32,this.align=TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: align,
      TextSpan(
        text: "Remi",
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(fontSize: size),
        children: [
          TextSpan(
            text: "Kacha",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.primary,
              fontSize: size,
            ),
          ),
        ],
      ),
    );
  }
}
