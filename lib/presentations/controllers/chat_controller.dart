import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/models/chat_session_model.dart'; // ⬅️ Tambahkan import model yang baru
// --------------------------

class ChatController extends GetxController {
  // State untuk data sesi (Observable List)
  final RxList<ChatSession> sessions = <ChatSession>[].obs;
  final isLoading = false.obs;

  // Asumsi: Kita menggunakan mock data yang sama
  final List<ChatSession> _mockSessions = [
    // ChatSession(
    //   title: 'Merespons Kecemasan Hari Jumat',
    //   lastMessage:
    //       'Aku mengerti perasaan itu valid. Mari kita coba teknik sederhana...',
    //   date: '28 Nov 2025',
    //   moodColor: ColorConst.moodNegative,
    // ),
    // ChatSession(
    //   title: 'Menganalisis Pola Tidur',
    //   lastMessage:
    //       'Itu kabar baik! Moodmu bagus setelah meditasi pagi. Pertahankan!',
    //   date: '27 Nov 2025',
    //   moodColor: ColorConst.moodPositive,
    // ),
    // ChatSession(
    //   title: 'Tujuan Baru: Lari Pagi',
    //   lastMessage:
    //       'Tujuanmu Masuk ke aktivitas baru sudah dicatat. Mari kita pecah...',
    //   date: '25 Nov 2025',
    //   moodColor: ColorConst.primaryAccentGreen,
    // ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadSessions();
  }

  // Simulasikan pemuatan data (misalnya dari PocketBase)
  void loadSessions() {
    isLoading.value = true;
    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      sessions.value = _mockSessions; // Muat data mock
      // sessions.value = []; // UNTUK TESTING EMPTY STATE
      isLoading.value = false;
    });
  }

  // Handler untuk memulai sesi baru
  void startNewSession() {
    // ⚠️ Menampilkan pesan fitur yang akan datang
    Get.snackbar(
      'Fitur Segera Hadir',
      'Mode Chatbot Senandika yang interaktif akan segera tersedia. Tunggu pembaruan kami!',
      icon: const Icon(Icons.psychology_alt, color: Colors.white),
      backgroundColor: ColorConst.ctaPeach,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Atau, jika Anda ingin langsung navigasi ke ChatSessionPage (tanpa pesan warning):
    // Get.toNamed(RouteConstants.chat_session);
  }

  // Handler untuk membuka detail sesi
  void openSessionDetail(ChatSession session) {
    Get.toNamed(RouteConstants.chat_session, arguments: session);
  }

  // Handler navigasi Bottom Bar
  void navigateTo(int index) {
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
        break; // Tetap di sini
      case 4:
        Get.toNamed(RouteConstants.profile);
        break;
    }
  }
}
