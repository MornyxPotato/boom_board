import 'package:boom_board/features/simple_mode/presentation/controllers/simple_mode_controller.dart';
import 'package:get/get.dart';

class SimpleModeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SimpleModeController>(SimpleModeController());
  }
}
