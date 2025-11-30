import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final IAuthRepository _authRepository;

  ProfileController(this._authRepository);

  // --- States Reaktif untuk Informasi Profil ---
  final RxString userName = 'Pengguna Senandika'.obs;
  final RxString userEmail = 'user.senandika@email.com'.obs;

  // --- States Reaktif untuk Pengaturan (Contoh) ---
  final RxString crisisContactName = "Kontak Terpercaya".obs;
  final RxString crisisContactPhone = "0812-XXXX-XXXX".obs;
  final RxBool isBiometricEnabled = true.obs;
  final RxBool isJournalMandatory = true.obs;
  final RxInt dailyGoalCount = 3.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = _authRepository.currentUser;
    if (user != null) {
      // Asumsikan UserModel memiliki getter 'name' dan 'email'
      String name = user.name;
      // Opsional: bersihkan nama jika berupa email
      if (name.contains('@')) {
        name = name.split('@').first;
      }
      userName.value = name;
      userEmail.value = user.email;
    } else {
      // Jika tidak ada user (meski seharusnya tidak terjadi karena AuthMiddleware)
      // Navigasi ke login
      handleLogout();
    }
  }

  // --- Handler Logout ---
  Future<void> handleLogout() async {
    try {
      // Panggil repository untuk membersihkan token
      await _authRepository.logout();

      // Navigasi ke halaman login dan hapus semua rute sebelumnya
      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      print('Logout Error: $e');
      // Tampilkan error jika diperlukan (misalnya, gagal menghapus data lokal)
      Get.snackbar('Kesalahan', 'Gagal keluar. Silakan coba lagi.');
    }
  }

  // --- Toggle Handlers (Dipanggil dari SwitchListTile) ---
  void toggleBiometric(bool newValue) {
    isBiometricEnabled.value = newValue;
    // Logika simpan ke database/local storage
  }

  void toggleJournalMandatory(bool newValue) {
    isJournalMandatory.value = newValue;
    // Logika simpan ke database/local storage
  }

  // Navigasi ke Edit Contact
  void goToEmergencyContact() {
    Get.toNamed(RouteConstants.profile_emergency_contact);
  }

  // Navigasi ke Goal Management
  void goToTargetHabit() {
    Get.toNamed(RouteConstants.profile_target_habit);
  }
}
