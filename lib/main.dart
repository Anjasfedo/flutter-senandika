import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/presentations/bindings/app_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.ralewayTextTheme()),
      getPages: AppPages.pages,
      initialBinding: AppBinding(),
      initialRoute: RouteConstants.splash_screen,
    );
  }
}
