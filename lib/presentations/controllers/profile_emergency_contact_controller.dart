import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/data/repositories/auth_repository.dart';
import 'package:senandika/data/repositories/user_repository.dart';
import 'package:senandika/data/models/emergency_contact_model.dart'; // ⬅️ Import Model
import 'package:senandika/presentations/controllers/profile_controller.dart'; // Untuk refresh ProfilePage

class EmergencyContactController extends GetxController {
  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;

  EmergencyContactController(this._userRepository, this._authRepository);

  // === Form State Management ===
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final isLoading = false.obs;

  // Data State Kontak Darurat
  EmergencyContactModel? _currentContact; // ⬅️ Model untuk state internal

  final RxString initialName = RxString('');
  final RxString initialPhone = RxString('');

  String get _currentUserId => _authRepository.currentUser?.id ?? '';
  final String nationalCrisisNumber = "1500451";

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Gagal', // Title
      message, // Message
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialContact();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _loadInitialContact() async {
    if (_currentUserId.isEmpty) {
      // ⬅️ DIUBAH: Panggil Snackbar
      _showErrorSnackbar('User ID tidak ditemukan. Silakan login kembali.');
      return;
    }

    isLoading.value = true;
    try {
      final contact = await _userRepository.getEmergencyContact(_currentUserId);

      if (contact != null) {
        _currentContact = contact; // ⬅️ Simpan model

        nameController.text = contact.name;
        phoneController.text = contact.phone;

        initialName.value = contact.name;
        initialPhone.value = contact.phone;
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memuat kontak darurat.');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Handlers ---

  Future<void> saveContact() async {
    if (!formKey.currentState!.validate() || _currentUserId.isEmpty) {
      return;
    }

    if (nameController.text == initialName.value &&
        phoneController.text == initialPhone.value) {
      Get.snackbar(
        'Informasi',
        'Tidak ada perubahan yang terdeteksi.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    try {
      final contactToSave = EmergencyContactModel(
        id: _currentContact?.id, // Kirim ID jika ada (UPDATE)
        userId: _currentUserId,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      await _userRepository.saveEmergencyContact(contactToSave);

      // Setelah sukses, perbarui state internal model
      _currentContact = contactToSave;

      // Muat ulang ProfileController untuk memastikan data di halaman utama diperbarui
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadUserProfile();
      }

      Get.back();

      Get.snackbar(
        'Berhasil',
        'Kontak darurat berhasil disimpan.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Update state local setelah sukses
      initialName.value = nameController.text.trim();
      initialPhone.value = phoneController.text.trim();
    } catch (e) {
      print('Save Contact Error: $e');
      final String errorText = e.toString();
      final displayMessage = errorText.startsWith('Exception: ')
          ? errorText.replaceFirst('Exception: ', '')
          : 'Gagal menyimpan kontak. Silakan coba lagi.';

      _showErrorSnackbar(displayMessage);
    } finally {
      isLoading.value = false;
    }
  }

  // Validator
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama kontak wajib diisi.';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon wajib diisi.';
    }
    if (value.length < 8) {
      return 'Nomor telepon terlalu pendek.';
    }
    return null;
  }
}
