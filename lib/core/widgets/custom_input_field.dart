import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isObscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final TextStyle? textStyle;
  final int? maxLength;
  final String? Function(String?)? validator;
  const CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    this.isObscureText = false,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.textStyle,
    this.maxLength,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      cursorColor: ColorsConfig.textColor2,
      controller: controller,
      maxLength: maxLength,
      cursorHeight: 17,
      cursorWidth: 1,
      style: textStyle,
      validator: validator,
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: prefixIcon,
        hintText: hintText,
      ),
    );
  }
}
