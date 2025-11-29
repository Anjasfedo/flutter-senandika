import 'package:flutter/material.dart';
import 'package:pulih/presentations/widgets/bottom_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color for the bottom part before the container loads
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Purple Background Header
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6A5ACD), // Medium purple
                  Color(0xFF1565C0), // Indigo
                ],
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Info (Avatar & Text)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      // Profile Picture
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.pravatar.cc/300',
                            ), // Placeholder URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Name & University
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Nama Lengkap',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Universitas Negeri Garut',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // White Container with Menu Items
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(24.0),
                      children: [
                        const SizedBox(height: 10),

                        // Menu Items
                        _buildProfileItem(
                          icon: Icons.edit,
                          text: 'Edit Profile',
                          onTap: () {},
                        ),
                        _buildProfileItem(
                          icon: Icons.lock_outline,
                          text: 'Ubah Password',
                          onTap: () {},
                        ),
                        _buildProfileItem(
                          icon: Icons.settings_outlined,
                          text: 'Pengaturan',
                          onTap: () {},
                        ),

                        const SizedBox(height: 10),

                        // Red / Danger Items
                        _buildProfileItem(
                          icon: Icons.logout,
                          text: 'Log Out',
                          isDestructive: true,
                          onTap: () {
                            // Handle Logout
                          },
                        ),
                        _buildProfileItem(
                          icon: Icons.delete_forever_outlined,
                          text: 'Hapus Akun',
                          isDestructive: true,
                          onTap: () {
                            // Handle Delete Account
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar (Visual Only - Matches Home Page)
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  // Helper widget to build each menu row
  Widget _buildProfileItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Icon Box (Grey placeholder style)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light grey background like in image
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : Colors.black87,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Bold text as per design
                color: isDestructive ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
