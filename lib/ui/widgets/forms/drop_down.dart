import 'package:flutter/material.dart';
import 'package:remi_kacha/core/constant.dart';
import 'package:remi_kacha/core/theme/app_theme.dart';

class RoundedDropdownFormField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final String? hintText;
  final FormFieldValidator<T>? validator;
  final void Function(T?)? onSaved;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? radius;
  final bool enabled;

  const RoundedDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.validator,
    this.onSaved,
    this.prefixIcon,
    this.suffixIcon,
    this.radius,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      onSaved: onSaved,
      enableFeedback: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: hintText,
        hintStyle: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
        labelStyle: theme.textTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        prefixIcon: prefixIcon != null
            ? Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 12.0),
          child: prefixIcon,
        )
            : null,
        prefixIconConstraints: const BoxConstraints(maxWidth: double.infinity, maxHeight: 32.0),
        suffixIcon: suffixIcon != null
            ? Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 18.0),
          child: suffixIcon,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? cBorderRadius),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? cBorderRadius),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? cBorderRadius),
          borderSide: BorderSide(color: Colors.orange.shade500, width: 0.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? cBorderRadius),
        ),
      ),
    );
  }
}
