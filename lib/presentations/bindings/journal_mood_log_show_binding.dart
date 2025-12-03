// presentations/bindings/journal_mood_log_show_binding.dart

import 'package:get/get.dart';
import 'package:senandika/presentations/controllers/journal_mood_log_show_controller.dart';

class JournalMoodLogShowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalMoodLogShowController>(
      () => JournalMoodLogShowController(
        Get.find(), // IJournalRepository
      ),
    );
  }
}
