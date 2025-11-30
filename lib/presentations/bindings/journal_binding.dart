import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/journal_repository.dart';
import 'package:senandika/presentations/controllers/journal_controller.dart';
import 'package:senandika/data/sources/pocketbase.dart'; // Import PocketBaseService

class JournalBinding extends Bindings {
  @override
  void dependencies() {
    // 1. ⬅️ Daftarkan IJournalRepository (HARUS DIDAHULUKAN)
    // JournalRepository membutuhkan PocketBaseService dan IAuthRepository di constructor
    Get.lazyPut<IJournalRepository>(
      () => JournalRepository(
        Get.find<PocketBaseService>(),
      ),
      fenix: true, // Gunakan fenix: true agar reusable dan dapat dibuat ulang
    );

    // 2. Daftarkan Journal Controller
    // Controller kini dapat menemukan IJournalRepository dari pendaftaran di atas.
    Get.lazyPut<JournalController>(
      () => JournalController(
        Get.find<IJournalRepository>(), // ⬅️ Resolusi berhasil
        Get.find<IAuthRepository>(),
      ),
    );
  }
}
