import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/sources/pocketbase.dart';
import 'package:senandika/presentations/bindings/app_binding.dart';
import 'package:senandika/presentations/bindings/login_binding.dart';
import 'package:senandika/data/repositories/auth_repository.dart'; // Asumsikan IAuthRepository & AuthRepository ada
import 'package:senandika/services/local_storage_service.dart'; // Import service Anda

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => PocketBaseService().init());
  
  // 2. Inisialisasi dan put LocalStorageService (Karena Logic Onboarding/Controller mungkin membutuhkannya)
  final localStorageService = await Get.putAsync(
    () => LocalStorageService().init(),
  );

  // 3. Put AuthRepository, menggunakan Get.find() yang sekarang dapat menemukan PocketBaseService
  Get.lazyPut<IAuthRepository>(
    () => AuthRepository(Get.find<PocketBaseService>()),
  );

  // 3. Tentukan rute awal berdasarkan status first launch dan authentication
  final String initialRoute = _getInitialRoute(localStorageService);

  runApp(MyApp(initialRoute: initialRoute));
}

// Fungsi penentuan rute awal yang aman
String _getInitialRoute(LocalStorageService localStorageService) {
  // 1. Cek status Onboarding
  if (localStorageService.isFirstLaunch) {
    return RouteConstants.onboarding;
  }

  // 2. Jika bukan peluncuran pertama, cek status Autentikasi
  // Menggunakan Get.find() aman karena IAuthRepository sudah di-lazyPut di atas.
  final IAuthRepository authRepository = Get.find<IAuthRepository>();

  if (authRepository.isAuthenticated) {
    return RouteConstants.home;
  }

  // 3. Default: Jika onboarding sudah, tapi belum login
  return RouteConstants.login;
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      getPages: AppPages.pages,
      // initialBinding: AppBinding(),
      initialRoute: initialRoute, // ⬅️ Menggunakan rute yang ditentukan
    );
  }
}
