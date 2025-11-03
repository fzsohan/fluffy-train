import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/dark_theme_colors.dart';
import '../../config/light_theme_colors.dart';
import '../data/local/my_shared_pref.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? prefixText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final String? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;

  final String? Function(String?)? validator;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool expandes;
  final bool? enabled;
  final double? marginTop;
  final double? marginBottom;
  final double marginLeft;
  final double marginRight;
  final String? suffixText;
  final String? suffixIcon;
  final void Function()? suffixIconOnTap;
  final bool autofocus;
  final double topLeftBorderRadius;
  final double topRightBorderRadius;
  final double bottomLeftBorderRadius;
  final double bottomRightBorderRadius;
  final TextAlign textAlign;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function()? onEditingComplete;
  final void Function()? onTap;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.backgroundColor,
    this.borderColor,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.suffixText,
    this.suffixIcon,
    this.suffixIconOnTap,
    this.prefixText,
    this.inputFormatters,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
    this.expandes = false,
    this.marginTop,
    this.marginBottom,
    this.marginLeft = 0.0,
    this.marginRight = 0.0,
    this.topLeftBorderRadius = 16.0,
    this.topRightBorderRadius = 16.0,
    this.bottomLeftBorderRadius = 16.0,
    this.bottomRightBorderRadius = 16.0,
    this.errorText,
    this.textAlign = TextAlign.start,
    this.onFieldSubmitted,
    this.onSaved,
    this.onEditingComplete,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightTheme = MySharedPref.isLightTheme();
    return Container(
      margin: EdgeInsets.only(
        top: marginTop ?? 12.0.h,
        bottom: marginBottom ?? 12.0.h,
        left: marginLeft,
        right: marginRight,
      ),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isLightTheme
                ? LightThemeColors.scaffoldBackgroundColor
                : DarkThemeColors.scaffoldBackgroundColor),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeftBorderRadius),
          bottomRight: Radius.circular(bottomRightBorderRadius),
          topLeft: Radius.circular(topLeftBorderRadius),
          topRight: Radius.circular(topRightBorderRadius),
        ),
      ),
      child: TextFormField(
        autofocus: autofocus,
        key: key,
        cursorHeight: 20.h,
        cursorColor: isLightTheme
            ? LightThemeColors.primaryColor
            : DarkThemeColors.primaryColor,
        style: theme.textTheme.bodyMedium,
        onTap: onTap,
        readOnly: readOnly,

        enabled: enabled,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        expands: expandes,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          label: labelText != null
              ? Text(labelText!, style: theme.textTheme.labelMedium)
              : null,
          fillColor:
              backgroundColor ??
              (isLightTheme
                  ? LightThemeColors.scaffoldBackgroundColor
                  : DarkThemeColors.scaffoldBackgroundColor),
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: 12.w,
          ),
          // EdgeInsets.only(
          //     left: 10.0,
          //     top: maxLines! > 1 ? 25 : 30,
          //     bottom: maxLines! > 1 ? 15 : 0),
          isDense: true,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  borderColor ??
                  (isLightTheme
                      ? LightThemeColors.borderColor
                      : DarkThemeColors.borderColor),
              width: 1,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeftBorderRadius),
              bottomRight: Radius.circular(bottomRightBorderRadius),
              topLeft: Radius.circular(topLeftBorderRadius),
              topRight: Radius.circular(topRightBorderRadius),
            ),
          ),
          errorStyle: theme.textTheme.bodySmall?.copyWith(
            color: isLightTheme
                ? LightThemeColors.errorColor
                : DarkThemeColors.errorColor,
          ),
          errorMaxLines: 1,
          // error: Icon(Icons.h_mobiledata),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isLightTheme
                  ? LightThemeColors.errorColor
                  : DarkThemeColors.errorColor,
              width: 1,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeftBorderRadius),
              bottomRight: Radius.circular(bottomRightBorderRadius),
              topLeft: Radius.circular(topLeftBorderRadius),
              topRight: Radius.circular(topRightBorderRadius),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  borderColor ??
                  (isLightTheme
                      ? LightThemeColors.borderColor
                      : DarkThemeColors.borderColor),
              width: 1,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeftBorderRadius),
              bottomRight: Radius.circular(bottomRightBorderRadius),
              topLeft: Radius.circular(topLeftBorderRadius),
              topRight: Radius.circular(topRightBorderRadius),
            ),
          ),
          counterText: '',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeftBorderRadius),
              bottomRight: Radius.circular(bottomRightBorderRadius),
              topLeft: Radius.circular(topLeftBorderRadius),
              topRight: Radius.circular(topRightBorderRadius),
            ),
            borderSide: BorderSide(
              color:
                  borderColor ??
                  (isLightTheme
                      ? LightThemeColors.borderColor
                      : DarkThemeColors.borderColor),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeftBorderRadius),
              bottomRight: Radius.circular(bottomRightBorderRadius),
              topLeft: Radius.circular(topLeftBorderRadius),
              topRight: Radius.circular(topRightBorderRadius),
            ),
            borderSide: BorderSide(
              color:
                  borderColor ??
                  (isLightTheme
                      ? LightThemeColors.borderColor
                      : DarkThemeColors.borderColor),
            ),
          ),
          //  labelText: labelText,
          // labelStyle: labelStyle ?? CustomTextStyle.normalBoldStyle,
          hintText: hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: isLightTheme
                ? LightThemeColors.hintTextColor
                : DarkThemeColors.hintTextColor,
          ),

          //prefixIcon:,
          prefixIcon: prefixIcon != null
              ? Container(
                  padding: const EdgeInsets.all(12.0),
                  height: 20.h,
                  width: 20.w,
                  child: CrashSafeImage(
                    prefixIcon!,
                    color: isLightTheme
                        ? LightThemeColors.iconColor2
                        : DarkThemeColors.iconColor2,
                    fit: BoxFit.contain,
                  ),
                )
              : null,
          prefixText: prefixText,

          // prefixStyle: style,
          suffixIcon: (suffixIcon != null || suffixText != null)
              ? InkWell(
                  onTap: suffixIconOnTap,
                  child: IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: suffixText != null
                          ? Text(
                              suffixText ?? '',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isLightTheme
                                    ? LightThemeColors.primaryColor
                                    : DarkThemeColors.primaryColor,
                              ),
                            )
                          : CrashSafeImage(
                              height: 20.h,
                              width: 20.w,
                              suffixIcon!,
                              fit: BoxFit.contain,
                              color: isLightTheme
                                  ? LightThemeColors.iconColor2
                                  : DarkThemeColors.iconColor2,
                            ),
                    ),
                  ),
                )
              : null,

          errorText: errorText,
        ),
        textAlign: textAlign,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
