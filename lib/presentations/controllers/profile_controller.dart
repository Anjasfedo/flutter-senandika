import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/user_repository.dart';
import 'package:senandika/data/sources/pocketbase.dart';

class ProfileController extends GetxController {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;
  final PocketBaseService _pbService = Get.find<PocketBaseService>();

  ProfileController(this._authRepository, this._userRepository);

  // --- States Reaktif untuk Informasi Profil ---
  final RxString userName = 'Pengguna Senandika'.obs;
  final RxString userEmail = 'user.senandika@email.com'.obs;
  final RxString avatarUrl = ''.obs;

  // --- States Reaktif untuk Pengaturan (Contoh) ---
  final RxString crisisContactName = "Kontak Terpercaya".obs;
  final RxString crisisContactPhone = "0812-XXXX-XXXX".obs;
  final RxBool isBiometricEnabled = true.obs;
  final RxInt dailyGoalCount = 3.obs;

  @override
  void onReady() {
    super.onReady();
    // ⬅️ Panggil load data di onReady
    loadUserProfile();
  }

  // ⬅️ Ubah menjadi method publik agar bisa dipanggil dari ProfileEditController
  void loadUserProfile() async {
    final user = _authRepository.currentUser;
    if (user != null) {
      if (user.name != userName.value ||
          user.email != userEmail.value ||
          user.avatar != null) {
        String name = user.name;
        if (name.contains('@')) {
          name = name.split('@').first;
        }
        userName.value = name;
        userEmail.value = user.email;

        // ⬅️ Logika Pembentukan URL Avatar
        if (user.avatar != null && user.avatar!.isNotEmpty) {
          // PocketBase user collection ID biasanya sama dengan 'users'
          final String collectionId = 'users';
          final String recordId = user.id;
          final String filename = user.avatar!;

          // Bentuk URL penuh menggunakan baseUrl dari PocketBaseService
          final fullUrl =
              '${_pbService.pb.baseUrl}/api/files/$collectionId/$recordId/$filename';

          avatarUrl.value = fullUrl;
        } else {
          avatarUrl.value = ''; // Kosongkan jika tidak ada avatar
        }
      }

      final contact = await _userRepository.getEmergencyContact(user.id);

      if (contact != null) {
        // Jika kontak ditemukan di database, gunakan data tersebut
        crisisContactName.value = contact.name;
        crisisContactPhone.value = contact.phone;
      } else {
        // Jika kontak belum disetel (gunakan default info/mock)
        crisisContactName.value = "Belum Disetel";
        crisisContactPhone.value = "Ketuk untuk Menyetel";
      }
    } else {
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
      // Get.snackbar(
      //   'Berhasil',
      //   'Berhasil Keluar',
      //   backgroundColor: ColorConst.primaryAccentGreen,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
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

  // Navigasi ke Edit Contact
  void goToEmergencyContact() {
    Get.toNamed(RouteConstants.profile_emergency_contact);
  }

  // Navigasi ke Goal Management
  void goToTargetHabit() {
    Get.toNamed(RouteConstants.profile_target_habit);
  }
}
