import 'package:flutter/material.dart';

import '../app_color/app_color_dark.dart';

ThemeData getThemeDataDark() => ThemeData(
  primaryColor: AppColorDark.primaryColor,
  appBarTheme: const AppBarTheme(color: AppColorDark.appBarColor),
  iconTheme: const IconThemeData(color: AppColorDark.IconThemeData),
  
  // استخدام MaterialStateProperty.all بدلاً من WidgetStatePropertyAll
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all(TextStyle(color: Colors.white)),
    ),
  ),
  
  // تخصيص المزيد من التفاصيل هنا إذا لزم الأمر
);
