import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:whatsappchat/common/extension/custom_theme_extension.dart';
import 'package:whatsappchat/common/utils/coloors.dart';

ThemeData darkTheme(){
  final ThemeData base=ThemeData.dark();
  return base.copyWith(
    backgroundColor: Coloors.backgroundDark,
    scaffoldBackgroundColor: Coloors.backgroundDark,
    extensions: [CustomThemeExtension.darkMode],
    appBarTheme: const AppBarTheme(
        backgroundColor: Coloors.greyBackground,
      titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Coloors.greenDark),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
        iconTheme: IconThemeData(color:Coloors.greenDark),
    ),
      tabBarTheme: const TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Coloors.greenDark,
            width: 2,
          ),
        ),
        unselectedLabelColor:  Coloors.greyDark,
        labelColor:  Coloors.greenDark,
      ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Coloors.greenDark,
        foregroundColor: Coloors.backgroundDark,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shadowColor: Colors.transparent,
      )
    ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Coloors.greyBackground,
        modalBackgroundColor: Coloors.greyBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          )
        )
      ),
    dialogBackgroundColor: Coloors.greyBackground,
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      )
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Coloors.greenDark,
      foregroundColor: Colors.white,
    ),
  );

}