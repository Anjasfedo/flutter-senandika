import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/presentations/controllers/bottom_navigation_controller.dart';

// Make sure to import your controller file here
// import 'path/to/navigation_controller.dart';

class CustomBottomNavigationBar extends GetView<BottomNavigationController> {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      // WRAP IN OBX: This ensures the UI updates when controller.currentIndex changes
      child: Obx(
        () => BottomNavigationBar(
          // Listen to the reactive value
          currentIndex: controller.currentIndex.value,

          // Connect the click action to the controller
          onTap: controller.changePage,

          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF3F4198),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined), // Journaling icon
              label: 'Journaling',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Consultate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
