import 'dart:math';

import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class AnimatedLongPressButton extends StatefulWidget {
  final VoidCallback onLongPress;
  final VoidCallback? onTap;
  final String text;
  final Color backgroundColor;
  final Color animatedColor;
  final TextStyle? textStyle;
  final double height;
  final bool isLoading;

  const AnimatedLongPressButton({
    super.key,
    required this.onLongPress,
    this.onTap,
    required this.text,
    this.backgroundColor = Colors.grey,
    this.animatedColor = Colors.blue,
    this.textStyle,
    this.height = 50,
    this.isLoading = false,
  });

  @override
  State<AnimatedLongPressButton> createState() =>
      _AnimatedLongPressButtonState();
}

class _AnimatedLongPressButtonState extends State<AnimatedLongPressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _longPressTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInExpo,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_longPressTriggered) {
        _longPressTriggered = true;
        widget.onLongPress();
      }
    });
  }

  void _onLongPressStart(_) {
    _longPressTriggered = false;
    _controller.forward();
  }

  void _onLongPressEnd(_) {
    if (!_longPressTriggered) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle ??
        Theme.of(context).textTheme.labelMedium!.copyWith(
              color: ColorsConfig.textColor2,
            );

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onLongPressStart,
      onTapUp: _onLongPressEnd,
      child: SizedBox(
        height: widget.height,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              // Animated Background
              AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  return Container(
                    width: max(constraints.maxWidth * _animation.value, 0),
                    height: widget.height,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: widget.animatedColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                },
              ),

              // Static Background
              if (!widget.isLoading)
                Container(
                  width: constraints.maxWidth,
                  height: widget.height,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),

              // Loading Indicator
              if (widget.isLoading)
                Center(
                  child: // child: Text(
                      //   'Loading...',
                      //   style: textStyle.copyWith(color: Colors.white),
                      // ),
                      SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  ),
                ),

              // Text on top
              if (!widget.isLoading)
                Center(
                  child: Text(
                    widget.text,
                    style: textStyle,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
