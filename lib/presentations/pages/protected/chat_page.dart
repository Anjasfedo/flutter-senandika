import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/data/models/chat_session_model.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/presentations/controllers/chat_controller.dart'; // Import Controller

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  // Helper untuk membuat kartu riwayat sesi
  Widget _buildSessionCard(ChatSession session) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: ListTile(
        onTap: () =>
            controller.openSessionDetail(session), // ⬅️ Panggil Controller
        // Judul Sesi
        title: Text(
          session.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ColorConst.primaryTextDark,
            fontSize: 16,
          ),
        ),

        // Pesan Terakhir
        subtitle: Text(
          session.lastMessage,
          style: TextStyle(color: ColorConst.secondaryTextGrey, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Tanggal
        trailing: Text(
          session.date,
          style: TextStyle(
            color: ColorConst.secondaryTextGrey.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ⬅️ Widget untuk Status Kosong (Empty State)
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: ColorConst.secondaryTextGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum ada riwayat sesi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConst.secondaryTextGrey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Klik "Mulai Sesi Senandika Baru" untuk memulai dialog pertamamu dengan Senandika.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorConst.secondaryTextGrey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Senandika - Pendamping Batin',
          style: TextStyle(
            color: ColorConst.primaryTextDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorConst.secondaryAccentLavender,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tombol Mulai Sesi Baru
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(
              () => SizedBox(
                // Bungkus dengan Obx agar bisa disable saat loading
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.isFalse
                      ? controller.startNewSession
                      : null, // ⬅️ Panggil Controller
                  icon: controller.isLoading.isTrue
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.psychology_alt_outlined, size: 24),
                  label: controller.isLoading.isTrue
                      ? const Text('Memuat Riwayat...')
                      : const Text('Mulai Sesi Senandika Baru'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.primaryAccentGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    disabledBackgroundColor: ColorConst.primaryAccentGreen
                        .withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),

          // Riwayat Sesi Title
          Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              bottom: 10.0,
            ),
            child: Obx(
              () => Text(
                'Riwayat Sesi (${controller.sessions.length})', // ⬅️ Reaktif
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
              ),
            ),
          ),

          // ⬅️ List Riwayat Sesi (Conditional Rendering)
          Expanded(
            child: Obx(() {
              if (controller.isLoading.isTrue && controller.sessions.isEmpty) {
                // Tampilkan loading spinner saat pertama kali memuat dan list masih kosong
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.sessions.isEmpty) {
                // Tampilkan empty state jika list kosong
                return _buildEmptyState();
              }

              // Tampilkan daftar sesi
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: controller.sessions.length,
                itemBuilder: (context, index) {
                  final session = controller.sessions[index];
                  return _buildSessionCard(session);
                },
              );
            }),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 3,
        onItemTapped: controller.navigateTo, // ⬅️ Panggil Controller
      ),
    );
  }
}
