import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/data/repositories/journal_repository.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/models/mood_log_model.dart';
import 'package:senandika/constants/color_constant.dart'; // Untuk helpers warna

class JournalController extends GetxController {
  final IJournalRepository _journalRepository;
  final IAuthRepository _authRepository;

  JournalController(this._journalRepository, this._authRepository);

  // --- States Kalender & Data ---
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  // Map untuk menyimpan data log yang sudah dimuat: {YYYYMM: List<MoodLogModel>}
  final RxMap<int, List<MoodLogModel>> loadedMoods =
      <int, List<MoodLogModel>>{}.obs;
  final isLoading = false.obs;
  final isInitialLoading = true.obs;

  String get _currentUserId => _authRepository.currentUser?.id ?? '';

  // Getter untuk data log bulan yang sedang fokus
  List<MoodLogModel> get currentMonthLogs {
    final key = focusedMonthKey(focusedMonth.value);

    return loadedMoods[key]?.map((log) {
          // Periksa dan pastikan konversi ke waktu lokal HANYA terjadi di sini
          if (log.timestamp.isUtc) {
            // Buat copy log dengan timestamp lokal
            return MoodLogModel(
              id: log.id,
              userId: log.userId,
              score: log.score,
              text: log.text,
              timestamp: log.timestamp.toLocal(), // ⬅️ Konversi ke waktu lokal
            );
          }
          return log; // Jika sudah lokal (misalnya, di Model), kembalikan saja
        }).toList() ??
        [];
  }

  // Getter untuk Kalender
  Map<int, int> get currentMonthMoodScores {
    final scores = <int, int>{};
    for (var log in currentMonthLogs) {
      // ⬅️ Sekarang log.timestamp.day adalah hari LOKAL yang benar
      scores[log.timestamp.day] = log.score;
    }
    return scores;
  }

  @override
  void onInit() {
    super.onInit();
    // Muat bulan saat ini saat controller dibuat
    loadMonthlyLogs(focusedMonth.value);
  }

  // Helper: Membuat Key YYYYMM untuk Map
  int focusedMonthKey(DateTime date) {
    return date.year * 100 + date.month;
  }

  // Helper: Mendapatkan tanggal awal dan akhir bulan
  DateTime getStartOfMonth(DateTime date) => DateTime(date.year, date.month, 1);
  DateTime getEndOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0, 23, 59, 59);

  // ⬅️ LAZY LOADING HANDLER
  Future<void> loadMonthlyLogs(
    DateTime month, {
    bool forceReload = false,
  }) async {
    final key = focusedMonthKey(month);

    // ⬅️ Hapus kondisi 'sudah dimuat' jika forceReload = true
    if (!forceReload && loadedMoods.containsKey(key)) return;

    if (isLoading.value) return;

    final isFirstLoad = loadedMoods.isEmpty;
    isLoading.value = true;

    try {
      final logs = await _journalRepository.getMonthlyMoodLogs(
        getStartOfMonth(month),
        getEndOfMonth(month),
        _currentUserId,
      );

      // ⬅️ Simpan data di cache lokal (Ini akan menimpa data lama jika forceReload=true)
      loadedMoods[key] = logs;

      // Penting: Agar Obx yang mendengarkan loadedMoods tahu ada perubahan, kita harus me-refresh map-nya.
      loadedMoods.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data jurnal: $e');
    } finally {
      isLoading.value = false;
      if (isFirstLoad) isInitialLoading.value = false;
    }
  }

  // ⬅️ NAVIGATION HANDLERS

  void goToPreviousMonth() {
    final prevMonth = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month - 1,
      1,
    );
    focusedMonth.value = prevMonth;
    // ⬅️ Force Reload setiap kali pindah bulan
    loadMonthlyLogs(prevMonth, forceReload: true);
  }

  void goToNextMonth() {
    final nextMonth = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month + 1,
      1,
    );
    final now = DateTime.now();

    if (nextMonth.year > now.year ||
        (nextMonth.year == now.year && nextMonth.month > now.month)) {
      return;
    }

    focusedMonth.value = nextMonth;
    // ⬅️ Force Reload setiap kali pindah bulan
    loadMonthlyLogs(nextMonth, forceReload: true);
  }

  // ⬅️ UTILITY LOGIC

  Color getMoodColor(int score) {
    switch (score) {
      case 5:
        return ColorConst.moodPositive;
      case 4:
        return ColorConst.primaryAccentGreen.withOpacity(0.8);
      case 3:
        return ColorConst.moodNeutral;
      case 2:
        return ColorConst.secondaryTextGrey.withOpacity(0.5);
      case 1:
        return ColorConst.moodNegative;
      default:
        return Colors.transparent;
    }
  }

  String getMoodEmoji(int score) {
    switch (score) {
      case 5:
        return '🤩';
      case 4:
        return '😊';
      case 3:
        return '😐';
      case 2:
        return '😟';
      case 1:
        return '😭';
      default:
        return '❓';
    }
  }
}
