import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final double width;
  final double height;

  const GlowingButton({
    super.key,
    required this.onPressed,
    this.text = "Glowing",
    this.width = 180,
    this.height = 50,
  });

  @override
  _GlowingButtonState createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  bool glowing = false;
  double scale = 1.0;

  void _handleTapDown() {
    setState(() {
      glowing = true;
      scale = 1.1;
    });

    // Ensure the button action runs AFTER state updates
    Future.delayed(const Duration(milliseconds: 100), () {
      if (widget.onPressed != null) {
        widget.onPressed!();
      }
    });
  }

  void _handleTapUp() {
    setState(() {
      glowing = false;
      scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      child: AnimatedContainer(
        transform: Matrix4.identity()..scale(scale),
        duration: const Duration(milliseconds: 100),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            colors: [theme.primary, theme.secondary],
          ),
          boxShadow: glowing
              ? [
                  BoxShadow(
                    color: theme.primary.withOpacity(0.6),
                    spreadRadius: 4,
                    blurRadius: 16,
                    offset: const Offset(-4, 0),
                  ),
                  BoxShadow(
                    color: theme.secondary.withOpacity(0.6),
                    spreadRadius: 4,
                    blurRadius: 16,
                    offset: const Offset(4, 0),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
