// presentations/controllers/journal_mood_log_edit_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/journal_mood_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/models/mood_log_model.dart';
import 'package:senandika/data/repositories/journal_repository.dart';
import 'package:senandika/presentations/controllers/home_controller.dart';
import 'package:senandika/presentations/controllers/journal_controller.dart';
import 'package:senandika/presentations/controllers/journal_mood_log_show_controller.dart';

class JournalMoodLogEditController extends GetxController {
  final IJournalRepository _journalRepository;

  JournalMoodLogEditController(this._journalRepository);

  // Data Log yang sedang diedit
  final Rx<MoodLogModel?> originalMoodLog = Rxn<MoodLogModel>();

  // Form Controllers
  final TextEditingController journalController = TextEditingController();
  final TextEditingController customTagController = TextEditingController();

  // Observable untuk state form
  final selectedMoodScore = 0.obs;
  final selectedTags = <String>[].obs;
  final selectedCustomTags = <String>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Mood data from JournalMoodConstant
  List<Map<String, dynamic>> get moods => JournalMoodConstant.moods;

  // Available tags from JournalMoodConstant
  List<String> get availableTags => JournalMoodConstant.availableTags;

  @override
  void onInit() {
    super.onInit();
    final MoodLogModel? logToEdit = Get.arguments;

    if (logToEdit != null) {
      originalMoodLog.value = logToEdit;
      _initializeForm(logToEdit);
    } else {
      _showErrorSnackbar('Data jurnal untuk diedit tidak ditemukan.');
      Future.delayed(const Duration(seconds: 2), () => Get.back());
    }
  }

  @override
  void dispose() {
    journalController.dispose();
    customTagController.dispose();
    super.dispose();
  }

  // Inisialisasi form dengan data log yang ada
  void _initializeForm(MoodLogModel log) {
    selectedMoodScore.value = log.score;
    journalController.text = log.text;

    for (var tag in log.tags) {
      if (availableTags.contains(tag)) {
        selectedTags.add(tag);
      } else {
        selectedCustomTags.add(tag);
      }
    }
  }

  // --- UI Handlers (tetap sama) ---
  void setSelectedMoodScore(int score) {
    selectedMoodScore.value = score;
    errorMessage.value = '';
  }

  void togglePresetTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void addCustomTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty &&
        !selectedCustomTags.contains(trimmedTag) &&
        !selectedTags.contains(trimmedTag)) {
      selectedCustomTags.add(trimmedTag);
      customTagController.clear();
    }
  }

  void removeCustomTag(String tag) {
    selectedCustomTags.remove(tag);
  }

  // Mood helper methods using JournalMoodConstant
  Color getMoodColor(int score) => JournalMoodConstant.getMoodColor(score);
  String getMoodEmoji(int score) => JournalMoodConstant.getMoodEmoji(score);
  String getMoodLabel(int score) => JournalMoodConstant.getMoodLabel(score);
  bool isPositiveMood(int score) => JournalMoodConstant.isPositiveMood(score);
  bool isNegativeMood(int score) => JournalMoodConstant.isNegativeMood(score);
  bool isNeutralMood(int score) => JournalMoodConstant.isNeutralMood(score);

  // --- Snackbar Helpers (tetap sama) ---
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal',
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

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: ColorConst.primaryAccentGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 4),
    );
  }

  // --- UPDATE LOGIC (tetap sama) ---
  Future<void> updateLog() async {
    if (selectedMoodScore.value == 0) {
      _showErrorSnackbar('Mohon pilih suasana hati Anda terlebih dahulu.');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final allTags = <String>[...selectedTags, ...selectedCustomTags];

      if (originalMoodLog.value == null) {
        _showErrorSnackbar('Jurnal yang akan diedit tidak ditemukan.');
        return;
      }

      await _journalRepository.updateMoodLog(
        originalMoodLog.value!.id,
        selectedMoodScore.value,
        journalController.text.trim(),
        allTags.toSet().toList(),
      );

      if (Get.isRegistered<JournalController>()) {
        final logMonth = originalMoodLog.value!.timestamp.toLocal();
        Get.find<JournalController>().loadMonthlyLogs(
          logMonth,
          forceReload: true,
        );
      }

      if (Get.isRegistered<JournalMoodLogShowController>()) {
        final logId = originalMoodLog.value!.id;
        Get.find<JournalMoodLogShowController>().loadLogDetail(logId);
      }

      // Refresh HomeController to sync today's mood data
      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().refreshMoodData();
      }

      Get.offNamed(RouteConstants.journal);
      _showSuccessSnackbar('Jurnal berhasil diperbarui!');
    } catch (e) {
      print('Update Log Error: $e');
      final String errorText = e.toString();
      final displayMessage = errorText.startsWith('Exception: ')
          ? errorText.replaceFirst('Exception: ', '')
          : 'Gagal memperbarui jurnal. Silakan coba lagi.';
      _showErrorSnackbar(displayMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
