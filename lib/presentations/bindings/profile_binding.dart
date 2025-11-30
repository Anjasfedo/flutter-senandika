import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/user_repository.dart'; // ⬅️ Import UserRepository
import 'package:senandika/data/sources/pocketbase.dart'; // ⬅️ Import PocketBaseService
import 'package:senandika/presentations/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Daftarkan UserRepository (fenix: true agar reusable)
    Get.lazyPut<IUserRepository>(
      () => UserRepository(
        Get.find<PocketBaseService>(),
        Get.find<IAuthRepository>(),
      ),
      fenix: true,
    );

    // 2. Daftarkan ProfileController (yang kini dapat menemukan IUserRepository)
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<IAuthRepository>(),
        Get.find<IUserRepository>(), // ⬅️ Resolusi berhasil
      ),
    );
  }
}
