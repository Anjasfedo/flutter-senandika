import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/route_constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // --- Mock User Data & Settings State ---
  String userName = "Pengguna Senandika";
  String userEmail = "user.senandika@email.com";

  // Safety Settings
  String crisisContactName = "Kontak Terpercaya";
  String crisisContactPhone = "0812-XXXX-XXXX";
  bool isBiometricEnabled = true;

  // Goal Settings
  bool isJournalMandatory = true;
  int dailyGoalCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Profil & Pengaturan',
          style: TextStyle(
            color: ColorConst.primaryTextDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorConst.secondaryAccentLavender,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian 1: Informasi Profil ---
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: ColorConst.primaryAccentGreen,
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorConst.primaryTextDark,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorConst.secondaryTextGrey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tombol Edit Profil
                  OutlinedButton.icon(
                    onPressed: () {
                      Get.toNamed(RouteConstants.profile_edit);
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: ColorConst.primaryAccentGreen,
                    ),
                    label: Text(
                      'Edit Profil',
                      style: TextStyle(color: ColorConst.primaryAccentGreen),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorConst.primaryAccentGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- Bagian 2: Pengaturan Keamanan & Krisis ---
            Text(
              'Keamanan & Dukungan Krisis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConst.primaryTextDark,
              ),
            ),
            const SizedBox(height: 15),

            // Card Kontak Darurat
            _buildSettingCard(
              icon: Icons.call_outlined,
              title: 'Kontak Darurat Pribadi',
              subtitle: '$crisisContactName (${crisisContactPhone})',
              onTap: () {
                // Mock dialog untuk edit kontak darurat
                Get.toNamed(RouteConstants.profile_emergency_contact);
              },
            ),

            const SizedBox(height: 10),

            // Card Keamanan Biometrik
            _buildToggleCard(
              icon: Icons.fingerprint,
              title: 'Kunci Biometrik/PIN',
              subtitle: isBiometricEnabled ? 'Aktif' : 'Nonaktif',
              value: isBiometricEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  isBiometricEnabled = newValue;
                });
              },
            ),

            const SizedBox(height: 30),

            // --- Bagian 3: Pengaturan Target Harian (Progress) ---
            Text(
              'Pengaturan Target Harian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConst.primaryTextDark,
              ),
            ),
            const SizedBox(height: 15),

            const SizedBox(height: 10),

            // Card Pengaturan Tujuan Khusus (Tier 2/3)
            _buildSettingCard(
              icon: Icons.checklist_rtl,
              title: 'Kelola Target Kebiasaan',
              subtitle: 'Atur target harian, mingguan, dan kebiasaanmu.',
              onTap: () {
                // Navigate to a dedicated goal management page
                Get.toNamed(RouteConstants.profile_target_habit);
              },
            ),

            const SizedBox(height: 50),

            // --- Tombol Logout ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Simulasi Logout
                  Get.offAllNamed(RouteConstants.login);
                },
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Keluar (Logout)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConst.moodNegative.withOpacity(
                    0.8,
                  ), // Warna merah lembut
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 4,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Get.toNamed(RouteConstants.home);
              break;
            case 1:
              Get.toNamed(RouteConstants.journal);
              break;
            case 2:
              Get.toNamed(RouteConstants.meditation);
              break;
            case 3:
              Get.toNamed(RouteConstants.chat);
              break;
            case 4:
              break; // Tetap di sini
          }
        },
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: ColorConst.primaryAccentGreen),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ColorConst.primaryTextDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: ColorConst.secondaryTextGrey),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: ColorConst.secondaryTextGrey,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: SwitchListTile(
        secondary: Icon(icon, color: ColorConst.primaryAccentGreen),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ColorConst.primaryTextDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: ColorConst.secondaryTextGrey),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: ColorConst.primaryAccentGreen,
      ),
    );
  }
}
