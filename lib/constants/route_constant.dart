import 'package:get/get.dart';
import 'package:senandika/presentations/pages/auth/login_page.dart';
import 'package:senandika/presentations/pages/auth/sign_up_page.dart';
import 'package:senandika/presentations/pages/protected/chat_page.dart';
import 'package:senandika/presentations/pages/protected/chat_session_page.dart';
import 'package:senandika/presentations/pages/protected/home_page.dart';
import 'package:senandika/presentations/pages/protected/journal_page.dart';
import 'package:senandika/presentations/pages/protected/meditation_page.dart';
import 'package:senandika/presentations/pages/protected/profile_page.dart';
import 'package:senandika/presentations/pages/public/onboarding_page.dart';
import 'package:senandika/presentations/pages/public/splash_screen_page.dart';

class RouteConstants {
  static const String splash_screen = '/splash_screen';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String sign_up = '/sign_up';

  static const String home = '/home';
  static const String journal = '/journal';
  static const String meditation = '/meditation';
  static const String chat = '/chat';
  static const String chat_session = '/chat/session';

  // old code
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
    GetPage(name: RouteConstants.journal, page: () => const JournalPage()),
    GetPage(
      name: RouteConstants.meditation,
      page: () => const MeditationPage(),
    ),
    GetPage(name: RouteConstants.chat, page: () => const ChatPage()),
    GetPage(
      name: RouteConstants.chat_session,
      page: () => const ChatSessionPage(),
    ),

    // old
  ];
}
