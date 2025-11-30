import 'dart:async';

import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';

class VerifyAccountController extends GetxController {
  final IAuthRepository _authRepository;

  VerifyAccountController(this._authRepository);

  final RxString userEmail = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString infoMessage = ''.obs;
  final RxBool resendDisabled = false.obs;
  final RxInt countdown = 60.obs;
  final RxBool initialEmailSent = false.obs; // Tambahkan ini

  Timer? _countdownTimer;

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
    infoMessage.value = 'Mengirim email verifikasi...';

    try {
      print(
        '🟡 [_sendInitialVerificationEmail] Calling requestVerification...',
      );
      await _authRepository.requestVerification(userEmail.value);

      infoMessage.value =
          'Email verifikasi telah dikirim ke ${userEmail.value}. Silakan cek inbox email Anda.';
      initialEmailSent.value = true;

      print(
        '🟢 [_sendInitialVerificationEmail] Initial verification email sent successfully',
      );
    } catch (e) {
      print(
        '🔴 [_sendInitialVerificationEmail] Failed to send initial verification: $e',
      );
      errorMessage.value =
          'Gagal mengirim email verifikasi awal. Silakan coba kirim ulang.';
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
    errorMessage.value = '';
    infoMessage.value = 'Mengirim ulang email verifikasi...';

    try {
      await _authRepository.requestVerification(userEmail.value);
      infoMessage.value =
          'Email verifikasi telah dikirim ulang ke ${userEmail.value}.';
      startCountdown();
    } catch (e) {
      print('Resend Verification Error: $e');
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(dynamic error) {
    final String errorText = error.toString();

    if (errorText.startsWith('Exception: ')) {
      errorMessage.value = errorText.replaceFirst('Exception: ', '');
    } else if (errorText.contains('timeout') || errorText.contains('Timeout')) {
      errorMessage.value = 'Permintaan timeout. Silakan coba lagi.';
    } else if (errorText.contains('network') || errorText.contains('socket')) {
      errorMessage.value =
          'Tidak ada koneksi internet. Silakan cek koneksi Anda.';
    } else {
      errorMessage.value =
          'Gagal mengirim ulang verifikasi. Silakan coba lagi.';
    }
  }

  // Memuat ulang status user
  Future<void> checkVerificationStatus() async {
    isLoading.value = true;
    errorMessage.value = '';
    infoMessage.value = 'Memeriksa status verifikasi...';

    try {
      // 1. Refresh data pengguna dari server
      await _authRepository.refreshAuthModel();

      // 2. Cek status 'verified' yang baru
      final currentUser = _authRepository.currentUser;

      if (currentUser != null && currentUser.verified) {
        // Jika VERIFIKASI BERHASIL
        infoMessage.value = 'Akun berhasil diverifikasi!';

        // Tunggu sebentar untuk menampilkan pesan sukses
        await Future.delayed(const Duration(seconds: 1));

        // Navigasi ke home
        Get.offAllNamed(RouteConstants.home);
      } else {
        // Jika verifikasi masih FALSE
        errorMessage.value =
            'Verifikasi belum berhasil. Pastikan Anda sudah mengklik tautan di email.';
        infoMessage.value = ''; // Hapus pesan info lama jika ada
      }
    } catch (e) {
      print('Check Verification Error: $e');
      // Jika refresh gagal (misal: sesi kedaluwarsa), AuthRepository akan melempar Exception yang sesuai.
      final String errorText = e.toString();
      if (errorText.startsWith('Exception: ')) {
        errorMessage.value = errorText.replaceFirst('Exception: ', '');
      } else {
        errorMessage.value =
            'Gagal memeriksa status verifikasi. Silakan coba lagi.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  void handleLogout() {
    _countdownTimer?.cancel();
    _authRepository.logout();
    Get.offAllNamed(RouteConstants.login);
  }

  void clearMessages() {
    errorMessage.value = '';
    infoMessage.value = '';
  }
}
