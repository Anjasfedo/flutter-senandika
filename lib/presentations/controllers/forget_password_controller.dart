import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';

class ForgetPasswordController extends GetxController {
  final IAuthRepository _authRepository;

  ForgetPasswordController(this._authRepository);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final isLoading = false.obs;
  final infoMessage = ''.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Handler utama untuk mengirim permintaan reset
  Future<void> sendResetRequest() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    infoMessage.value = '';

    try {
      final email = emailController.text.trim();

      // Panggil Repository
      await _authRepository.requestPasswordReset(email);

      // Pesan sukses yang user-friendly
      infoMessage.value =
          'Tautan reset kata sandi telah dikirim ke $email. Silakan periksa email Anda.';

      // Opsional: Langsung arahkan pengguna ke Login setelah beberapa detik
      Future.delayed(const Duration(seconds: 4), () {
        Get.offNamed(RouteConstants.login);
      });
    } catch (e) {
      print('Reset Password Error: $e');
      // Menampilkan pesan error dari Repository
      final String errorText = e.toString();
      if (errorText.startsWith('Exception: ')) {
        errorMessage.value = errorText.replaceFirst('Exception: ', '');
      } else {
        errorMessage.value = 'Gagal mengirim permintaan. Silakan coba lagi.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Validator untuk input email
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
