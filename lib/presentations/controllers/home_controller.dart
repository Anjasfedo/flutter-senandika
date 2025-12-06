import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/journal_repository.dart';
import 'package:senandika/data/models/mood_log_model.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/constants/journal_mood_constant.dart';
import 'package:senandika/data/sources/pocketbase.dart';
import 'package:senandika/services/journal_validation_service.dart';

class HomeController extends GetxController {
  final IAuthRepository _authRepository;
  final IJournalRepository _journalRepository;
  final PocketBaseService _pbService = Get.find<PocketBaseService>();

  HomeController(this._authRepository, this._journalRepository);

  // States Reaktif
  final RxString userName = 'Pengguna Senandika'.obs;
  final RxInt moodScore = 0.obs; // Default: No mood logged today
  final RxString avatarUrl = ''.obs;
  final Rx<MoodLogModel?> todayMoodLog = Rx<MoodLogModel?>(null);
  final RxBool isLoadingMood = false.obs;

  // Data target di sini akan dipindahkan dari PageState
  // Gunakan RxList jika datanya akan diubah di Controller (Contoh: checklist)
  // Untuk saat ini kita pindahkan data mock ke sini
  final List<TargetItem> allTargets = [
    TargetItem(
      id: '1',
      title: 'Log Mood (Wajib Harian)',
      frequency: 'Harian',
      isCompleted: true.obs, // Gunakan RxBool
    ),
    TargetItem(
      id: '2',
      title: 'Jalan kaki 10 menit',
      frequency: 'Harian',
      isCompleted: false.obs,
    ),
    TargetItem(
      id: '3',
      title: 'Meditasi 5 menit',
      frequency: 'Harian',
      isCompleted: true.obs,
    ),
    TargetItem(
      id: '4',
      title: 'Baca buku 15 menit',
      frequency: 'Mingguan',
      isCompleted: false.obs,
    ),
    TargetItem(
      id: '5',
      title: 'Telepon teman',
      frequency: 'Mingguan',
      isCompleted: true.obs,
    ),
    TargetItem(
      id: '6',
      title: 'Coba resep baru',
      frequency: 'Sekali Waktu',
      isCompleted: false.obs,
    ),
  ].obs;
  // Gunakan .obs pada List jika List itu sendiri bisa diganti

  // Metode untuk mengganti status checklist (State Management)
  void toggleTargetCompletion(TargetItem item, bool newValue) {
    item.isCompleted.value = newValue;
    // Di aplikasi nyata: panggil repository untuk update ke PocketBase
  }

  // Mood-related methods
  Future<void> _loadTodayMood() async {
    if (isLoadingMood.value) return;

    final userId = _authRepository.currentUser?.id ?? '';
    if (userId.isEmpty) return;

    try {
      isLoadingMood.value = true;
      final todayLog = await _journalRepository.getMoodLogByDate(DateTime.now(), userId);

      todayMoodLog.value = todayLog;
      if (todayLog != null) {
        moodScore.value = todayLog.score;
      } else {
        moodScore.value = 0; // No mood logged today
      }
    } catch (e) {
      print('Error loading today mood: $e');
      moodScore.value = 0;
    } finally {
      isLoadingMood.value = false;
    }
  }

  // Check if user has logged mood today
  bool get hasTodayMood => todayMoodLog.value != null;

  // Get navigation action for mood button
  String get moodButtonText => hasTodayMood ? 'Lihat Mood' : 'Log Mood';

  Future<void> navigateToMoodPage() async {
    try {
      final validationService = Get.find<JournalValidationService>();

      if (hasTodayMood) {
        // Navigate to existing log detail
        await Get.toNamed(
          RouteConstants.journal_mood_log_show,
          arguments: todayMoodLog.value!.id,
        );
      } else {
        // Use validation service to check and redirect appropriately
        final canProceed = await validationService.validateAndRedirectToMoodLog();

        if (canProceed) {
          // Navigate to create new mood log
          await Get.toNamed(RouteConstants.journal_mood_log);
        }
        // If canProceed is false, user will be redirected by validation service
      }

      // Refresh mood data when returning
      await refreshMoodData();
    } catch (e) {
      print('Error in navigateToMoodPage: $e');
      // Fallback to original behavior
      if (hasTodayMood) {
        await Get.toNamed(
          RouteConstants.journal_mood_log_show,
          arguments: todayMoodLog.value!.id,
        );
      } else {
        await Get.toNamed(RouteConstants.journal_mood_log);
      }
      await refreshMoodData();
    }
  }

  // Method to refresh mood data manually (called from UI)
  Future<void> refreshMood() async {
    await refreshMoodData();
  }

  // Public method to refresh mood data (called from other controllers)
  Future<void> refreshMoodData() async {
    try {
      await refreshMoodData();
    } catch (e) {
      print('Error refreshing mood data in HomeController: $e');
    }
  }

  // Mengambil data saat Controller dibuat
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadTodayMood();
  }

  void _loadUserData() {
    final user = _authRepository.currentUser;
    if (user != null) {
      String name = user.name;
      if (name.contains('@')) {
        name = name.split('@').first;
      }
      userName.value = name;

      // ⬅️ Logika Pembentukan URL Avatar (Mirip ProfileController)
      if (user.avatar != null && user.avatar!.isNotEmpty) {
        final String collectionId = 'users'; // PocketBase user collection ID
        final String recordId = user.id;
        final String filename = user.avatar!;

        final fullUrl =
            '${_pbService.pb.baseUrl}/api/files/$collectionId/$recordId/$filename';

        avatarUrl.value = fullUrl;
      } else {
        avatarUrl.value = '';
      }
    }
  }

  void launchCrisisCall() {
    const crisisNumber = '1500451';
    print('Calling Crisis Number: $crisisNumber');
    // Implementasi real call menggunakan url_launcher
  }

  void navigateTo(int index) {
    switch (index) {
      case 0:
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
        Get.toNamed(RouteConstants.profile);
        break;
    }
  }

  String getMoodEmoji(int score) => JournalMoodConstant.getMoodEmoji(score);

  // Additional helper methods using the constants
  String getMoodLabel(int score) => JournalMoodConstant.getMoodLabel(score);
  bool isPositiveMood(int score) => JournalMoodConstant.isPositiveMood(score);
  bool isNegativeMood(int score) => JournalMoodConstant.isNegativeMood(score);
  bool isNeutralMood(int score) => JournalMoodConstant.isNeutralMood(score);

  // Helper untuk menghitung Progress berdasarkan frekuensi
  Map<String, int> calculateProgress(String frequency) {
    final filteredGoals = allTargets
        .where((t) => t.frequency == frequency && t.isActive)
        .toList();
    final completed = filteredGoals.where((t) => t.isCompleted.value).length;
    final total = filteredGoals.length;

    return {'completed': completed, 'total': total};
  }
}

// ⚠️ Perlu menyesuaikan TargetItem agar menggunakan RxBool
// Pindahkan TargetItem dari Page ke Model/Entity layer jika belum ada
class TargetItem {
  String id;
  String title;
  String frequency;
  bool isActive;
  RxBool isCompleted; // ⬅️ Gunakan RxBool agar reaktif

  TargetItem({
    required this.id,
    required this.title,
    required this.frequency,
    this.isActive = true,
    required RxBool isCompleted,
  }) : isCompleted = isCompleted;
}
