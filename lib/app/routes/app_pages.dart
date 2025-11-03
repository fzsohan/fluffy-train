import 'package:get/get.dart';
import 'package:weather/app/modules/dashboard/bindings/dashboard_bindings.dart';
import 'package:weather/app/modules/dashboard/views/dashboard_screen.dart';
import 'package:weather/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:weather/app/modules/search/bindings/search_binding.dart';
import '../modules/onboarding/views/onboarding_screen.dart';
import '../modules/search/views/search_screen.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const iNITIAL = Routes.splashScreen;

  static final routes = [
    GetPage(
      name: _Paths.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.dashboardScreen,
      page: () => const DashboardScreen(),
      binding: DashBoardBinding(),
    ),
    GetPage(
      name: _Paths.onBoardingScreen,
      page: () => const OnBoardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.weatherSearchScreen,
      page: () =>  WeatherSearchScreen(),
      binding: WeatherBinding(),
    )
  ];
}
