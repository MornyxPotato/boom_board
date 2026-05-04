import 'package:boom_board/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressed;

  const AppTextButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightPrimaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: primaryTextColor,
          ),
        ),
      ),
    );
  }
}
