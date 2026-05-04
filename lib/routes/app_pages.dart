import 'package:boom_board/core/presentation/bindings/home_binding.dart';
import 'package:boom_board/core/presentation/screens/home_screen.dart';
import 'package:boom_board/features/simple_mode/presentation/bindings/simple_mode_binding.dart';
import 'package:boom_board/features/simple_mode/presentation/screens/simple_mode_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

Transition getTransition() {
  return Transition.native;
}

List<GetPage> getRoutes() {
  return [
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: getTransition(),
    ),
    GetPage(
      name: simpleMode,
      page: () => const SimpleModeScreen(),
      binding: SimpleModeBinding(),
      transition: getTransition(),
    ),
  ];
}
