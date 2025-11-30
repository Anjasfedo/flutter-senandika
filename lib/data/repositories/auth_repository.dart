// lib/data/repositories/auth_repository.dart
import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:senandika/data/models/user_model.dart';
import 'package:senandika/data/sources/pocketbase.dart';

// Interface
abstract class IAuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  bool get isAuthenticated;
  UserModel? get currentUser;
}

// Implementasi
class AuthRepository implements IAuthRepository {
  final PocketBaseService _pbService = Get.find<PocketBaseService>();

  // Getter untuk PocketBase instance
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

  // Fungsionalitas Login
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      print('🔄 Attempting login with email: $email');
      print('🌐 Using PocketBase URL: ${_pb.baseUrl}');

      // Test basic connectivity first (without auth)
      try {
        final health = await _pb
            .send('/api/health', method: 'GET')
            .timeout(const Duration(seconds: 5));
        print('✅ Server health check passed');
      } catch (e) {
        print('❌ Server health check failed: $e');
        throw Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet.',
        );
      }

      print('📡 Proceeding with authentication...');

      // Attempt authentication
      final authRecord = await _pb
          .collection('users')
          .authWithPassword(email.trim(), password);

      print('✅ Login successful!');
      print('👤 User ID: ${authRecord.record?.id}');
      print('📧 User Email: ${authRecord.record?.getStringValue('email')}');
      print(
        '🔑 Auth Token: ${_pb.authStore.token?.substring(0, 20)}...',
      ); // Log partial token

      return UserModel.fromAuthStore(authRecord.record!);
    } on ClientException catch (e) {
      print('❌ PocketBase Auth Error:');
      print('   Status: ${e.statusCode}');
      print('   Message: ${e.originalError}');

      // Handle authentication errors
      if (e.statusCode == 400) {
        throw Exception('Email atau kata sandi salah. Silakan coba lagi.');
      } else if (e.statusCode == 401) {
        throw Exception(
          'Autentikasi gagal. Periksa email dan kata sandi Anda.',
        );
      } else if (e.statusCode == 403) {
        throw Exception('Akses ditolak. Akun mungkin belum terverifikasi.');
      } else if (e.statusCode >= 500) {
        throw Exception('Server error. Silakan coba lagi nanti.');
      } else {
        throw Exception('Terjadi kesalahan: ${e.originalError}');
      }
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
      );
    } on TimeoutException {
      throw Exception('Koneksi timeout. Silakan coba lagi.');
    } catch (e) {
      print('❌ Unexpected login error: $e');
      throw Exception('Terjadi kesalahan tak terduga. Silakan coba lagi.');
    }
  }

  // Fungsionalitas Logout
  @override
  Future<void> logout() async {
    _pb.authStore.clear();
    // Opsional: Hapus token dari penyimpanan lokal jika diperlukan
    print('User logged out. Auth store cleared.');
  }
}
