import 'package:boom_board/core/presentation/controllers/home_controller.dart';
import 'package:boom_board/core/presentation/models/enums/home_panel_type.dart';
import 'package:boom_board/core/presentation/widgets/host_panel.dart';
import 'package:boom_board/core/presentation/widgets/join_panel.dart';
import 'package:boom_board/core/presentation/widgets/start_panel.dart';
import 'package:boom_board/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          Text(
            'Boom Board',
            style: TextStyle(
              color: lightPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          GetBuilder<HomeController>(
            id: HomeIds.connectingIndicator,
            builder: (ctl) {
              if (ctl.isConnecting) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      color: accentColor,
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          GetBuilder<HomeController>(
            id: HomeIds.connectErrorText,
            builder: (ctl) {
              if (!ctl.connectedToServer) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Not connected to Server !',
                      style: TextStyle(
                        color: errorColor,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          GetBuilder<HomeController>(
            id: HomeIds.panel,
            builder: (ctl) {
              if (ctl.panelType == HomePanelType.start) {
                return StartPanel(
                  onHostPressed: () {
                    controller.onHostPressed();
                  },
                  onJoinPressed: () {
                    controller.onJoinPressed();
                  },
                );
              } else if (ctl.panelType == HomePanelType.host) {
                return HostPanel(
                  textEditingCtl: controller.playerNameTextFieldCtl,
                  onCreatePressed: controller.onCreatePressed,
                  onCancelPressed: controller.onCancelPressed,
                );
              } else if (ctl.panelType == HomePanelType.join) {
                return JoinPanel(
                  playerNameTextCtl: controller.playerNameTextFieldCtl,
                  roomCodeTextCtl: controller.roomCodeTextFieldCtl,
                  onJoinConfirmPressed: controller.onJoinConfirmPressed,
                  onCancelPressed: controller.onCancelPressed,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
