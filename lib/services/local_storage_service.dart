import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService {
  late final SharedPreferences _prefs;

  // Key untuk menyimpan status first launch
  static const String _kFirstLaunch = 'isFirstLaunch';

  // Metode inisialisasi asynchronous (wajib di main.dart)
  Future<LocalStorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Getter: Mengecek apakah ini adalah peluncuran pertama
  // Default: true, yang berarti dianggap sebagai peluncuran pertama jika key belum ada.
  bool get isFirstLaunch => _prefs.getBool(_kFirstLaunch) ?? true;

  // Setter: Menandai bahwa onboarding sudah ditampilkan
  Future<void> setFirstLaunchCompleted() async {
    await _prefs.setBool(_kFirstLaunch, false);
  }
}
