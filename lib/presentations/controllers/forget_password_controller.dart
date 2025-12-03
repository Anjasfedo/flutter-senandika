import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/constants/color_constant.dart'; // 💡 Tambahkan import ini untuk warna

class ForgetPasswordController extends GetxController {
  final IAuthRepository _authRepository;

  ForgetPasswordController(this._authRepository);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // 💡 HELPER BARU: Menampilkan Snackbar Error
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal',
      message,
      duration: const Duration(seconds: 4),
    );
  }

  // 💡 HELPER BARU: Menampilkan Snackbar Sukses/Info
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

  // Handler utama untuk mengirim permintaan reset
  Future<void> sendResetRequest() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final email = emailController.text.trim();

      // Panggil Repository
      await _authRepository.requestPasswordReset(email);

      // ⬅️ DIUBAH: Ganti penetapan infoMessage dengan Snackbar
      final successMessage =
          'Tautan reset kata sandi telah dikirim ke $email. Silakan periksa email Anda.';

      _showSuccessSnackbar(successMessage);

      // Opsional: Langsung arahkan pengguna ke Login setelah beberapa detik
      Future.delayed(const Duration(seconds: 4), () {
        Get.offNamed(RouteConstants.login);
      });
    } catch (e) {
      print('Reset Password Error: $e');

      final String errorText = e.toString();
      String displayMessage;

      if (errorText.startsWith('Exception: ')) {
        displayMessage = errorText.replaceFirst('Exception: ', '');
      } else {
        displayMessage = 'Gagal mengirim permintaan. Silakan coba lagi.';
      }

      _showErrorSnackbar(displayMessage);
    } finally {
      isLoading.value = false;
    }
  }

  // Validator untuk input email (tetap sama)
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi.';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid.';
    }
    return null;
  }
}
