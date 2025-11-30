import 'package:get/get.dart';
import 'package:senandika/data/sources/pocketbase.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    // Register PocketBaseService first since other dependencies need it
    Get.lazyPut(() => PocketBaseService(), fenix: true);
  }
}
