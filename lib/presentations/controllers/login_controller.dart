import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/entities/user_entity.dart';
import 'package:senandika/data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final IAuthRepository _authRepository;

  LoginController(this._authRepository);

  // === Form State Management (Dipindahkan dari Page) ===
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Menggunakan RxBool untuk state Checkbox agar reaktif
  final RxBool obscurePassword = true.obs;
  final RxBool rememberMe = false.obs;

  // TextEditingController dipindahkan ke Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // States Reaktif
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final user = Rxn<UserEntity>();

  // Metode yang dipanggil dari UI saat tombol 'Masuk' ditekan
  void handleLogin() {
    // 1. Validasi Form
    if (loginFormKey.currentState!.validate()) {
      // 2. Panggil logika login utama
      login(emailController.text, passwordController.text);
    }
  }

  // Logika utama untuk autentikasi
  Future<void> login(String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Panggil Repository untuk Autentikasi
      final userModel = await _authRepository.login(email, password);

      // Konversi Model ke Entity dan simpan state
      user.value = UserEntity.fromModel(userModel);

      // Navigasi ke halaman utama
      Get.offAllNamed(RouteConstants.home);
    } catch (e) {
      // Tangani error dan tampilkan pesan
      print('Login Error (Controller): $e');
      errorMessage.value = e.toString().contains("Exception: ")
          ? e.toString().replaceFirst("Exception: ", "")
          : 'Gagal Masuk. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle visibility password
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Toggle remember me checkbox
  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }

  // Metode untuk menangani registrasi (navigasi)
  void goToSignUp() {
    Get.toNamed(RouteConstants.sign_up);
  }

  // Metode untuk menangani lupa sandi (navigasi)
  void goToForgotPassword() {
    // Implementasi navigasi ke Forgot Password
    print("Navigasi ke Lupa Sandi");
  }

  // Cleanup controllers
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Cek otentikasi saat controller pertama kali dibuat (opsional)
  @override
  void onInit() {
    super.onInit();
    // Jika pengguna sudah terautentikasi (misal, token masih valid)
    if (_authRepository.isAuthenticated) {
      final currentUserModel = _authRepository.currentUser;
      if (currentUserModel != null) {
        user.value = UserEntity.fromModel(currentUserModel);
        // Langsung navigasi ke Home
        Future.microtask(() => Get.offAllNamed(RouteConstants.home));
      }
    }
  }
}
