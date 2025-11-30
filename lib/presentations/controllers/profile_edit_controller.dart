// lib/presentations/controllers/profile_edit_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/user_repository.dart';
import 'package:senandika/presentations/controllers/profile_controller.dart';

class ProfileEditController extends GetxController {
  final IUserRepository _userRepository;
  final IAuthRepository
  _authRepository; // Digunakan untuk mendapatkan ID dan data awal

  ProfileEditController(this._userRepository, this._authRepository);

  // === Form State Management ===
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Data Awal User
  String _currentUserId = '';
  String _initialEmail = '';

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    final user = _authRepository.currentUser;
    if (user != null) {
      _currentUserId = user.id;
      _initialEmail = user.email;

      // Isi Controller dengan data yang sudah login
      nameController.text = user.name;
      emailController.text = user.email;
    } else {
      // Jika tidak ada user, alihkan kembali ke login
      Get.offAllNamed(RouteConstants.login);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // --- Handlers ---

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Cek apakah ada perubahan
    if (nameController.text == _authRepository.currentUser?.name &&
        emailController.text == _initialEmail) {
      Get.snackbar(
        'Informasi',
        'Tidak ada perubahan yang terdeteksi.',
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _userRepository.updateProfile(
        userId: _currentUserId,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
      );

      // Setelah sukses, perbarui data awal yang disimpan
      _initialEmail = emailController.text.trim();

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadUserProfile();
      }

      // ⬅️ Kembali ke halaman Profile utama (Gunakan Get.back())
      Get.back();

      // Kembali ke halaman Profile utama
      Get.toNamed(RouteConstants.profile);

      Get.snackbar(
        'Berhasil',
        'Perubahan profil berhasil disimpan.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Update Profile Error: $e');
      final String errorText = e.toString();
      errorMessage.value = errorText.startsWith('Exception: ')
          ? errorText.replaceFirst('Exception: ', '')
          : 'Gagal menyimpan profil. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  void goToChangePassword() {
    Get.toNamed(RouteConstants.profile_edit_change_password);
  }

  // --- Validators ---
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Mohon masukkan email yang valid';
    }
    return null;
  }
}
