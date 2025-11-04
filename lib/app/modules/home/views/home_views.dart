import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather/app/modules/home/controllers/home_controller.dart';
import '../../../../config/dark_theme_colors.dart';
import '../../../../config/light_theme_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../components/flip_card.dart';
import '../../../data/local/my_shared_pref.dart';

class HomeViews extends GetView<HomeViewController> {
  const HomeViews({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = MySharedPref.isLightTheme();
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: FlipCard(
          duration: Duration(milliseconds: 700),
          flipOnTouch: true,
          autoFlip: true,
          infinityFlip: true,
          flipDelay: Duration(seconds: 5),
          builder: (context, isFront) {
            return isFront
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text('Weather Info',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            letterSpacing: -0.48.sp,
                          )),
                    ],
                  )
                : Assets.images.home.image(
                    fit: BoxFit.contain,
                    width: 90.w,
                    height: 49.h,
                  );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ///<========================= Balance Card =========================>
                    Card(
                      color: isLightTheme
                          ? LightThemeColors.cardBackgroundColor
                          : DarkThemeColors.cardBackgroundColor,
                      child: Padding(
                        padding: EdgeInsets.all(16.0.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Temperature',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontSize: 16.sp,
                                    letterSpacing: -0.48.sp,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    '${Get.find<HomeViewController>().weather.value.temperature?.toStringAsFixed(1) ?? '--'} °C',
                                    style:
                                        theme.textTheme.headlineMedium?.copyWith(
                                      fontSize: 32.sp,
                                      letterSpacing: -0.96.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Assets.images.weatherIcon.image(
                              width: 64.w,
                              height: 64.h,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
