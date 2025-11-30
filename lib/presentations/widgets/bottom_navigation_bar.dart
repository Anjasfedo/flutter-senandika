import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  // Asumsi halaman Home adalah index 0, Journal 1, Meditation 2, Chat 3, Profile 4
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({
    this.selectedIndex = 0,
    required this.onItemTapped,
  });

  // Mapping index ke rute (untuk navigasi yang lebih terstruktur)
  final List<String> routes = [
    RouteConstants.home,
    RouteConstants.journal,
    RouteConstants.meditation,
    RouteConstants.chat,
    RouteConstants.profile,
  ];

  void _navigateTo(int index) {
    if (index != selectedIndex) {
      Get.toNamed(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: ColorConst.primaryAccentGreen,
      unselectedItemColor: ColorConst.secondaryTextGrey.withOpacity(0.7),
      currentIndex: selectedIndex,
      onTap: onItemTapped, // Menggunakan onTap dari parent widget
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Utama',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_note_outlined),
          label: 'Jurnal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement_outlined),
          label: 'Tenang',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Senandika',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
