// write code for a primary button widget in Flutter with elevated button style don't use any external packages like flutter_screenutil or getx, just use the basic Flutter widgets and Material design.

//Primary color will be app primary color, text color will be white, and the button is disabled then primary border color. and text color wil be red.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/dark_theme_colors.dart';
import '../../config/light_theme_colors.dart';

import '../data/local/my_shared_pref.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final EdgeInsetsGeometry? margin;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = MySharedPref.isLightTheme();
    return Container(
      margin: margin,
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        key: key,
        onPressed: disabled ? null : onPressed,

        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: (isLight
              ? LightThemeColors.buttonDisableColor
              : DarkThemeColors.buttonDisableColor),
          foregroundColor: Colors.white,
          backgroundColor: (isLight
              ? LightThemeColors.primaryColor
              : DarkThemeColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0.r),
          ),
          side: BorderSide(
            color: disabled
                ? isLight
                      ? LightThemeColors.borderColor
                      : DarkThemeColors.borderColor
                : isLight
                ? LightThemeColors.primaryColor
                : DarkThemeColors.primaryColor,
            width: 2.0,
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: disabled
                ? isLight
                      ? LightThemeColors.buttonDisableTextColor
                      : DarkThemeColors.buttonDisableTextColor
                : isLight
                ? LightThemeColors.scaffoldBackgroundColor
                : DarkThemeColors.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
