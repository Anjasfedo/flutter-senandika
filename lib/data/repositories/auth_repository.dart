import 'dart:async';
import 'package:pocketbase/pocketbase.dart';
import 'package:senandika/data/models/user_model.dart';
import 'package:senandika/data/sources/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class IAuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  bool get isAuthenticated;
  UserModel? get currentUser;
  Future<void> requestPasswordReset(String email);
  Future<UserModel> loginWithGoogle();
}

class AuthRepository implements IAuthRepository {
  final PocketBaseService _pbService;

  PocketBase get _pb => _pbService.pb;

  AuthRepository(this._pbService);

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
    return _pbService
        .handleApiCall<UserModel>(() async {
          // Health check
          try {
            await _pb
                .send('/api/health', method: 'GET')
                .timeout(const Duration(seconds: 5));
          } catch (e) {
            print('Server health check failed: $e');
            throw Exception(
              'Tidak dapat terhubung ke server. Periksa koneksi internet.',
            );
          }

          // Autentikasi utama - Jika gagal, ini melempar ClientException
          final authRecord = await _pb
              .collection('users')
              .authWithPassword(email.trim(), password);

          return UserModel.fromAuthStore(
            authRecord.record!,
          ); // Pastikan ini tidak null
        })
        .catchError((error) {
          // ⬅️ ClientException DITANGKAP DI SINI, tempat yang TEPAT
          if (error is ClientException) {
            print(
              'PocketBase Auth Error: Status: ${error.statusCode}, Message: ${error.originalError}',
            );

            if (error.statusCode == 400) {
              throw Exception(
                'Email atau kata sandi salah. Silakan coba lagi.', // ⬅️ Pesan yang benar
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

          // Melemparkan error umum (misalnya SocketException dari handleApiCall)
          throw error;
        });
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    return _pbService
        .handleApiCall<void>(() async {
          // Panggil API PocketBase untuk meminta reset password
          await _pb.collection('users').requestPasswordReset(email.trim());
        })
        .catchError((error) {
          // Menangani error PocketBase spesifik (ClientException)
          if (error is ClientException) {
            print(
              'PocketBase Reset Error: Status: ${error.statusCode}, Message: ${error.originalError}',
            );

            // 400: Validasi gagal (misal: email tidak ditemukan)
            if (error.statusCode == 400) {
              // PocketBase mengirim 400 meskipun email tidak ditemukan untuk alasan keamanan,
              // tetapi kita bisa memberikan pesan yang lebih spesifik jika validasi form gagal.
              throw Exception(
                'Email tidak terdaftar atau ada masalah validasi.',
              );
            } else if (error.statusCode >= 500) {
              throw Exception('Server error. Silakan coba lagi nanti.');
            } else {
              throw Exception('Terjadi kesalahan saat meminta reset password.');
            }
          }
          // Melempar error umum (Socket/Timeout) dari handleApiCall
          throw error;
        });
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    // Menggunakan handleApiCall untuk menangani error koneksi/timeout/umum
    return _pbService
        .handleApiCall<UserModel>(() async {
          // Menggunakan url_launcher untuk membuka halaman autentikasi Google
          final authData = await _pb.collection('users').authWithOAuth2(
            'google',
            (url) async {
              await launchUrl(url);
            },
          );

          return UserModel.fromAuthStore(authData.record);
        })
        .catchError((error) {
          // Menangani error PocketBase spesifik (ClientException)
          if (error is ClientException) {
            print(
              'PocketBase OAuth2 Error: Status: ${error.statusCode}, Message: ${error.originalError}',
            );

            // Error saat OAuth2 (misalnya, PocketBase tidak terhubung ke Google dengan benar)
            throw Exception(
              'Gagal melakukan autentikasi Google. Mohon coba lagi atau hubungi admin.',
            );
          }
          // Melempar error umum (Socket/Timeout) dari handleApiCall
          throw error;
        });
  }

  @override
  Future<void> logout() async {
    _pb.authStore.clear();
  }
}
