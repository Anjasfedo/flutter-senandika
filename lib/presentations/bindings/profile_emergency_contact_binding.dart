import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/user_repository.dart';
import 'package:senandika/data/sources/pocketbase.dart'; // Import PocketBaseService
import 'package:senandika/presentations/controllers/profile_emergency_contact_controller.dart';

class ProfileEmergencyContactBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Pastikan IUserRepository didaftarkan (dengan dependencies)
    // Walaupun sudah ada di ProfileEditBinding, kita tambahkan di sini
    // untuk memastikan rute ini berfungsi secara independen.
    Get.lazyPut<IUserRepository>(
      () => UserRepository(
        Get.find<PocketBaseService>(),
        Get.find<IAuthRepository>(),
      )
    );

    // 2. Daftarkan Controller (yang kini dapat menemukan IUserRepository)
    Get.lazyPut<EmergencyContactController>(
      () => EmergencyContactController(
        Get.find<
          IUserRepository
        >(), // ⬅️ Sekarang ini merujuk ke pendaftaran di atas
        Get.find<IAuthRepository>(),
      ),
    );
  }
}
