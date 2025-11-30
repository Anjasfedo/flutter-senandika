import 'package:get/get.dart';
import 'package:senandika/presentations/pages/auth/login_page.dart';
import 'package:senandika/presentations/pages/auth/sign_up_page.dart';
import 'package:senandika/presentations/pages/protected/consultate_page.dart';
import 'package:senandika/presentations/pages/protected/home_page.dart';
import 'package:senandika/presentations/pages/protected/journaling_create_page.dart';
import 'package:senandika/presentations/pages/protected/jurnaling_page.dart';
import 'package:senandika/presentations/pages/protected/profile_page.dart';
import 'package:senandika/presentations/pages/public/onboarding_page.dart';
import 'package:senandika/presentations/pages/public/splash_screen_page.dart';

class RouteConstants {
  static const String splash_screen = '/splash_screen';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String sign_up = '/sign_up';
  static const String profile = '/profile';
  static const String jurnaling = '/jurnaling';
  static const String jurnaling_create = '/jurnaling/create';
  static const String consultate = '/consultate';
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
    GetPage(name: RouteConstants.profile, page: () => const ProfilePage()),
    GetPage(name: RouteConstants.jurnaling, page: () => const JournalingPage()),
    GetPage(
      name: RouteConstants.jurnaling_create,
      page: () => const JournalingCreatePage(),
    ),
    GetPage(
      name: RouteConstants.consultate,
      page: () => const ConsultatePage(),
    ),
  ];
}
