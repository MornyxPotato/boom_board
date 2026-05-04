import 'package:boom_board/core/presentation/widgets/retro_button.dart';
import 'package:boom_board/core/presentation/widgets/retro_text_field.dart';
import 'package:flutter/material.dart';

class JoinPanel extends StatelessWidget {
  final TextEditingController playerNameTextCtl;
  final TextEditingController roomCodeTextCtl;
  final Function() onCancelPressed;
  final Function() onJoinConfirmPressed;
  final String? errorText;

  const JoinPanel({
    super.key,
    required this.playerNameTextCtl,
    required this.roomCodeTextCtl,
    required this.onCancelPressed,
    required this.onJoinConfirmPressed,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RetroTextField(
          controller: playerNameTextCtl,
          hintText: 'Player Name',
          maxLength: 20,
        ),
        RetroTextField(
          controller: roomCodeTextCtl,
          hintText: 'Room Code',
          maxLength: 4,
          isRoomCode: true,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              errorText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFF5555),
                fontSize: 20,
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
              text: 'Join',
              color: const Color(0xFF8BE9FD),
              onPressed: onJoinConfirmPressed,
            ),
          ],
        ),
      ],
    );
  }
}
