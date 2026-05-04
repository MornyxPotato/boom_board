import 'package:boom_board/core/presentation/widgets/app_text_button.dart';
import 'package:boom_board/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinPanel extends StatelessWidget {
  final TextEditingController playerNameTextCtl;
  final TextEditingController roomCodeTextCtl;
  final Function() onCancelPressed;
  final Function() onJoinConfirmPressed;

  const JoinPanel({
    super.key,
    required this.playerNameTextCtl,
    required this.roomCodeTextCtl,
    required this.onCancelPressed,
    required this.onJoinConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Join',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textOrIconColor,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: Get.width * 0.25,
          child: TextField(
            controller: playerNameTextCtl,
            decoration: InputDecoration(
              labelText: 'Player name',
              labelStyle: TextStyle(color: primaryTextColor),
              constraints: BoxConstraints(),
              fillColor: lightPrimaryColor,
              filled: true,
              border: InputBorder.none,
            ),
            maxLength: 20,
            style: TextStyle(
              color: primaryTextColor,
            ),
          ),
        ),
        SizedBox(
          width: Get.width * 0.25,
          child: TextField(
            controller: roomCodeTextCtl,
            decoration: InputDecoration(
              labelText: 'Room Code',
              labelStyle: TextStyle(color: primaryTextColor),
              constraints: BoxConstraints(),
              fillColor: lightPrimaryColor,
              filled: true,
              border: InputBorder.none,
            ),
            maxLength: 4,
            style: TextStyle(
              color: primaryTextColor,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextButton(
              buttonText: 'Cancel',
              onPressed: onCancelPressed,
            ),
            const SizedBox(width: 16),
            AppTextButton(
              buttonText: 'Join',
              onPressed: onJoinConfirmPressed,
            ),
          ],
        ),
      ],
    );
  }
}
