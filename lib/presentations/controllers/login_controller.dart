import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/models/user_model.dart';
import 'package:senandika/data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final IAuthRepository _authRepository;

  LoginController(this._authRepository);

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final RxBool obscurePassword = true.obs;
  final RxBool rememberMe = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  final user = Rxn<UserModel>();

  // 💡 HELPER BARU: Menampilkan Snackbar Error
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal Masuk',
      message,
      duration: const Duration(seconds: 4),
    );
  }

  void handleLogin() {
    if (loginFormKey.currentState!.validate()) {
      login(emailController.text, passwordController.text);
    }
  }

  // Logika utama untuk autentikasi
  Future<void> login(String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final userModel = await _authRepository.login(email, password);

      user.value = userModel;

      Get.offAllNamed(RouteConstants.home);
      Get.snackbar(
        'Berhasil',
        'Login berhasil. Selamat datang!',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    } catch (e) {
      print('Login Error (Controller): $e');

      final String errorText = e.toString();
      String displayMessage;

      if (errorText.startsWith('Exception: ')) {
        displayMessage = errorText.replaceFirst('Exception: ', '');
      } else {
        displayMessage = 'Gagal Masuk. Silakan coba lagi.';
      }

      // ⬅️ DIUBAH: Mengganti penetapan error reaktif dengan Snackbar
      _showErrorSnackbar(displayMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleGoogleLogin() async {
    if (isGoogleLoading.value) return;

    isGoogleLoading.value = true;

    try {
      final userModel = await _authRepository.loginWithGoogle();
      user.value = userModel;
      Get.offAllNamed(RouteConstants.home);
      Get.snackbar(
        'Berhasil',
        'Login Google berhasil. Selamat datang!',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    } catch (e) {
      print('Google Login Error (Controller): $e');
      final String errorText = e.toString();
      String displayMessage;

      if (errorText.startsWith('Exception: ')) {
        displayMessage = errorText.replaceFirst('Exception: ', '');
      } else {
        displayMessage = 'Gagal masuk melalui Google. Silakan coba lagi.';
      }

      // ⬅️ DIUBAH: Mengganti penetapan error reaktif dengan Snackbar
      _showErrorSnackbar(displayMessage);
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }

  void goToSignUp() {
    Get.toNamed(RouteConstants.sign_up);
  }

  void goToForgotPassword() {
    Get.toNamed(RouteConstants.forget_password);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    if (_authRepository.isAuthenticated) {
      final currentUserModel = _authRepository.currentUser;
      if (currentUserModel != null) {
        user.value = currentUserModel;
        Future.microtask(() => Get.offAllNamed(RouteConstants.home));
      }
    }
  }
}
