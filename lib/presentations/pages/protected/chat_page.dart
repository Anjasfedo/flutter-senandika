import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/route_constant.dart';

// --- Session Data Model (Mock) ---
class ChatSession {
  final String title;
  final String lastMessage;
  final String date;
  final Color moodColor;

  ChatSession({
    required this.title,
    required this.lastMessage,
    required this.date,
    required this.moodColor,
  });
}
// --------------------------

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Mock Data untuk Riwayat Sesi
  final List<ChatSession> _sessions = [
    ChatSession(
      title: 'Merespons Kecemasan Hari Jumat',
      lastMessage: 'Aku mengerti perasaan itu valid. Mari kita coba teknik sederhana...',
      date: '28 Nov 2025',
      moodColor: ColorConst.moodNegative,
    ),
    ChatSession(
      title: 'Menganalisis Pola Tidur',
      lastMessage: 'Itu kabar baik! Moodmu bagus setelah meditasi pagi. Pertahankan!',
      date: '27 Nov 2025',
      moodColor: ColorConst.moodPositive,
    ),
    ChatSession(
      title: 'Tujuan Baru: Lari Pagi',
      lastMessage: 'Tujuanmu Masuk ke aktivitas baru sudah dicatat. Mari kita pecah...',
      date: '25 Nov 2025',
      moodColor: ColorConst.primaryAccentGreen,
    ),
  ];
  
  void _startNewSession() {
    // Navigasi ke halaman Chat Session yang sebenarnya
    Get.toNamed(RouteConstants.chat); // Asumsi RouteConstants.chat mengarah ke ChatSessionPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Senandika - Pendamping Batin',
          style: TextStyle(color: ColorConst.primaryTextDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorConst.secondaryAccentLavender,
        elevation: 0,
        automaticallyImplyLeading: false, // Karena ini adalah tab utama
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tombol Mulai Sesi Baru
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _startNewSession,
                icon: const Icon(Icons.psychology_alt_outlined, size: 24),
                label: const Text('Mulai Sesi Senandika Baru'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConst.primaryAccentGreen, // Sage Green untuk aksi utama
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          
          // Riwayat Sesi
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 10.0),
            child: Text(
              'Riwayat Sesi (${_sessions.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConst.primaryTextDark,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                return _buildSessionCard(session);
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 3, 
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
              // Tetap di sini
              break;
            case 4:
              Get.toNamed(RouteConstants.profile);
              break;
          }
        },
      ),
    );
  }

  // Helper untuk membuat kartu riwayat sesi
  Widget _buildSessionCard(ChatSession session) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: ListTile(
        onTap: () {
          // Navigasi ke ChatSessionPage untuk melihat detail sesi
          Get.toNamed(RouteConstants.chat_session, arguments: session); 
        },
        
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
          style: TextStyle(
            color: ColorConst.secondaryTextGrey,
            fontSize: 13,
          ),
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
}