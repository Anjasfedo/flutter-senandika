import 'dart:async';
import 'dart:io'; // Perlu diimport untuk SocketException
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseService extends GetxService {
  late final PocketBase pb;

  Future<PocketBaseService> init() async {
    // Dipanggil saat Get.putAsync
    pb = PocketBase(
      'http://pocketbase-z000koccok0o800wcsos0k44.103.197.190.23.sslip.io',
    );
    // Jalankan health check jika diperlukan
    await testConnection();
    return this;
  }

  /// Helper function untuk menangani error umum (koneksi, timeout, tak terduga)
  /// yang terjadi selama panggilan API.
  Future<T> handleApiCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
      );
    } on TimeoutException {
      throw Exception('Koneksi timeout. Silakan coba lagi.');
    } catch (e) {
      // Catch-all untuk error yang tidak terduga
      print('Unexpected API error: $e');
      throw Exception('Terjadi kesalahan tak terduga. Silakan coba lagi.');
    }
  }

  Future<bool> testConnection() async {
    // Membungkus panggilan API dengan handleApiCall
    return handleApiCall<bool>(() async {
      final response = await pb
          .send('/api/health', method: 'GET')
          .timeout(const Duration(seconds: 10));

      // Jika respons sukses, cek kode status
      if (response.statusCode == 401) {
        // 401 dianggap sukses untuk health check jika server merespons
        return true;
      }
      return true;
    }).catchError((e) {
      // Menangkap Exception yang dilempar oleh handleApiCall
      if (e is ClientException) {
        // Menangani ClientException yang spesifik dari PocketBase
        if (e.statusCode == 401) return true;
        print('Connection failed: ${e.statusCode} - ${e.originalError}');
      }
      return false;
    });
  }
}
