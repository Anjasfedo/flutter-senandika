import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/services/local_storage_service.dart';

class OnboardingController extends GetxController {
  // Injeksi LocalStorageService yang telah diinisialisasi
  final LocalStorageService _localStorageService =
      Get.find<LocalStorageService>();

  /// Metode yang dipanggil saat tombol "Mulai Masuk" ditekan.
  void completeOnboarding() {
    // 1. Set status first launch menjadi false
    _localStorageService.setFirstLaunchCompleted();

    // 2. Navigasi ke halaman login (menghilangkan semua rute sebelumnya)
    Get.offAllNamed(RouteConstants.login);
  }

  /// Metode yang dipanggil saat tombol "Lewati" ditekan.
  void skipOnboarding() {
    // Navigasi ke halaman login. Status first launch TIDAK perlu diubah di sini
    // karena user mungkin ingin melihat Onboarding lagi di lain waktu jika mereka
    // hanya 'melewati' dan bukan 'menyelesaikan'.
    // *Namun, jika aturannya adalah 'lewati = selesai', maka setFirstLaunchCompleted() perlu dipanggil.*
    // Untuk tujuan keamanan (user tidak melihat onboarding lagi setelah login pertama kali):
    _localStorageService.setFirstLaunchCompleted();
    Get.offAllNamed(RouteConstants.login);
  }
}
