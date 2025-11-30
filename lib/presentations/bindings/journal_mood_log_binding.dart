import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/journal_repository.dart';
import 'package:senandika/presentations/controllers/journal_mood_log_controller.dart';
import 'package:senandika/data/sources/pocketbase.dart'; // Untuk PocketBaseService

class JournalMoodLogBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Pastikan IJournalRepository didaftarkan (fenix: true)
    // Jika IJournalRepository belum didaftarkan secara global, lakukan di sini:
    Get.lazyPut<IJournalRepository>(
      () => JournalRepository(
        Get.find<PocketBaseService>(),
      ),
      fenix: true,
    );

    // 2. Daftarkan JournalMoodLogController
    Get.lazyPut<JournalMoodLogController>(
      () => JournalMoodLogController(
        Get.find<IJournalRepository>(),
        Get.find<IAuthRepository>(),
      ),
    );
  }
}
