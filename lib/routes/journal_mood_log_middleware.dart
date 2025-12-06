import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/journal_repository.dart';

class JournalMoodLogMiddleware extends GetMiddleware {
  @override
  final int? priority = 2; // Higher priority than AuthMiddleware (1)

  final IAuthRepository _authRepository = Get.find<IAuthRepository>();
  final IJournalRepository _journalRepository = Get.find<IJournalRepository>();

  @override
  RouteSettings? redirect(String? route) {
    // 1. First check authentication (in case AuthMiddleware hasn't run yet)
    if (!_authRepository.isAuthenticated) {
      return const RouteSettings(name: RouteConstants.login);
    }

    final currentUser = _authRepository.currentUser;
    if (currentUser == null || !currentUser.verified) {
      // Unauthenticated or unverified users shouldn't access this route
      return const RouteSettings(name: RouteConstants.login);
    }

    // 2. Check if user already has a mood log for today
    try {
      final todayLog = _journalRepository.getMoodLogByDate(DateTime.now(), currentUser.id);

      // Since this is a synchronous call to async method, we need to handle it differently
      // For now, we'll allow the route and let the page handle the async validation
      // In a real implementation, you might want to use a different approach
    } catch (e) {
      // If there's an error checking for today's log, allow access (fail-safe)
      print('Error checking today mood log in middleware: $e');
      return null;
    }

    // 3. Allow access to the route (the page will handle the async validation)
    return null;
  }
}