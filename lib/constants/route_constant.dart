import 'package:get/get.dart';
import 'package:pulih/presentations/auth/login_page.dart';
import 'package:pulih/presentations/auth/sign_up_page.dart';
import 'package:pulih/presentations/public/home_page.dart';
import 'package:pulih/presentations/public/onboarding_page.dart';
import 'package:pulih/presentations/public/splash_screen_page.dart';

class RouteConstants {
  static const String splash_screen = '/splash_screen';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String sign_up = '/sign_up';
}

class AppPages {
  static final pages = [
    GetPage(
      name: RouteConstants.splash_screen,
      page: () => const SplashScreenPage(),
    ),
    GetPage(name: RouteConstants.home, page: () => const HomePage()),
    GetPage(
      name: RouteConstants.onboarding,
      page: () => const OnboardingPage(),
    ),
    GetPage(name: RouteConstants.login, page: () => const LoginPage()),
    GetPage(name: RouteConstants.sign_up, page: () => const SignUpPage()),
  ];
}
