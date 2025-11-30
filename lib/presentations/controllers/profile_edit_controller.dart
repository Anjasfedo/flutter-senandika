import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/user_repository.dart';
import 'package:senandika/data/sources/pocketbase.dart';
import 'package:senandika/presentations/controllers/profile_controller.dart';
// Import untuk file handling
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditController extends GetxController {
  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;
  final PocketBaseService _pbService = Get.find<PocketBaseService>();

  ProfileEditController(this._userRepository, this._authRepository);

  // === Form State Management ===
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  // ⬅️ EMAIL CONTROLLER DIHAPUS

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // ⬅️ State untuk File Foto Profil yang dipilih
  final Rx<File?> selectedAvatarFile = Rx<File?>(null);
  // ⬅️ State untuk URL Avatar saat ini (dari PocketBase)
  final RxString currentAvatarUrl = ''.obs;

  // Data Awal User
  String _currentUserId = '';
  // ⬅️ _initialEmail DIHAPUS

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  String _getFullAvatarUrl(String filename) {
    final user = _authRepository.currentUser;
    if (user == null || filename.isEmpty) return '';

    const String collectionId = 'users';
    final String recordId = user.id;

    return '${_pbService.pb.baseUrl}/api/files/$collectionId/$recordId/$filename';
  }

  void _loadInitialData() {
    final user = _authRepository.currentUser;
    if (user != null) {
      _currentUserId = user.id;
      nameController.text = user.name;

      // ⬅️ Load URL Avatar saat ini (FULL URL)
      if (user.avatar != null && user.avatar!.isNotEmpty) {
        // Gunakan helper internal
        currentAvatarUrl.value = _getFullAvatarUrl(user.avatar!);
      } else {
        currentAvatarUrl.value = '';
      }
    } else {
      Get.offAllNamed(RouteConstants.login);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    // ⬅️ EMAIL CONTROLLER DIHAPUS
    super.dispose();
  }

  // ⬅️ Handler untuk Memilih Foto Profil
  Future<void> pickAvatarImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      selectedAvatarFile.value = File(pickedFile.path);
    }
  }

  // --- Handlers ---

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final String currentName = _authRepository.currentUser?.name ?? '';

    // Cek apakah ada perubahan nama
    if (nameController.text == currentName &&
        selectedAvatarFile.value == null) {
      Get.snackbar(
        'Informasi',
        'Tidak ada perubahan yang terdeteksi.',
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Panggil updateProfile baru yang menerima file
      await _userRepository.updateProfile(
        userId: _currentUserId,
        name: nameController.text.trim(),
        avatarFile: selectedAvatarFile.value,
      );

      // Setelah sukses, bersihkan file yang dipilih
      selectedAvatarFile.value = null;

      // ⬅️ Muat ulang ProfileController
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadUserProfile();
      }

      Get.back();

      Get.snackbar(
        'Berhasil',
        'Perubahan profil berhasil disimpan.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Update Profile Error: $e');
      final String errorText = e.toString();
      errorMessage.value = errorText.startsWith('Exception: ')
          ? errorText.replaceFirst('Exception: ', '')
          : 'Gagal menyimpan profil. Silakan coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  void goToChangePassword() {
    Get.toNamed(RouteConstants.profile_edit_change_password);
  }

  // --- Validators ---
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  // ⬅️ VALIDATOR EMAIL DIHAPUS
}
