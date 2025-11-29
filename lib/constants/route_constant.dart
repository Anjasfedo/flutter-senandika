import 'package:get/get.dart';
import 'package:pulih/presentations/public/home_page.dart';
import 'package:pulih/presentations/public/splash_screen_page.dart';

class RouteConstants {
  static const String splash_screen = '/splash_screen';
  static const String home = '/home';
}

class AppPages {
  static final pages = [
    GetPage(
      name: RouteConstants.splash_screen,
      page: () => const SplashScreenPage(),
    ),
    GetPage(name: RouteConstants.home, page: () => const HomePage()),
  ];
}
