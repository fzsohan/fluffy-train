import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather/config/dark_theme_colors.dart';
import 'package:weather/config/light_theme_colors.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../home/views/home_views.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = MySharedPref.isLightTheme();
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: TabBarView(
        controller: controller.dashboardTabController,
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          // Home Tab
          HomeViews(),
          // Search Tab
          Center(child: Text('Search Tab')),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: isLightTheme
            ? LightThemeColors.backgroundColor
            : DarkThemeColors.backgroundColor,
        elevation: 10.0,
        notchMargin: 5.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 14.5.h),
        shape: CircularNotchedRectangle(),
        child: Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => controller.changeDashboardTabbar(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/home.png',
                          fit: BoxFit.contain,
                          width: 22.w,
                          height: 22.h,
                          color: controller.currentDashboardIndex.value == 0
                              ? null
                              : (isLightTheme
                                    ? LightThemeColors.iconColor2
                                    : DarkThemeColors.iconColor2),
                        ),
                        Text(
                          'Home',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight:
                                controller.currentDashboardIndex.value == 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: controller.currentDashboardIndex.value == 0
                                ? null
                                : (isLightTheme
                                      ? LightThemeColors.iconColor2
                                      : DarkThemeColors.iconColor2),
                            height: 1.6,
                            letterSpacing: -0.16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  15.horizontalSpace,
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => controller.changeDashboardTabbar(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/search.png',
                          fit: BoxFit.contain,
                          width: 22.w,
                          height: 22.h,
                          color: controller.currentDashboardIndex.value == 3
                              ? null
                              : (isLightTheme
                                    ? LightThemeColors.iconColor2
                                    : DarkThemeColors.iconColor2),
                        ),
                        Text(
                          'Search',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight:
                                controller.currentDashboardIndex.value == 3
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: controller.currentDashboardIndex.value == 3
                                ? null
                                : (isLightTheme
                                      ? LightThemeColors.iconColor2
                                      : DarkThemeColors.iconColor2),
                            height: 1.6,
                            letterSpacing: -0.16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle floating action button press
          Get.snackbar('Action', 'Floating Action Button Pressed');
        },
        shape: const CircleBorder(),
        backgroundColor: isLightTheme
            ? LightThemeColors.primaryColor
            : DarkThemeColors.primaryColor,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
