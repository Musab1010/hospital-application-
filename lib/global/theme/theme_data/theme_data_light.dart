import 'package:flutter/material.dart';

import '../app_color/app_color_light.dart';

ThemeData getThemeDatalight() => ThemeData(
      primaryColor: AppColorlight.primaryColor,
      appBarTheme: const AppBarTheme(
        color: AppColorlight.appBarColor,
      ),
      iconTheme: const IconThemeData(
        color: AppColorlight.IconThemeData,
      ),
      
    );
