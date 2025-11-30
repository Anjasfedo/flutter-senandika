import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';

class BottomNavigationController extends GetxController {
  // 1. Make the index reactive (.obs)
  var currentIndex = 0.obs;

  // 2. The function that runs when you click a tab
  void changePage(int index) {
    currentIndex.value = index; // Update the UI selection

    // 3. Define specific actions for each tab
    switch (index) {
      case 0:
        Get.toNamed(RouteConstants.home);
        break;
      case 1:
        Get.toNamed(RouteConstants.jurnaling);
        break;
      case 2:
        Get.toNamed(RouteConstants.consultate);
        break;
      case 3:
        Get.toNamed(RouteConstants.profile);
        break;
      default:
        break;
    }
  }
}
