import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/presentations/controllers/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(
      () => SignUpController(Get.find<IAuthRepository>()),
    );
  }
}
