import 'package:flutter/material.dart';

class RetroButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const RetroButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFFC5CAE9),
  });

  @override
  State<RetroButton> createState() => _RetroButtonState();
}

class _RetroButtonState extends State<RetroButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Lighten the color slightly when hovered
    final Color currentColor = _isHovered ? Color.lerp(widget.color, Colors.white, 0.5)! : widget.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        // Transform translates the button down and right when pressed
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          transform: Matrix4.translationValues(
            _isPressed ? 4.0 : 0.0,
            _isPressed ? 4.0 : 0.0,
            0.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: currentColor,
            border: Border.all(color: Colors.black, width: 4),
            // The shadow disappears when pressed to create the illusion of depth
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: _isPressed ? const Offset(0, 0) : const Offset(4, 4),
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
