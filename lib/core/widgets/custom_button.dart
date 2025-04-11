import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/widgets/loader.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final bool isLoading;
  final String buttonText;
  final bool isDisabled;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.buttonText,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = Theme.of(context).elevatedButtonTheme.style;
    final defaultBackgroundColor =
        buttonStyle?.backgroundColor?.resolve({}) ?? ColorsConfig.color2;

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: buttonStyle?.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (isDisabled) {
              return defaultBackgroundColor.withValues(alpha: 0.6);
            }
            return defaultBackgroundColor;
          },
        ),
      ),
      child: isLoading
          ? Loader()
          : Text(
              buttonText,
              style: Theme.of(context).textTheme.labelMedium,
            ),
    );
  }
}
