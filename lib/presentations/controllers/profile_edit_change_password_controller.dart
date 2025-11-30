import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/user_repository.dart';
import 'package:senandika/data/repositories/auth_repository.dart';

class ProfileEditChangePasswordController extends GetxController {
  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;

  ProfileEditChangePasswordController(
    this._userRepository,
    this._authRepository,
  );

  // === Form State Management ===
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool obscureOldPassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  String? get _currentUserId => _authRepository.currentUser?.id;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // --- Toggle Handlers ---
  void toggleOldPasswordVisibility() {
    obscureOldPassword.value = !obscureOldPassword.value;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // --- Handler Perubahan Sandi ---
  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (_currentUserId == null) {
      errorMessage.value = 'User ID tidak ditemukan. Silakan login kembali.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final oldPassword = oldPasswordController.text;
      final newPassword = newPasswordController.text;

      await _userRepository.changePassword(
        userId: _currentUserId!,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      // Setelah sukses, bersihkan field dan berikan feedback
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back(); // Kembali ke halaman Edit Profil

      Get.snackbar(
        'Berhasil',
        'Kata sandi Anda berhasil diperbarui.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Change Password Error: $e');
      final String errorText = e.toString();
      errorMessage.value = errorText.startsWith('Exception: ')
          ? errorText.replaceFirst('Exception: ', '')
          : 'Gagal mengubah kata sandi. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  // --- Validators ---

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName wajib diisi.';
    }
    return null;
  }

  String? validatePasswordLength(String? value) {
    if (value != null && value.length < 6) {
      return 'Kata sandi minimal 6 karakter.';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi wajib diisi.';
    }
    if (value != newPasswordController.text) {
      return 'Konfirmasi kata sandi tidak cocok.';
    }
    return null;
  }
}
