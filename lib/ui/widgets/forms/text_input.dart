import 'package:flutter/material.dart';
import 'package:remi_kacha/core/constant.dart';
import 'package:remi_kacha/core/theme/app_theme.dart';

class RoundedTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? enabled;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextInputType textInputType;
  final int minLines;
  final int maxLines;
  final double? radius;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? errorText;
  final TextStyle? errorStyle;
  final int? maxLength;
  final String? counterText;
  final TextAlign textAlign;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enableObscureTextToggle;

  const RoundedTextFormField({
    super.key,
    this.controller,
    this.enabled,
    this.radius,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.textInputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.errorText,
    this.errorStyle,
    this.maxLength,
    this.counterText,
    this.textAlign = TextAlign.start,
    this.prefixIcon,
    this.suffixIcon,
    this.enableObscureTextToggle = false,
  });

  @override
  State<RoundedTextFormField> createState() => _RoundedTextFormFieldState();
}

class _RoundedTextFormFieldState extends State<RoundedTextFormField> {
  late bool obscuringText = widget.enableObscureTextToggle;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context);

    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.textInputType,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      style: customTheme.textTheme.bodyMedium,
      textInputAction: widget.textInputAction,

      obscureText: obscuringText,
      enableSuggestions: widget.enableObscureTextToggle ? false : true,
      autocorrect: widget.enableObscureTextToggle ? false : true,

      maxLength: widget.maxLength,
      textAlign: widget.textAlign,

      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: customTheme.textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade500,
        ),
        labelText: widget.labelText,
        labelStyle: customTheme.textTheme.bodySmall,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cBorderRadius),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 4),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 4),
          borderSide: BorderSide(color: Colors.orange.shade500, width: 0.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0,
        ),
        filled: true,
        fillColor: AppColors.surface,
        counterText: widget.counterText,
        errorText: widget.errorText,
        errorStyle: widget.errorStyle,

        prefixIcon:
            widget.prefixIcon != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 12.0),
                  child: widget.prefixIcon,
                )
                : null,
        prefixIconConstraints: const BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: 32.0,
        ),

        suffixIcon:
            widget.enableObscureTextToggle
                ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: AnimatedSwitcher(
                        duration: cFastAnimationDuration,
                        child: Icon(
                          obscuringText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          key: Key(
                            "ObscureTextIconButtonKeyValue=$obscuringText",
                          ),
                        ),
                      ),
                      splashRadius: 24.0,
                      color: customTheme.colorScheme.onSurface,
                      onPressed:
                          () => setState(() => obscuringText = !obscuringText),
                    ),
                  ),
                )
                : widget.suffixIcon != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 18.0),
                  child: widget.suffixIcon,
                )
                : null,
      ),
    );
  }
}