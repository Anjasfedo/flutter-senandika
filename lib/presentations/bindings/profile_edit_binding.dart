// lib/presentations/bindings/profile_edit_binding.dart

import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/user_repository.dart';
import 'package:senandika/data/sources/pocketbase.dart';
import 'package:senandika/presentations/controllers/profile_edit_controller.dart';

class ProfileEditBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Daftarkan UserRepository (Jika belum)
    Get.lazyPut<IUserRepository>(
      () => UserRepository(
        Get.find<PocketBaseService>(),
        Get.find<IAuthRepository>(),
      ),
    );

    // 2. Daftarkan Controller
    Get.lazyPut<ProfileEditController>(
      () => ProfileEditController(
        Get.find<IUserRepository>(),
        Get.find<IAuthRepository>(),
      ),
    );
  }
}
