import 'dart:async';
// import 'dart:io'; // Tidak diperlukan lagi jika penanganan umum ada di PocketBaseService

import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:senandika/data/models/user_model.dart';
import 'package:senandika/data/sources/pocketbase.dart';

abstract class IAuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  bool get isAuthenticated;
  UserModel? get currentUser;
}

class AuthRepository implements IAuthRepository {
  final PocketBaseService _pbService = Get.find<PocketBaseService>();

  PocketBase get _pb => _pbService.pb;

  @override
  bool get isAuthenticated => _pb.authStore.isValid;

  @override
  UserModel? get currentUser {
    if (isAuthenticated && _pb.authStore.model is RecordModel) {
      return UserModel.fromAuthStore(_pb.authStore.model as RecordModel);
    }
    return null;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    // 1. Menggunakan handleApiCall untuk menangani error koneksi/timeout/umum
    return _pbService
        .handleApiCall<UserModel>(() async {
          // Health check tetap dilakukan, tetapi error Socket/Timeout akan ditangkap oleh wrapper.
          try {
            await _pb
                .send('/api/health', method: 'GET')
                .timeout(const Duration(seconds: 5));
          } catch (e) {
            // Jika health check gagal karena alasan non-koneksi (misalnya HTTP 404),
            // kita tetap melempar Exception koneksi yang dapat dimengerti user.
            print('Server health check failed: $e');
            throw Exception(
              'Tidak dapat terhubung ke server. Periksa koneksi internet.',
            );
          }

          // Autentikasi utama
          final authRecord = await _pb
              .collection('users')
              .authWithPassword(email.trim(), password);

          return UserModel.fromAuthStore(authRecord.record!);
        })
        .catchError((error) {
          // 2. Blok ini HANYA menangani ClientException (Error status code PocketBase)
          if (error is ClientException) {
            print(
              'PocketBase Auth Error: Status: ${error.statusCode}, Message: ${error.originalError}',
            );

            if (error.statusCode == 400) {
              throw Exception(
                'Email atau kata sandi salah. Silakan coba lagi.',
              );
            } else if (error.statusCode == 401) {
              throw Exception(
                'Autentikasi gagal. Periksa email dan kata sandi Anda.',
              );
            } else if (error.statusCode == 403) {
              throw Exception(
                'Akses ditolak. Akun mungkin belum terverifikasi.',
              );
            } else if (error.statusCode >= 500) {
              throw Exception('Server error. Silakan coba lagi nanti.');
            } else {
              throw Exception('Terjadi kesalahan: ${error.originalError}');
            }
          }

          // Melemparkan error umum (SocketException/TimeoutException/catch-all)
          // yang sudah diformat dari handleApiCall
          throw error;
        });
  }

  @override
  Future<void> logout() async {
    _pb.authStore.clear();
  }
}
