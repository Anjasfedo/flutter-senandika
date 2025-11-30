import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/entities/user_entity.dart';

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
  final errorMessage = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
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
    errorMessage.value = '';

    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      final userModel = await _authRepository.signUp(name, email, password);

      Get.offAllNamed(RouteConstants.home);
    } catch (e) {
      print('Sign Up Error (Controller): $e');
      final String errorText = e.toString();
      if (errorText.startsWith('Exception: ')) {
        errorMessage.value = errorText.replaceFirst('Exception: ', '');
      } else {
        errorMessage.value = 'Gagal mendaftar. Silakan coba lagi.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ⬅️ Handler untuk Pendaftaran/Login dengan Google
  Future<void> handleGoogleSignUp() async {
    if (isGoogleLoading.value) return;

    isGoogleLoading.value = true; // ⬅️ Atur loading Google
    errorMessage.value = '';

    try {
      // Menggunakan handler login Google yang sama di Repository
      final userModel = await _authRepository.loginWithGoogle();

      // Jika berhasil (user baru dibuat atau user lama login), navigasi
      Get.offAllNamed(RouteConstants.home);
    } catch (e) {
      print('Google Sign Up Error (Controller): $e');
      final String errorText = e.toString();
      if (errorText.startsWith('Exception: ')) {
        errorMessage.value = errorText.replaceFirst('Exception: ', '');
      } else {
        errorMessage.value =
            'Gagal mendaftar dengan Google. Silakan coba lagi.';
      }
    } finally {
      isGoogleLoading.value = false; // ⬅️ Matikan loading Google
    }
  }

  // Navigasi ke Login
  void goToLogin() {
    Get.offNamed(RouteConstants.login);
  }
}
