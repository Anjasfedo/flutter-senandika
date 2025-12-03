import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/constants/color_constant.dart'; // 💡 Tambahkan import ini untuk warna

class SignUpController extends GetxController {
  final IAuthRepository _authRepository;

  SignUpController(this._authRepository);

  // === Form State Management ===
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool obscurePasswordConfirm = true.obs;
  final isLoading = false.obs;

  // ⬅️ State loading khusus Google
  final isGoogleLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }

  // 💡 HELPER BARU: Menampilkan Snackbar Error
  void _showErrorSnackbar(String message) {
    Get.snackbar('Aksi Gagal', message, duration: const Duration(seconds: 4));
  }

  // ... (Toggle visibility methods)
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void togglePasswordConfirmVisibility() {
    obscurePasswordConfirm.value = !obscurePasswordConfirm.value;
  }

  // Handler utama untuk pendaftaran Email/Password
  Future<void> handleSignUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      await _authRepository.signUp(name, email, password);

      Get.offAllNamed(RouteConstants.home);

      // 💡 TAMBAHKAN SNACKBAR SUKSES
      Get.snackbar(
        'Berhasil',
        'Akun berhasil didaftarkan.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    } catch (e) {
      print('Sign Up Error (Controller): $e');
      final String errorText = e.toString();
      String displayMessage;

      if (errorText.startsWith('Exception: ')) {
        displayMessage = errorText.replaceFirst('Exception: ', '');
      } else {
        displayMessage = 'Gagal mendaftar. Silakan coba lagi.';
      }

      // ⬅️ DIUBAH: Mengganti penetapan error reaktif dengan Snackbar
      _showErrorSnackbar(displayMessage);
    } finally {
      isLoading.value = false;
    }
  }

  // ⬅️ Handler untuk Pendaftaran/Login dengan Google
  Future<void> handleGoogleSignUp() async {
    if (isGoogleLoading.value) return;

    isGoogleLoading.value = true;

    try {
      await _authRepository.loginWithGoogle();

      // Jika berhasil (user baru dibuat atau user lama login), navigasi
      Get.offAllNamed(RouteConstants.home);

      // 💡 TAMBAHKAN SNACKBAR SUKSES GOOGLE
      Get.snackbar(
        'Berhasil',
        'Masuk dengan Google berhasil.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    } catch (e) {
      print('Google Sign Up Error (Controller): $e');
      final String errorText = e.toString();
      String displayMessage;

      if (errorText.startsWith('Exception: ')) {
        displayMessage = errorText.replaceFirst('Exception: ', '');
      } else {
        displayMessage = 'Gagal mendaftar dengan Google. Silakan coba lagi.';
      }

      // ⬅️ DIUBAH: Mengganti penetapan error reaktif dengan Snackbar
      _showErrorSnackbar(displayMessage);
    } finally {
      isGoogleLoading.value = false; // ⬅️ Matikan loading Google
    }
  }

  // Navigasi ke Login
  void goToLogin() {
    Get.offNamed(RouteConstants.login);
  }
}
