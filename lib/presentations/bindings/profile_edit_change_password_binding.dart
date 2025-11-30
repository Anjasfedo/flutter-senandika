import 'package:get/get.dart';
import 'package:senandika/data/repositories/user_repository.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/presentations/controllers/profile_edit_change_password_controller.dart';

class ProfileEditChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileEditChangePasswordController>(
      () => ProfileEditChangePasswordController(
        Get.find<IUserRepository>(),
        Get.find<IAuthRepository>(),
      ),
    );
  }
}
