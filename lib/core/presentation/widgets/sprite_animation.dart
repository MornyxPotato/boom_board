import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpriteAnimation extends StatefulWidget {
  final String imagePath;
  final int frameCount;
  final double width;
  final double height;

  final Duration duration;
  final bool randomizeStartTime;

  const SpriteAnimation({
    super.key,
    required this.imagePath,
    required this.frameCount,
    required this.width,
    required this.height,
    this.duration = const Duration(milliseconds: 600),
    this.randomizeStartTime = true,
  });

  @override
  State<SpriteAnimation> createState() => _SpriteAnimationState();
}

class _SpriteAnimationState extends State<SpriteAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.randomizeStartTime) {
      _controller.value = math.Random().nextDouble();
    }

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate the current frame (e.g., 0 through 9)
        final currentFrame = (_controller.value * widget.frameCount).floor().clamp(0, widget.frameCount - 1);

        // The Math Magic: Calculate the total width of the stretched image
        // If your tile is 60px wide and you have 10 frames, the image MUST be drawn at 600px wide!
        final totalImageWidth = widget.width * widget.frameCount;

        // Create a strict window that acts as our camera
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: ClipRect(
            // Cuts off anything outside the 60x60 window
            child: Stack(
              children: [
                Positioned(
                  // Slide the giant image to the left based on the current frame
                  left: -(currentFrame * widget.width),
                  top: 0,
                  width: totalImageWidth,
                  height: widget.height,
                  child: Image.asset(
                    widget.imagePath,
                    // BoxFit.fill forces the 16x16 image to stretch exactly to our calculated dimensions
                    fit: BoxFit.fill,
                    gaplessPlayback: true,
                    // Keeps your pixel art perfectly crisp at any size!
                    filterQuality: FilterQuality.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
