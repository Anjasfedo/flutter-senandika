import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/journal_repository.dart';
import 'package:senandika/presentations/controllers/journal_controller.dart';

class JournalMoodLogController extends GetxController {
  final IJournalRepository _journalRepository;
  final IAuthRepository _authRepository;

  JournalMoodLogController(this._journalRepository, this._authRepository);

  // === Form State Management ===
  final TextEditingController journalController = TextEditingController();

  // ⬅️ States Reaktif
  final RxInt selectedMoodScore = 3.obs; // Default ke Netral (3)
  final RxList<String> selectedTags = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Data
  final String _currentUserId =
      Get.find<IAuthRepository>().currentUser?.id ?? '';

  final List<Map<String, dynamic>> moods = const [
    {'score': 1, 'emoji': '😭', 'label': 'Sangat Buruk'},
    {'score': 2, 'emoji': '😟', 'label': 'Buruk'},
    {'score': 3, 'emoji': '😐', 'label': 'Netral'},
    {'score': 4, 'emoji': '😊', 'label': 'Baik'},
    {'score': 5, 'emoji': '🤩', 'label': 'Sangat Baik'},
  ];

  // Available Tags (Dibuat final karena kita abaikan kustomisasi di sini)
  final List<String> availableTags = const [
    'Work Stress',
    'Sleep Issues',
    'Socializing',
    'Exercise',
    'Tiredness',
    'Family Time',
    'Food Craving',
  ];

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  // --- Handlers UI ---

  void setSelectedMoodScore(int score) {
    selectedMoodScore.value = score;
    errorMessage.value = ''; // Hapus error jika user memilih mood
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  // --- Logic Penyimpanan ---

  Future<void> saveLog() async {
    if (_currentUserId.isEmpty) {
      errorMessage.value = 'Akses ditolak. Silakan login kembali.';
      return;
    }

    if (selectedMoodScore.value == 0) {
      errorMessage.value = 'Mohon pilih suasana hati Anda terlebih dahulu.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final score = selectedMoodScore.value;
      final text = journalController.text.trim();
      final tags = selectedTags.toList(); // Ambil list tags

      // Panggil Repository untuk menyimpan data
      await _journalRepository.createMoodLog(score, text, tags, _currentUserId);

      if (Get.isRegistered<JournalController>()) {
        final journalController = Get.find<JournalController>();

        // 1. ⬅️ Hapus data lama dari cache Controller (Opsional, tapi aman)
        final key = journalController.focusedMonthKey(
          journalController.focusedMonth.value,
        );
        journalController.loadedMoods.remove(key);

        // 2. Muat ulang (yang kini dipastikan akan memanggil API)
        await journalController.loadMonthlyLogs(
          journalController.focusedMonth.value,
          forceReload: true,
        );
      }

      // Feedback sukses
      Get.back();
      Get.snackbar(
        'Tercatat!',
        'Suasana hati dan jurnal Anda berhasil dicatat.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Save Log Error: $e');
      final String errorText = e.toString();
      errorMessage.value = errorText.startsWith('Exception: ')
          ? errorText.replaceFirst('Exception: ', '')
          : 'Gagal menyimpan jurnal. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }
}
