// lib/data/repositories/user_repository.dart

import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:senandika/data/models/user_model.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/sources/pocketbase.dart';

// Interface
abstract class IUserRepository {
  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    required String email,
  });

  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });
}

// Implementasi
class UserRepository implements IUserRepository {
  final PocketBaseService _pbService;
  final IAuthRepository _authRepository;

  PocketBase get _pb => _pbService.pb;

  UserRepository(this._pbService, this._authRepository);

  @override
  Future<UserModel> updateProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    // Menggunakan handleApiCall untuk menangani error koneksi/timeout/umum
    return _pbService
        .handleApiCall<UserModel>(() async {
          // Data yang akan dikirim untuk pembaruan
          final body = <String, dynamic>{
            'name': name.trim(),
            'email': email.trim(),
            // Note: Password tidak dikirim di sini
          };

          // Panggil API PocketBase untuk update record user
          final updatedRecord = await _pb
              .collection('users')
              .update(userId, body: body);

          // Setelah pembaruan data berhasil, kita perlu me-refresh sesi otentikasi
          // agar data 'currentUser' di AuthRepository mencerminkan perubahan ini.
          // Kita bisa memanggil authRefresh di sini atau melalui method di AuthRepository.
          await _authRepository.refreshAuthModel();

          return UserModel.fromRecord(updatedRecord);
        })
        .catchError((error) {
          if (error is ClientException) {
            print(
              'PocketBase Update Profile Error: Status: ${error.statusCode}, Message: ${error.originalError}',
            );

            if (error.statusCode == 400) {
              // Error validasi (misal: email sudah digunakan user lain, format salah)
              throw Exception(
                'Pembaruan gagal. Pastikan email belum terdaftar oleh orang lain.',
              );
            } else if (error.statusCode >= 500) {
              throw Exception('Server error. Silakan coba lagi nanti.');
            } else {
              throw Exception('Terjadi kesalahan saat menyimpan profil.');
            }
          }
          throw error;
        });
  }

  @override
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    // Menggunakan handleApiCall untuk menangani error koneksi/timeout/umum
    return _pbService
        .handleApiCall<void>(() async {
          // Data yang akan dikirim untuk perubahan sandi
          final body = <String, dynamic>{
            'oldPassword': oldPassword,
            'password': newPassword,
            'passwordConfirm': newPassword, // PocketBase memerlukan konfirmasi
          };

          // Panggil API PocketBase untuk update record user
          // Ini akan memicu verifikasi oldPassword di PocketBase
          await _pb.collection('users').update(userId, body: body);
        })
        .catchError((error) {
          if (error is ClientException) {
            print(
              'PocketBase Change Password Error: Status: ${error.statusCode}, Message: ${error.originalError}',
            );

            if (error.statusCode == 400) {
              // 400 seringkali berarti oldPassword salah atau password baru tidak memenuhi syarat
              throw Exception(
                'Gagal. Pastikan kata sandi lama Anda benar dan kata sandi baru minimal 6 karakter.',
              );
            } else if (error.statusCode >= 500) {
              throw Exception('Server error. Silakan coba lagi nanti.');
            } else {
              throw Exception('Terjadi kesalahan saat mengubah kata sandi.');
            }
          }
          throw error;
        });
  }
}
