import 'package:get/get.dart';
import 'package:senandika/presentations/bindings/chat_binding.dart';
import 'package:senandika/presentations/bindings/forget_password_binding.dart';
import 'package:senandika/presentations/bindings/home_binding.dart';
import 'package:senandika/presentations/bindings/journal_binding.dart';
import 'package:senandika/presentations/bindings/journal_mood_log_binding.dart';
import 'package:senandika/presentations/bindings/journal_mood_log_show_binding.dart';
import 'package:senandika/presentations/bindings/login_binding.dart';
import 'package:senandika/presentations/bindings/profile_binding.dart';
import 'package:senandika/presentations/bindings/profile_edit_binding.dart';
import 'package:senandika/presentations/bindings/profile_edit_change_password_binding.dart';
import 'package:senandika/presentations/bindings/profile_emergency_contact_binding.dart';
import 'package:senandika/presentations/bindings/sign_up_binding.dart';
import 'package:senandika/presentations/bindings/verify_account_binding.dart';
import 'package:senandika/presentations/pages/auth/forget_password_page.dart';
import 'package:senandika/presentations/pages/auth/login_page.dart';
import 'package:senandika/presentations/pages/auth/sign_up_page.dart';
import 'package:senandika/presentations/pages/auth/verify_account_page.dart';
import 'package:senandika/presentations/pages/protected/chat_page.dart';
import 'package:senandika/presentations/pages/protected/chat_session_page.dart';
import 'package:senandika/presentations/pages/protected/home_page.dart';
import 'package:senandika/presentations/pages/protected/journal_mood_log_page.dart';
import 'package:senandika/presentations/pages/protected/journal_mood_log_show_page.dart';
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
import 'package:senandika/routes/auth_middleware.dart';

class RouteConstants {
  // public
  static const String splash_screen = '/splash_screen';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String sign_up = '/sign_up';
  static const String forget_password = '/forget_password';
  static const String verify_account = '/verify_account';

  // protected
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

  static const String journal_mood_log_show = '/journal_mood_log/show';
}

class AppPages {
  // Daftar rute yang dilindungi (protected)
  static final protectedRoutes = [
    RouteConstants.home,
    RouteConstants.journal,
    RouteConstants.journal_mood_log,
    RouteConstants.meditation,
    RouteConstants.chat,
    RouteConstants.chat_session,
    RouteConstants.profile,
    RouteConstants.profile_edit,
    RouteConstants.profile_edit_change_password,
    RouteConstants.profile_emergency_contact,
    RouteConstants.profile_target_habit,
    RouteConstants.profile_target_habit_form,
  ];

  static final pages = [
    // Rute Publik (Tidak perlu Middleware)
    GetPage(
      name: RouteConstants.splash_screen,
      page: () => const SplashScreenPage(),
    ),
    GetPage(
      name: RouteConstants.onboarding,
      page: () => const OnboardingPage(),
    ),
    GetPage(
      name: RouteConstants.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouteConstants.sign_up,
      page: () => const SignUpPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: RouteConstants.forget_password, // ⬅️ Tambahan
      page: () => const ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      // ⬅️ Halaman Verifikasi
      name: RouteConstants.verify_account,
      page: () => const VerifyAccountPage(),
      binding: VerifyAccountBinding(),
    ),

    GetPage(
      name: RouteConstants.home,
      page: () => const HomePage(),
      middlewares: [AuthMiddleware()],
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteConstants.journal,
      page: () => const JournalPage(),
      middlewares: [AuthMiddleware()],
      binding: JournalBinding(),
    ),
    GetPage(
      name: RouteConstants.journal_mood_log,
      page: () => const JournalMoodLogPage(),
      middlewares: [AuthMiddleware()],
      binding: JournalMoodLogBinding(),
    ),
    GetPage(
      name: RouteConstants.journal_mood_log_show,
      page: () => const JournalMoodLogShowPage(),
      middlewares: [AuthMiddleware()],
      binding: JournalMoodLogShowBinding(), // 💡 BARU Binding
    ),

    GetPage(
      name: RouteConstants.meditation,
      page: () => const MeditationPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RouteConstants.chat,
      page: () => const ChatPage(),
      middlewares: [AuthMiddleware()],
      binding: ChatBinding(),
    ),
    GetPage(
      name: RouteConstants.chat_session,
      page: () => const ChatSessionPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RouteConstants.profile,
      page: () => const ProfilePage(),
      middlewares: [AuthMiddleware()],
      binding: ProfileBinding(),
    ),
    GetPage(
      name: RouteConstants.profile_edit,
      page: () => const ProfileEditPage(),
      middlewares: [AuthMiddleware()],
      binding: ProfileEditBinding(),
    ),
    GetPage(
      name: RouteConstants.profile_edit_change_password,
      page: () => const ProfileEditChangePasswordPage(),
      middlewares: [AuthMiddleware()],
      binding: ProfileEditChangePasswordBinding(),
    ),
    GetPage(
      name: RouteConstants.profile_emergency_contact,
      page: () => const ProfileEmergencyContactPage(),
      middlewares: [AuthMiddleware()],
      binding: ProfileEmergencyContactBinding(),
    ),
    GetPage(
      name: RouteConstants.profile_target_habit,
      page: () => const ProfileTargetHabitPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RouteConstants.profile_target_habit_form,
      page: () => const ProfileTargetHabitFormPage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
