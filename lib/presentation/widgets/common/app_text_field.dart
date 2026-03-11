import 'package:flutter/material.dart';

/// Styled text field matching SkyCrew design system.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffix,
    this.prefix,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
    this.autofocus = false,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? initialValue;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffix: suffix,
        prefix: prefix,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
