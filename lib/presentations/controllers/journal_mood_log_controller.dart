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

  // === Controller & States ===

  // 1. Controller untuk Jurnal (Teks Panjang)
  final TextEditingController journalController = TextEditingController();

  // 2. Controller untuk input Tag Kustom
  final TextEditingController customTagController =
      TextEditingController(); // 💡 BARU: Untuk input tags kustom

  // ⬅️ States Reaktif
  final RxInt selectedMoodScore = 3.obs; // Default ke Netral (3)
  final RxList<String> selectedTags =
      <String>[].obs; // Tags Preset yang dipilih
  final RxList<String> selectedCustomTags =
      <String>[].obs; // 💡 BARU: Tags Kustom yang dipilih
  final RxBool isLoading = false.obs;

  // Data
  String get _currentUserId => _authRepository.currentUser?.id ?? '';

  final List<Map<String, dynamic>> moods = const [
    {
      'score': 1,
      'emoji': '😭',
      'label': 'Sangat Buruk',
      'color': ColorConst.moodNegative,
    },
    {
      'score': 2,
      'emoji': '😟',
      'label': 'Buruk',
      'color': ColorConst.secondaryTextGrey,
    },
    {
      'score': 3,
      'emoji': '😐',
      'label': 'Netral',
      'color': ColorConst.moodNeutral,
    },
    {
      'score': 4,
      'emoji': '😊',
      'label': 'Baik',
      'color': ColorConst.primaryAccentGreen,
    },
    {
      'score': 5,
      'emoji': '🤩',
      'label': 'Sangat Baik',
      'color': ColorConst.moodPositive,
    },
  ];

  // Available Tags (Preset)
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
    customTagController.dispose(); // 💡 Dispose controller kustom
    super.dispose();
  }

  // -----------------------------------------------------------------

  // --- Handlers Mood & Tags Preset ---

  void setSelectedMoodScore(int score) {
    selectedMoodScore.value = score;
  }

  void togglePresetTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  // -----------------------------------------------------------------

  // --- Handlers Tags Kustom (NEW) ---

  void addCustomTag(String tag) {
    final cleanTag = tag.trim();
    if (cleanTag.isNotEmpty && cleanTag.length <= 30) {
      // Batasi panjang tag
      // Cek apakah tag sudah ada di preset atau kustom
      if (!selectedTags.contains(cleanTag) &&
          !selectedCustomTags.contains(cleanTag)) {
        selectedCustomTags.add(cleanTag);
        customTagController.clear(); // Bersihkan input setelah ditambahkan
      } else {
        final displayMessage = 'Tag "$cleanTag" sudah dipilih.';
        Get.snackbar(
          'Tag Terpilih!',
          displayMessage,
          backgroundColor: ColorConst.primaryAccentGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
    } else if (cleanTag.length > 30) {
      _showErrorSnackbar("Tag terlalu panjang.");
    }
  }

  void removeCustomTag(String tag) {
    selectedCustomTags.remove(tag);
  }

  // -----------------------------------------------------------------

  // --- Logic Penyimpanan ---

  List<String> _getAllTagsForSubmission() {
    // Gabungkan tags preset dan tags kustom
    final combinedTags = <String>[];
    combinedTags.addAll(selectedTags);
    combinedTags.addAll(selectedCustomTags);
    return combinedTags;
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Aksi Gagal', message, duration: const Duration(seconds: 4));
  }

  Future<void> saveLog() async {
    if (_currentUserId.isEmpty) {
      _showErrorSnackbar('Akses ditolak. Silakan login kembali.'); // ⬅️ DIUBAH
      return;
    }

    if (selectedMoodScore.value == 0) {
      _showErrorSnackbar(
        'Mohon pilih suasana hati Anda terlebih dahulu.',
      ); // ⬅️ DIUBAH
      return;
    }

    isLoading.value = true;

    try {
      final score = selectedMoodScore.value;
      final text = journalController.text.trim();
      final tags =
          _getAllTagsForSubmission(); // 💡 Ambil semua tags (preset + kustom)

      // Panggil Repository untuk menyimpan data
      await _journalRepository.createMoodLog(score, text, tags, _currentUserId);

      // Setelah berhasil, panggil JournalController untuk memuat ulang data
      if (Get.isRegistered<JournalController>()) {
        final journalController = Get.find<JournalController>();

        // Hapus data lama dari cache (penting untuk refresh data)
        final key = journalController.focusedMonthKey(
          journalController.focusedMonth.value,
        );
        journalController.loadedMoods.remove(key);

        // Muat ulang log bulan (forceReload: true memastikan API dipanggil)
        await journalController.loadMonthlyLogs(
          journalController.focusedMonth.value,
          forceReload: true,
        );
      }

      // Feedback sukses dan kembali
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

      final displayMessage = errorText.startsWith('Exception: ')
          ? errorText.replaceFirst('Exception: ', '')
          : 'Gagal menyimpan jurnal. Silakan coba lagi.';

      _showErrorSnackbar(displayMessage); // ⬅️ DIUBAH
    } finally {
      isLoading.value = false;
    }
  }
}
