import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/widgets/loader.dart';
import 'package:flutter/material.dart';

/* 
 todo: prefix button is unfinished (don't use it rn, finish it and remove this)
*/
class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onLongPressed;
  final bool isLoading;
  final String buttonText;
  final bool isDisabled;
  final Widget? prefixIcon;
  final ButtonStyle? style;
  final BoxDecoration? containerStyle;
  final EdgeInsetsGeometry? containerPadding;
  final double? containerHeight;
  final double? containerWidth;
  const CustomButton({
    super.key,
    required this.isLoading,
    required this.buttonText,
    this.prefixIcon,
    this.style,
    this.containerStyle,
    this.containerPadding,
    this.containerHeight,
    this.containerWidth,
    this.isDisabled = false,
    this.onPressed,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ?? Theme.of(context).elevatedButtonTheme.style;
    final defaultBackgroundColor =
        buttonStyle?.backgroundColor?.resolve({}) ?? ColorsConfig.color2;

    // TODO: REFACTOR!!!
    Widget buttonWidget = ElevatedButton(
      onLongPress: prefixIcon == null
          ? (isDisabled || isLoading ? null : onLongPressed)
          : null,
      onPressed: prefixIcon == null
          ? (isDisabled || isLoading ? null : onPressed)
          : null,
      style: buttonStyle?.copyWith(
        shadowColor: WidgetStateProperty.resolveWith<Color>(
            (states) => Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (isDisabled) {
              return defaultBackgroundColor.withValues(alpha: 0.4);
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

    if (prefixIcon == null) {
      return buttonWidget;
    }
    // TODO: REFACTOR!!!
    List<Widget> children = [prefixIcon!, buttonWidget];
    return GestureDetector(
      onLongPress: prefixIcon == null
          ? (isDisabled || isLoading ? null : onLongPressed)
          : null,
      onTap: isDisabled || isLoading ? null : onPressed,
      child: Container(
        height: containerHeight ?? 30,
        width: containerWidth ?? 162,
        padding: containerPadding,
        decoration: containerStyle?.copyWith(
              color: isDisabled
                  ? (containerStyle?.color?.withValues(alpha: 0.6) ??
                      defaultBackgroundColor)
                  : defaultBackgroundColor,
            ) ??
            BoxDecoration(
              color: isDisabled
                  ? defaultBackgroundColor.withValues(alpha: 0.6)
                  : defaultBackgroundColor,
            ),
        child: Row(children: children),
      ),
    );
  }
}
