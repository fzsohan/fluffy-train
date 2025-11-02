import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/routes/app_pages.dart';
import 'config/my_theme.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("⚠️ Could not load .env file: $e");
  }
  await MySharedPref.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Weather App',
      debugShowCheckedModeBanner: false,
      theme: MyTheme.getThemeData(isLight: true),
      darkTheme: MyTheme.getThemeData(isLight: false),
      themeMode: MySharedPref.isLightTheme() ? ThemeMode.light : ThemeMode.dark,
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: widget!,
        );
      },
      initialRoute: AppPages.iNITIAL,
      getPages: AppPages.routes,
      locale: MySharedPref.getLocale(),
    );
  }

}
