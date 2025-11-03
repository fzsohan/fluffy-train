import 'package:get/get.dart';

import '../controllers/search_controller.dart'; // Adjust path

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherController>(() => WeatherController());
  }
}