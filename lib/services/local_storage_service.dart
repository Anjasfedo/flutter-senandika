import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService {
  // ⬅️ Change to GetxService
  static SharedPreferences? _prefs;

  static const String _kFirstLaunch = 'isFirstLaunch';
  static const String _kAppInitialized = 'appInitialized';

  // ⬅️ Change to GetX Service pattern
  static Future<LocalStorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    final service = LocalStorageService._();

    print('🔧 SharedPreferences initialized');
    print('    - isFirstLaunch: ${service.isFirstLaunch}');
    print('    - appInitialized: ${service.isAppInitialized}');

    return service;
  }

  LocalStorageService._(); // Private constructor

  bool get isFirstLaunch {
    return _prefs?.getBool(_kFirstLaunch) ?? true;
  }

  bool get isAppInitialized {
    return _prefs?.getBool(_kAppInitialized) ?? false;
  }

  Future<void> setFirstLaunchCompleted() async {
    await _prefs?.setBool(_kFirstLaunch, false);
    await _prefs?.setBool(_kAppInitialized, true);

    print('✅ First launch completed - values saved to disk');
    print('    - isFirstLaunch: ${_prefs?.getBool(_kFirstLaunch)}');
    print('    - appInitialized: ${_prefs?.getBool(_kAppInitialized)}');
  }

  // Method to debug current state
  void debugPrintState() {
    print('🔍 LocalStorageService Debug:');
    print('    - isFirstLaunch: $isFirstLaunch');
    print('    - appInitialized: $isAppInitialized');
    print('    - _prefs is null: ${_prefs == null}');
  }
}
