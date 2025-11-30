import 'dart:async';
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
  Future<void> logout() async {
    _pb.authStore.clear();
  }
}
