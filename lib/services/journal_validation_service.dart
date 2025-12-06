import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/journal_repository.dart';
import 'package:senandika/data/models/mood_log_model.dart';

/// Service to handle journal mood log validation across the app
class JournalValidationService extends GetxService {
  final IAuthRepository _authRepository = Get.find<IAuthRepository>();
  final IJournalRepository _journalRepository = Get.find<IJournalRepository>();

  /// Check if user already has a mood log for today and redirect if needed
  /// Returns true if user should proceed to mood log creation page
  /// Returns false if user should be redirected elsewhere
  Future<bool> validateAndRedirectToMoodLog() async {
    // 1. Check authentication
    if (!_authRepository.isAuthenticated) {
      Get.offAllNamed(RouteConstants.login);
      return false;
    }

    final currentUser = _authRepository.currentUser;
    if (currentUser == null || !currentUser.verified) {
      Get.offAllNamed(RouteConstants.login);
      return false;
    }

    // 2. Check if user already has mood log for today
    try {
      final hasTodayLog = await _journalRepository.hasTodayMoodLog(currentUser.id);

      if (hasTodayLog) {
        // Get today's log and redirect to show page
        final todayLog = await _journalRepository.getMoodLogByDate(
          DateTime.now(),
          currentUser.id
        );

        if (todayLog != null) {
          Get.snackbar(
            'Info',
            'Anda sudah mencatat mood hari ini. Mengalihkan ke detail jurnal...',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
          );

          Get.offNamed(
            RouteConstants.journal_mood_log_show,
            arguments: todayLog.id,
          );
          return false;
        }
      }

      // User can proceed to create mood log
      return true;
    } catch (e) {
      print('Error validating journal mood log: $e');
      // On error, allow access (fail-safe)
      return true;
    }
  }

  /// Get today's mood log if exists
  Future<MoodLogModel?> getTodayMoodLog() async {
    final currentUser = _authRepository.currentUser;
    if (currentUser == null) return null;

    try {
      return await _journalRepository.getMoodLogByDate(DateTime.now(), currentUser.id);
    } catch (e) {
      print('Error getting today mood log: $e');
      return null;
    }
  }

  /// Check if user has mood log for today
  Future<bool> hasTodayMoodLog() async {
    final currentUser = _authRepository.currentUser;
    if (currentUser == null) return false;

    try {
      return await _journalRepository.hasTodayMoodLog(currentUser.id);
    } catch (e) {
      print('Error checking today mood log: $e');
      return false;
    }
  }
}