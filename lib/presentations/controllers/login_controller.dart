import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final errorMessage = ''.obs;
  final user = Rxn<UserModel>();

  void handleLogin() {
    if (loginFormKey.currentState!.validate()) {
      login(emailController.text, passwordController.text);
    }
  }

  // Logika utama untuk autentikasi
  Future<void> login(String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userModel = await _authRepository.login(email, password);

      user.value = userModel;

      Get.offAllNamed(RouteConstants.home);
    } catch (e) {
      // 🎯 Penanganan Error yang lebih bersih
      // Karena Repository sudah melempar Exception yang diformat:
      print('Login Error (Controller): $e');

      // Memastikan pesan error diambil dengan benar, menghilangkan "Exception: " jika ada.
      final String errorText = e.toString();
      if (errorText.startsWith('Exception: ')) {
        errorMessage.value = errorText.replaceFirst('Exception: ', '');
      } else {
        errorMessage.value = 'Gagal Masuk. Silakan coba lagi.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleGoogleLogin() async {
    if (isGoogleLoading.value) return;

    isGoogleLoading.value = true; // ⬅️ Menggunakan isGoogleLoading
    errorMessage.value = '';

    try {
      final userModel = await _authRepository.loginWithGoogle();
      user.value = userModel;
      Get.offAllNamed(RouteConstants.home);
    } catch (e) {
      print('Google Login Error (Controller): $e');
      final String errorText = e.toString();
      if (errorText.startsWith('Exception: ')) {
        errorMessage.value = errorText.replaceFirst('Exception: ', '');
      } else {
        errorMessage.value = 'Gagal masuk melalui Google. Silakan coba lagi.';
      }
    } finally {
      isGoogleLoading.value = false; // ⬅️ Menggunakan isGoogleLoading
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
    Get.toNamed(RouteConstants.forget_password); // ⬅️ Arahkan ke rute baru
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
