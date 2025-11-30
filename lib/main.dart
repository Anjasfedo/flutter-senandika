import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/sources/pocketbase.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting app initialization...');

  // 1. Initialize SharedPreferences as GetX Service
  await Get.putAsync(() => LocalStorageService.init());

  // 2. Initialize other services
  await Get.putAsync(() => PocketBaseService().init());
  Get.lazyPut<IAuthRepository>(
    () => AuthRepository(Get.find<PocketBaseService>()),
  );

  // 3. Debug: Print current state
  final localStorageService = Get.find<LocalStorageService>();
  localStorageService.debugPrintState();

  // 4. Determine initial route
  final String initialRoute = _getInitialRoute(localStorageService);
  print('🎯 Initial route determined: $initialRoute');

  runApp(MyApp(initialRoute: initialRoute));
}

String _getInitialRoute(LocalStorageService localStorageService) {
  // Debug current state
  print('🔍 Determining initial route:');
  print('   - isFirstLaunch: ${localStorageService.isFirstLaunch}');
  print('   - isAppInitialized: ${localStorageService.isAppInitialized}');

  if (localStorageService.isFirstLaunch) {
    print('   ➡️ Going to ONBOARDING (first launch)');
    return RouteConstants.onboarding;
  }

  // Check authentication
  final IAuthRepository authRepository = Get.find<IAuthRepository>();
  print('   - isAuthenticated: ${authRepository.isAuthenticated}');

  if (authRepository.isAuthenticated) {
    print('   ➡️ Going to HOME (authenticated)');
    return RouteConstants.home;
  }

  print('   ➡️ Going to LOGIN (not first launch, not authenticated)');
  return RouteConstants.login;
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      getPages: AppPages.pages,
      initialRoute: initialRoute,
    );
  }
}
