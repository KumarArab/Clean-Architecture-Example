import 'package:cleanarchexample/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class AppTheme {
  static ThemeData get dark => ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Typography.whiteCupertino),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.white12, style: BorderStyle.solid, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.redAccent, style: BorderStyle.solid, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.white12, style: BorderStyle.solid, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.white30, style: BorderStyle.solid, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.grey, style: BorderStyle.solid, width: 2),
          ),
          labelStyle: GoogleFonts.poppins()
              .copyWith(color: Colors.white54, fontSize: 14),
          hintStyle: GoogleFonts.poppins()
              .copyWith(color: Colors.white54, fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(200, 40)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)))),
            alignment: Alignment.center,
            backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
            shadowColor: WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
      );
}
