import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  final int? priority = 1;

  final IAuthRepository _authRepository = Get.find<IAuthRepository>();

  @override
  RouteSettings? redirect(String? route) {
    // 1. Jika belum login, alihkan ke login
    if (!_authRepository.isAuthenticated) {
      return const RouteSettings(name: RouteConstants.login);
    }

    final currentUser = _authRepository.currentUser;

    // 2. Jika sudah login, tetapi belum terverifikasi
    if (currentUser != null && !currentUser.verified) {
      // Kecualikan rute verifikasi itu sendiri agar tidak terjadi loop tak terbatas
      if (route != RouteConstants.verify_account) {
        print(
          'Middleware: Pengguna terautentikasi tetapi belum terverifikasi, mengalihkan ke Verifikasi.',
        );
        return const RouteSettings(name: RouteConstants.verify_account);
      }
    }

    // 3. Sudah login dan terverifikasi, lanjutkan
    return null;
  }
}
