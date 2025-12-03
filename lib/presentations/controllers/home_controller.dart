import 'package:get/get.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/sources/pocketbase.dart';

class HomeController extends GetxController {
  final IAuthRepository _authRepository;
  final PocketBaseService _pbService = Get.find<PocketBaseService>();

  HomeController(this._authRepository);

  // States Reaktif
  final RxString userName = 'Pengguna Senandika'.obs;
  final RxInt moodScore = 4.obs; // Mock Mood Score
  final RxString avatarUrl = ''.obs;

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

  // Mengambil data saat Controller dibuat
  @override
  void onInit() {
    super.onInit();
    _loadUserData(); // ⬅️ Ganti nama method menjadi _loadUserData
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
        return '⚪';
    }
  }

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
