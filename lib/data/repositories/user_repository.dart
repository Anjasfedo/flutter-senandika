// lib/data/repositories/user_repository.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
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
    // ⬅️ Tambahkan File opsional
    File? avatarFile,
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
    // ⬅️ Terima file
    File? avatarFile,
  }) async {
    return _pbService
        .handleApiCall<UserModel>(() async {
          final List<http.MultipartFile> files = [];

          // 1. Siapkan data body (hanya nama)
          final body = <String, dynamic>{
            'name': name.trim(),
            // Email tidak dikirim
          };

          // 2. Siapkan file avatar jika ada
          if (avatarFile != null) {
            // PocketBase memerlukan file upload dalam format http.MultipartFile
            files.add(
              http.MultipartFile.fromBytes(
                // 'avatar' adalah nama field di koleksi PocketBase (disesuaikan jika berbeda)
                'avatar',
                avatarFile.readAsBytesSync(),
                filename: path.basename(avatarFile.path),
              ),
            );
          }

          // 3. Panggil API PocketBase untuk update record user
          final updatedRecord = await _pb
              .collection('users')
              .update(
                userId,
                body: body,
                files: files, // ⬅️ Kirim files
              );

          // Refresh sesi otentikasi
          await _authRepository.refreshAuthModel();

          return UserModel.fromRecord(updatedRecord);
        })
        .catchError((error) {
          // ... (penanganan error tetap sama)
          if (error is ClientException) {
            print(
              'PocketBase Update Profile Error: Status: ${error.statusCode}, Message: ${error.originalError}',
            );

            if (error.statusCode == 400) {
              throw Exception('Pembaruan gagal. Pastikan nama valid.');
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
