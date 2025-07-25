import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = 8,
    this.submitting=false
  });

  final String label;
  final void Function()? onPressed;
  final double padding;
  final bool submitting;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: submitting?null:onPressed,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          padding: WidgetStateProperty.all(EdgeInsets.all(padding)),
        ),
        child: submitting?Center(child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator()),):Text(label),
      ),
    );
  }
}
