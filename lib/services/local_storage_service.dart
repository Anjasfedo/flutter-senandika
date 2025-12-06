import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService {
  late SharedPreferences _prefs;

  static const String _kFirstLaunch = 'isFirstLaunch';
  static const String _kAppInitialized = 'appInitialized';

  @override
  Future<void> onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();

    print('🔧 SharedPreferences initialized');
    print('    - isFirstLaunch: $isFirstLaunch');
    print('    - appInitialized: $isAppInitialized');
  }

  // Factory constructor for async initialization
  static Future<LocalStorageService> create() async {
    final service = LocalStorageService();
    await service.onInit();
    return service;
  }

  bool get isFirstLaunch {
    return _prefs.getBool(_kFirstLaunch) ?? true;
  }

  bool get isAppInitialized {
    return _prefs.getBool(_kAppInitialized) ?? false;
  }

  Future<void> setFirstLaunchCompleted() async {
    // Ensure we're using the instance _prefs, not static
    await _prefs.setBool(_kFirstLaunch, false);
    await _prefs.setBool(_kAppInitialized, true);

    // Force flush to ensure data is written immediately
    await _prefs.reload();

    print('✅ First launch completed - values saved to disk');
    print('    - isFirstLaunch: $isFirstLaunch');
    print('    - appInitialized: $isAppInitialized');
  }

  // Method to refresh preferences from disk
  Future<void> refresh() async {
    await _prefs.reload();
    print('🔄 LocalStorageService refreshed');
    print('    - isFirstLaunch: $isFirstLaunch');
    print('    - appInitialized: $isAppInitialized');
  }

  // Method to debug current state
  void debugPrintState() {
    print('🔍 LocalStorageService Debug:');
    print('    - isFirstLaunch: $isFirstLaunch');
    print('    - isAppInitialized: $isAppInitialized');
  }

  // Debug method to reset first launch state (for testing purposes)
  Future<void> resetFirstLaunch() async {
    await _prefs.remove(_kFirstLaunch);
    await _prefs.remove(_kAppInitialized);
    await _prefs.reload();

    print('🔄 First launch state reset for testing');
    print('    - isFirstLaunch: $isFirstLaunch');
    print('    - appInitialized: $isAppInitialized');
  }
}
