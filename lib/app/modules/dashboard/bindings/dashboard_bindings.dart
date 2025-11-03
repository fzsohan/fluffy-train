import 'package:get/get.dart';
import 'package:weather/app/modules/search/views/search_screen.dart';
import '../controllers/dashboard_controller.dart';

class DashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    // If you have other dependencies to bind, you can add them here
    // For example:

    Get.lazyPut<WeatherSearchScreen>(
      () => WeatherSearchScreen(),
      fenix: true,
    );
  }
}
