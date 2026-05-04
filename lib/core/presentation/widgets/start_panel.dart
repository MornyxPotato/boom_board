import 'package:boom_board/core/presentation/widgets/retro_button.dart';
import 'package:boom_board/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class StartPanel extends StatelessWidget {
  final Function() onHostPressed;
  final Function() onJoinPressed;

  const StartPanel({
    super.key,
    required this.onHostPressed,
    required this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RetroButton(
          text: 'Host Game',
          color: retroGreen,
          onPressed: onHostPressed,
        ),
        const SizedBox(height: 24),
        RetroButton(
          text: 'Join Game',
          color: retroCyan,
          onPressed: onJoinPressed,
        ),
      ],
    );
  }
}
