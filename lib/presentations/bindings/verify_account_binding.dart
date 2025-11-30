import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/presentations/controllers/verify_account_controller.dart';

class VerifyAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyAccountController>(
      () => VerifyAccountController(Get.find<IAuthRepository>()),
    );
  }
}
