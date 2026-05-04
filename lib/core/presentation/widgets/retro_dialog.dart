import 'package:boom_board/core/presentation/widgets/retro_button.dart';
import 'package:flutter/material.dart';

class RetroDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const RetroDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF282A36),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFF5555),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RetroButton(
                  text: 'NO',
                  color: const Color(0xFFC5CAE9),
                  onPressed: onCancel,
                ),
                RetroButton(
                  text: 'YES',
                  color: const Color(0xFFFF5555),
                  onPressed: onConfirm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
