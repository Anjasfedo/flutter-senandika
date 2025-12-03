// presentations/bindings/journal_mood_log_edit_binding.dart

import 'package:get/get.dart';
import 'package:senandika/presentations/controllers/journal_mood_log_edit_controller.dart';

class JournalMoodLogEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalMoodLogEditController>(
      () => JournalMoodLogEditController(
        Get.find(), // IJournalRepository
      ),
    );
  }
}
