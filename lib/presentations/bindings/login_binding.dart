import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/presentations/controllers/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // AuthRepository depends on PocketBaseService, which should already be registered
    Get.lazyPut<IAuthRepository>(() => AuthRepository());

    // LoginController depends on AuthRepository
    Get.lazyPut(() => LoginController(Get.find<IAuthRepository>()));
  }
}
