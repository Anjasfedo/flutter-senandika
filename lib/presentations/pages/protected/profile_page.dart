import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/presentations/controllers/profile_controller.dart'; // Import Controller

// Ganti dari StatefulWidget menjadi GetView
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

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
            // --- Bagian 1: Informasi Profil (Menggunakan Obx) ---
            Center(
              child: Obx(
                () => Column(
                  // Obx membungkus data reaktif
                  children: [
                    _buildAvatarWidget(controller.avatarUrl.value),
                    
                    const SizedBox(height: 10),
                    Text(
                      controller.userName.value, // ⬅️ Ambil dari Controller
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.primaryTextDark,
                      ),
                    ),
                    Text(
                      controller.userEmail.value, // ⬅️ Ambil dari Controller
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

            // Card Kontak Darurat (Menggunakan Obx)
            Obx(
              () => _buildSettingCard(
                icon: Icons.call_outlined,
                title: 'Kontak Darurat Pribadi',
                subtitle:
                    '${controller.crisisContactName.value} (${controller.crisisContactPhone.value})', // ⬅️ Ambil dari Controller
                onTap: controller.goToEmergencyContact, // ⬅️ Panggil Controller
              ),
            ),

            const SizedBox(height: 10),

            // Card Keamanan Biometrik (Menggunakan Obx & Toggle Handler)
            Obx(
              () => _buildToggleCard(
                icon: Icons.fingerprint,
                title: 'Kunci Biometrik/PIN',
                subtitle: controller.isBiometricEnabled.value
                    ? 'Aktif'
                    : 'Nonaktif', // ⬅️ Ambil dari Controller
                value: controller
                    .isBiometricEnabled
                    .value, // ⬅️ Ambil dari Controller
                onChanged: controller.toggleBiometric, // ⬅️ Panggil Controller
              ),
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

            // Card Journal Mandatory (Menggunakan Obx & Toggle Handler)
            Obx(
              () => _buildToggleCard(
                icon: Icons.assignment_turned_in_outlined,
                title: 'Wajib Jurnal Harian',
                subtitle: controller.isJournalMandatory.value
                    ? 'Wajib Log Mood & Journal'
                    : 'Opsional Log Mood & Journal',
                value: controller.isJournalMandatory.value,
                onChanged: controller.toggleJournalMandatory,
              ),
            ),

            const SizedBox(height: 10),

            // Card Pengaturan Tujuan Khusus
            _buildSettingCard(
              icon: Icons.checklist_rtl,
              title: 'Kelola Target Kebiasaan',
              subtitle: 'Atur target harian, mingguan, dan kebiasaanmu.',
              onTap: controller.goToTargetHabit, // ⬅️ Panggil Controller
            ),

            const SizedBox(height: 50),

            // --- Tombol Logout ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed:
                    controller.handleLogout, // ⬅️ Panggil Controller Logout
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Keluar (Logout)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConst.moodNegative.withOpacity(0.8),
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
      // Bottom Navigation Bar (Perlu disesuaikan untuk navigasi Controller jika menggunakan Home Controller)
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 4,
        onItemTapped: (index) {
          // Navigasi melalui Get.toNamed, bukan melalui Controller
          switch (index) {
            case 0:
              Get.offAllNamed(RouteConstants.home);
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

  // --- Helper Widgets (Dipertahankan di dalam Page untuk struktur UI) ---

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

  Widget _buildAvatarWidget(String? avatarUrl) {
    // Jika URL tidak null dan tidak kosong, gunakan NetworkImage
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundColor: ColorConst.primaryAccentGreen,
        backgroundImage: NetworkImage(
          avatarUrl,
        ), // ⬅️ Tampilkan gambar dari network
        // Jika ada masalah loading, NetworkImage akan menampilkan child/background
        child: null,
      );
    } else {
      // Jika tidak ada URL, gunakan ikon default
      return const CircleAvatar(
        radius: 40,
        backgroundColor: ColorConst.primaryAccentGreen,
        child: Icon(Icons.person_outline, size: 40, color: Colors.white),
      );
    }
  }
}
