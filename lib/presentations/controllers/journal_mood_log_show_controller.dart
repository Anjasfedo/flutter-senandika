// presentations/controllers/journal_mood_log_show_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/journal_mood_constant.dart';
import 'package:senandika/data/models/mood_log_model.dart';
import 'package:senandika/data/repositories/journal_repository.dart';

class JournalMoodLogShowController extends GetxController {
  final IJournalRepository _journalRepository;

  JournalMoodLogShowController(this._journalRepository);

  final Rx<MoodLogModel?> moodLog = Rxn<MoodLogModel>();
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final logId = Get.arguments as String?; // Menerima ID dari argumen rute

  @override
  void onInit() {
    super.onInit();
    if (logId != null) {
      loadLogDetail(logId!);
    } else {
      isLoading.value = false;
      _showErrorSnackbar('ID Jurnal tidak ditemukan.');
    }
  }

  // Mood helper methods using JournalMoodConstant
  Color getMoodColor(int score) => JournalMoodConstant.getMoodColor(score);
  String getMoodEmoji(int score) => JournalMoodConstant.getMoodEmoji(score);
  String getMoodLabel(int score) => JournalMoodConstant.getMoodLabel(score);
  bool isPositiveMood(int score) => JournalMoodConstant.isPositiveMood(score);
  bool isNegativeMood(int score) => JournalMoodConstant.isNegativeMood(score);
  bool isNeutralMood(int score) => JournalMoodConstant.isNeutralMood(score);

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal Memuat',
      message,
      backgroundColor: ColorConst.moodNegative,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 4),
    );
  }

  Future<void> loadLogDetail(String id) async {
    isLoading.value = true;
    try {
      final log = await _journalRepository.getMoodLogById(id);
      if (log != null) {
        // Konversi ke waktu lokal saat disimpan di state
        moodLog.value = MoodLogModel(
          id: log.id,
          userId: log.userId,
          score: log.score,
          text: log.text,
          tags: log.tags,
          timestamp: log.timestamp
              .toLocal(), // Konversi ke Lokal untuk tampilan
        );
      } else {
        _showErrorSnackbar('Jurnal tidak ditemukan (ID: $id).');
      }
    } catch (e) {
      print('Load Log Detail Error: $e');
      _showErrorSnackbar('Terjadi kesalahan saat memuat detail jurnal.');
    } finally {
      isLoading.value = false;
    }
  }
}
