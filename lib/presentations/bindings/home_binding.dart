import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/journal_repository.dart';
import 'package:senandika/presentations/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      // Menggunakan Get.find() untuk mengambil dependencies
      () => HomeController(
        Get.find<IAuthRepository>(),
        Get.find<IJournalRepository>(),
      ),
    );
  }
}
