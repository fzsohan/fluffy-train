import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather/app/data/local/my_shared_pref.dart';

import '../controllers/home_controller.dart';

class HomeViews extends GetView<HomeViewController> {
  const HomeViews({super.key});

  @override
  Widget build(BuildContext context) {
    final bool is_theme_light = MySharedPref.isLightTheme();
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App ☀️'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: Column(
          children: [
            Text(
              controller.weather.cityName,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${controller.weather.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 64, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              controller.weather.description.toUpperCase(),
              style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}