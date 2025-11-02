// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather/main.dart';
import 'package:weather/app/data/local/my_shared_pref.dart';

void main() {
  testWidgets('App builds (smoke test)', (WidgetTester tester) async {
    // Initialize in-memory shared_preferences for tests and app storage.
    SharedPreferences.setMockInitialValues({});
    await MySharedPref.init();

    // Build our app inside a ScreenUtilInit wrapper so ScreenUtil is available.
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, child) => child!,
        child: const MyApp(),
      ),
    );

    // Verify the app widget exists (basic smoke test).
    expect(find.byType(MyApp), findsOneWidget);
  });
}
