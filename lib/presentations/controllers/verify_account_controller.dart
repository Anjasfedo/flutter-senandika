import 'dart:async';

import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart'; // 💡 Diperlukan untuk Icon dan Colors
import 'package:senandika/constants/color_constant.dart'; // 💡 Diperlukan untuk Colors

class VerifyAccountController extends GetxController {
  final IAuthRepository _authRepository;

  VerifyAccountController(this._authRepository);

  final RxString userEmail = ''.obs;
  final RxBool isLoading = false.obs;

  final RxBool resendDisabled = false.obs;
  final RxInt countdown = 60.obs;
  final RxBool initialEmailSent = false.obs;

  Timer? _countdownTimer;

  // -----------------------------------------------------------
  // 💡 HELPER SNACKBAR BARU
  // -----------------------------------------------------------

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal',
      message,
      backgroundColor: ColorConst.moodNegative,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 4),
    );
  }

  void _showInfoSnackbar(String message) {
    // Menggunakan warna netral/biru untuk pesan info
    Get.snackbar(
      'Informasi',
      message,
      backgroundColor: Colors.blueGrey,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 4),
    );
  }

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

  // -----------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    userEmail.value =
        _authRepository.currentUser?.email ?? 'email tidak ditemukan';

    // Kirim email verifikasi otomatis saat page pertama kali dibuka
    _sendInitialVerificationEmail();

    startCountdown();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  // Method untuk mengirim email verifikasi pertama kali
  Future<void> _sendInitialVerificationEmail() async {
    print(
      '🔵 [_sendInitialVerificationEmail] Sending initial verification email...',
    );

    if (initialEmailSent.value) {
      print(
        '🟡 [_sendInitialVerificationEmail] Initial email already sent, skipping...',
      );
      return;
    }

    isLoading.value = true;
    // ⬅️ DIUBAH: Ganti infoMessage dengan Snackbar Info
    _showInfoSnackbar('Mengirim email verifikasi...');

    try {
      print(
        '🟡 [_sendInitialVerificationEmail] Calling requestVerification...',
      );
      await _authRepository.requestVerification(userEmail.value);

      // ⬅️ DIUBAH: Ganti infoMessage dengan Snackbar Sukses
      _showSuccessSnackbar(
        'Email verifikasi telah dikirim ke ${userEmail.value}. Silakan cek inbox email Anda.',
      );
      initialEmailSent.value = true;

      print(
        '🟢 [_sendInitialVerificationEmail] Initial verification email sent successfully',
      );
    } catch (e) {
      print(
        '🔴 [_sendInitialVerificationEmail] Failed to send initial verification: $e',
      );

      // ⬅️ DIUBAH: Panggil handler error
      _handleError(e, isInitial: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Timer untuk menonaktifkan tombol kirim ulang
  void startCountdown() {
    _countdownTimer?.cancel();

    resendDisabled.value = true;
    countdown.value = 60;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value == 0) {
        timer.cancel();
        resendDisabled.value = false;
      } else {
        countdown.value--;
      }
    });
  }

  // Handler untuk meminta pengiriman ulang verifikasi email
  Future<void> resendVerification() async {
    if (resendDisabled.value || isLoading.value) return;

    isLoading.value = true;
    _showInfoSnackbar('Mengirim ulang email verifikasi...');

    try {
      await _authRepository.requestVerification(userEmail.value);

      // ⬅️ DIUBAH: Ganti infoMessage dengan Snackbar Sukses
      _showSuccessSnackbar(
        'Email verifikasi telah dikirim ulang ke ${userEmail.value}.',
      );

      startCountdown();
    } catch (e) {
      print('Resend Verification Error: $e');
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(dynamic error, {bool isInitial = false}) {
    final String errorText = error.toString();
    String displayMessage;

    if (errorText.startsWith('Exception: ')) {
      displayMessage = errorText.replaceFirst('Exception: ', '');
    } else if (errorText.contains('timeout') || errorText.contains('Timeout')) {
      displayMessage = 'Permintaan timeout. Silakan coba lagi.';
    } else if (errorText.contains('network') || errorText.contains('socket')) {
      displayMessage = 'Tidak ada koneksi internet. Silakan cek koneksi Anda.';
    } else {
      displayMessage = isInitial
          ? 'Gagal mengirim email verifikasi awal. Silakan coba kirim ulang.'
          : 'Gagal mengirim ulang verifikasi. Silakan coba lagi.';
    }
    // ⬅️ DIUBAH: Menampilkan error menggunakan Snackbar
    _showErrorSnackbar(displayMessage);
  }

  // Memuat ulang status user
  Future<void> checkVerificationStatus() async {
    isLoading.value = true;
    _showInfoSnackbar('Memeriksa status verifikasi...');

    try {
      // 1. Refresh data pengguna dari server
      await _authRepository.refreshAuthModel();

      // 2. Cek status 'verified' yang baru
      final currentUser = _authRepository.currentUser;

      if (currentUser != null && currentUser.verified) {
        // Jika VERIFIKASI BERHASIL

        // ⬅️ DIUBAH: Ganti infoMessage dengan Snackbar Sukses
        _showSuccessSnackbar(
          'Akun berhasil diverifikasi! Mengarahkan ke Home...',
        );

        // Tunggu sebentar untuk menampilkan pesan sukses
        await Future.delayed(const Duration(seconds: 1));

        // Navigasi ke home
        Get.offAllNamed(RouteConstants.home);
      } else {
        // Jika verifikasi masih FALSE

        // ⬅️ DIUBAH: Menampilkan error menggunakan Snackbar
        _showErrorSnackbar(
          'Verifikasi belum berhasil. Pastikan Anda sudah mengklik tautan di email.',
        );
        // infoMessage.value = ''; // Hapus pesan info lama jika ada
      }
    } catch (e) {
      print('Check Verification Error: $e');

      final String errorText = e.toString();
      String displayMessage;

      if (errorText.startsWith('Exception: ')) {
        displayMessage = errorText.replaceFirst('Exception: ', '');
      } else {
        displayMessage =
            'Gagal memeriksa status verifikasi. Silakan coba lagi.';
      }

      // ⬅️ DIUBAH: Menampilkan error menggunakan Snackbar
      _showErrorSnackbar(displayMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void handleLogout() {
    _countdownTimer?.cancel();
    _authRepository.logout();
    Get.offAllNamed(RouteConstants.login);
  }
}
