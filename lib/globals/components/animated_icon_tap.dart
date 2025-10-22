import 'package:flutter/material.dart';

class AnimatedIconTap extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? iconColor;
  final Color splashColor;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const AnimatedIconTap({
    required this.icon,
    required this.onTap,
    this.size = 15,
    this.iconColor,
    this.splashColor = const Color(0x11000000),
    this.padding = const EdgeInsets.all(8.0),
    this.margin = const EdgeInsets.all(0),
    super.key,
  });

  @override
  State<AnimatedIconTap> createState() => _AnimatedIconTapState();
}

class _AnimatedIconTapState extends State<AnimatedIconTap> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _pressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _pressed = false);
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.size + widget.padding.vertical,
      width: widget.size + widget.padding.horizontal,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: _pressed ? widget.splashColor : Colors.transparent,
        borderRadius: BorderRadius.circular(widget.size),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Padding(
          padding: widget.padding,
          child: Center(
            heightFactor: 1,
            widthFactor: 1,
            child: Padding(
              padding: widget.margin,
              child: Icon(
                widget.icon,
                size: widget.size,
                color: widget.iconColor ?? Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
