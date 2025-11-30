import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/services/local_storage_service.dart';

class OnboardingController extends GetxController {
  final LocalStorageService _localStorageService =
      Get.find<LocalStorageService>();

  /// Complete onboarding and mark as completed
  Future<void> completeOnboarding() async {
    print('🎯 Completing onboarding...');

    try {
      await _localStorageService.setFirstLaunchCompleted();

      // FIX: Add a small delay to ensure SharedPreferences writes to disk.
      await Future.delayed(const Duration(milliseconds: 50));

      // Verify the value was saved
      print('✅ Onboarding completed successfully');
      print(
        '    - Current isFirstLaunch: ${_localStorageService.isFirstLaunch}',
      );

      // Navigate to login
      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      print('❌ Error completing onboarding: $e');
      // Fallback navigation
      Get.offAllNamed(RouteConstants.login);
    }
  }

  /// Skip onboarding
  Future<void> skipOnboarding() async {
    print('⏭️ Skipping onboarding...');
    await completeOnboarding(); // Same logic
  }

  // Debug method to check current state
  void debugState() {
    print('🔍 OnboardingController Debug:');
    print('    - isFirstLaunch: ${_localStorageService.isFirstLaunch}');
  }
}
