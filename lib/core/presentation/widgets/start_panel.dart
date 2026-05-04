import 'package:boom_board/core/presentation/widgets/app_text_button.dart';
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
        AppTextButton(
          buttonText: 'Host',
          onPressed: onHostPressed,
        ),
        const SizedBox(height: 16),
        AppTextButton(
          buttonText: 'Join',
          onPressed: onJoinPressed,
        ),
      ],
    );
  }
}
