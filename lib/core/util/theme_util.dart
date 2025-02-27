import 'package:flutter/material.dart';

class ThemeUtil {
  static bool isDarkMode(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    return brightness == Brightness.dark;
  }

  static bool isAppInDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color adaptiveColor(
    BuildContext context, {
    required Color lightModeColor,
    required Color darkModeColor,
  }) {
    return isAppInDarkMode(context) ? darkModeColor : lightModeColor;
  }
}
