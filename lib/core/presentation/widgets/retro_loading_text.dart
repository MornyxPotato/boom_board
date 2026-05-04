import 'dart:async';

import 'package:flutter/material.dart';

class RetroLoadingText extends StatefulWidget {
  final String text;
  final Color color;

  const RetroLoadingText({
    super.key,
    this.text = 'LOADING',
    this.color = Colors.white,
  });

  @override
  State<RetroLoadingText> createState() => _RetroLoadingTextState();
}

class _RetroLoadingTextState extends State<RetroLoadingText> {
  int _dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update the dots every 500 milliseconds (half a second)
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4; // Cycles: 0, 1, 2, 3
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Generate a string with the correct number of dots
    String dots = '.' * _dotCount;
    // Pad the right side with invisible spaces so the text doesn't jump around
    String displayDots = dots.padRight(3, ' ');

    return Text(
      '${widget.text}$displayDots',
      style: TextStyle(
        color: widget.color,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }
}
