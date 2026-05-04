import 'package:boom_board/core/presentation/widgets/retro_button.dart';
import 'package:boom_board/core/presentation/widgets/retro_text_field.dart';
import 'package:flutter/material.dart';

class HostPanel extends StatelessWidget {
  final TextEditingController textEditingCtl;
  final Function() onCancelPressed;
  final Function() onCreatePressed;
  final String? errorText;

  const HostPanel({
    super.key,
    required this.textEditingCtl,
    required this.onCancelPressed,
    required this.onCreatePressed,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RetroTextField(
          controller: textEditingCtl,
          hintText: 'Player Name',
          maxLength: 20,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Color(0xFFFF5555),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RetroButton(
              text: 'Back',
              color: const Color(0xFFFF5555),
              onPressed: onCancelPressed,
            ),
            const SizedBox(width: 16),
            RetroButton(
              text: 'Create',
              color: const Color(0xFF50FA7B),
              onPressed: onCreatePressed,
            ),
          ],
        ),
      ],
    );
  }
}
