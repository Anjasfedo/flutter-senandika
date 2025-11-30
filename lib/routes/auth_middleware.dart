import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
// Pastikan path ke IAuthRepository benar

class AuthMiddleware extends GetMiddleware {
  // Memberikan nilai priority agar middleware ini berjalan dengan urutan yang tepat
  @override
  final int? priority = 1;

  // Mendapatkan instance AuthRepository melalui Get.find()
  final IAuthRepository _authRepository = Get.find<IAuthRepository>();

  // Metode yang dipanggil sebelum rute divalidasi
  @override
  RouteSettings? redirect(String? route) {
    // Jika pengguna TIDAK terautentikasi
    if (!_authRepository.isAuthenticated) {
      // Mengalihkan pengguna ke halaman login
      return const RouteSettings(name: RouteConstants.login);
    }

    // Jika terautentikasi, biarkan navigasi berlanjut
    return null;
  }
}
