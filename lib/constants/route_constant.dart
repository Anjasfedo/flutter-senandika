import 'package:get/get.dart';
import 'package:senandika/presentations/bindings/login_binding.dart';
import 'package:senandika/presentations/pages/auth/login_page.dart';
import 'package:senandika/presentations/pages/auth/sign_up_page.dart';
import 'package:senandika/presentations/pages/protected/chat_page.dart';
import 'package:senandika/presentations/pages/protected/chat_session_page.dart';
import 'package:senandika/presentations/pages/protected/home_page.dart';
import 'package:senandika/presentations/pages/protected/journal_mood_log_page.dart';
import 'package:senandika/presentations/pages/protected/journal_page.dart';
import 'package:senandika/presentations/pages/protected/meditation_page.dart';
import 'package:senandika/presentations/pages/protected/profile_edit_change_password_page.dart';
import 'package:senandika/presentations/pages/protected/profile_edit_page.dart';
import 'package:senandika/presentations/pages/protected/profile_emergency_contact_page.dart';
import 'package:senandika/presentations/pages/protected/profile_page.dart';
import 'package:senandika/presentations/pages/protected/profile_target_habit_form_page.dart';
import 'package:senandika/presentations/pages/protected/profile_target_habit_page.dart';
import 'package:senandika/presentations/pages/public/onboarding_page.dart';
import 'package:senandika/presentations/pages/public/splash_screen_page.dart';

class RouteConstants {
  static const String splash_screen = '/splash_screen';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String sign_up = '/sign_up';

  static const String home = '/home';
  static const String journal = '/journal';
  static const String journal_mood_log = '/journal_mood_log';
  static const String meditation = '/meditation';
  static const String chat = '/chat';
  static const String chat_session = '/chat/session';
  static const String profile = '/profile';
  static const String profile_edit = '/profile/edit';
  static const String profile_edit_change_password =
      '/profile/edit/change_password';
  static const String profile_emergency_contact = '/profile/emergency_contact';
  static const String profile_target_habit = '/profile/target_habit';
  static const String profile_target_habit_form = '/profile/target_habit/form';
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
    GetPage(
      name: RouteConstants.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(name: RouteConstants.sign_up, page: () => const SignUpPage()),
    GetPage(name: RouteConstants.journal, page: () => const JournalPage()),
    GetPage(
      name: RouteConstants.journal_mood_log,
      page: () => const JournalMoodLogPage(),
    ),
    GetPage(
      name: RouteConstants.meditation,
      page: () => const MeditationPage(),
    ),
    GetPage(name: RouteConstants.chat, page: () => const ChatPage()),
    GetPage(
      name: RouteConstants.chat_session,
      page: () => const ChatSessionPage(),
    ),
    GetPage(name: RouteConstants.profile, page: () => const ProfilePage()),
    GetPage(
      name: RouteConstants.profile_edit,
      page: () => const ProfileEditPage(),
    ),
    GetPage(
      name: RouteConstants.profile_edit_change_password,
      page: () => const ProfileEditChangePasswordPage(),
    ),
    GetPage(
      name: RouteConstants.profile_emergency_contact,
      page: () => const ProfileEmergencyContactPage(),
    ),
    GetPage(
      name: RouteConstants.profile_target_habit,
      page: () => const ProfileTargetHabitPage(),
    ),
    GetPage(
      name: RouteConstants.profile_target_habit_form,
      page: () => const ProfileTargetHabitFormPage(),
    ),
  ];
}
