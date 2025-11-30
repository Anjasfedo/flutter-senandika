import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/presentations/controllers/profile_edit_controller.dart';

class ProfileEditPage extends GetView<ProfileEditController> {
  const ProfileEditPage({Key? key}) : super(key: key);

  // Helper for consistent InputDecoration styling
  InputDecoration _inputDecoration(String hintText, IconData prefixIconData) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: ColorConst.secondaryTextGrey.withOpacity(0.7),
      ),
      filled: true,
      fillColor: ColorConst.primaryBackgroundLight,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 15.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: ColorConst.secondaryTextGrey.withOpacity(0.3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: ColorConst.secondaryTextGrey.withOpacity(0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorConst.primaryAccentGreen, width: 2),
      ),
      prefixIcon: Icon(prefixIconData, color: ColorConst.primaryAccentGreen),
    );
  }

  Widget _buildAvatarWidget(BuildContext context) {
    return Obx(() {
      final File? selectedFile = controller.selectedAvatarFile.value;
      final String currentUrl = controller.currentAvatarUrl.value;

      ImageProvider? imageProvider;

      // 1. PRIORITAS 1: File yang baru dipilih (Preview Lokal)
      if (selectedFile != null) {
        imageProvider = FileImage(selectedFile);
      }
      // 2. PRIORITAS 2: URL dari server
      else if (currentUrl.isNotEmpty) {
        // Asumsi: URL sudah penuh dan siap digunakan oleh NetworkImage
        imageProvider = NetworkImage(currentUrl);
      }

      // Menggunakan Stack untuk CircleAvatar dan Icon overlay
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          // 1. Tampilan Utama Avatar (Menggunakan CircleAvatar)
          CircleAvatar(
            radius: 50,
            backgroundColor: ColorConst.primaryAccentGreen,
            // Jika imageProvider ada, gunakan sebagai background image
            backgroundImage: imageProvider,
            // Default icon jika imageProvider null
            child: imageProvider == null
                ? const Icon(
                    Icons.person_outline,
                    size: 50,
                    color: Colors.white,
                  )
                : null,
          ),

          // 2. Icon overlay (Tombol Edit Kecil)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: ColorConst.primaryAccentGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: TextStyle(
            color: ColorConst.primaryTextDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorConst.secondaryAccentLavender,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConst.primaryTextDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Gambar Profil ---
              Center(
                child: Column(
                  children: [
                    // ⬅️ MENGGUNAKAN WIDGET HELPER YANG BARU
                    _buildAvatarWidget(context),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: controller.pickAvatarImage,
                      icon: Icon(
                        Icons.photo_camera_outlined,
                        size: 18,
                        color: ColorConst.primaryAccentGreen,
                      ),
                      label: Text(
                        'Ubah Foto Profil',
                        style: TextStyle(color: ColorConst.primaryAccentGreen),
                      ),
                    ),
                  ],
                ),
              ),

              // ... (Sisa kode Form dan Tombol tetap sama)
              const SizedBox(height: 30),

              // Pesan Error
              Obx(
                () => controller.errorMessage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ColorConst.moodNegative.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ColorConst.moodNegative),
                          ),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: ColorConst.moodNegative,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // --- NAMA FIELD ---
              Text(
                'Nama Lengkap',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.primaryTextDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.nameController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Masukkan nama lengkap Anda',
                  Icons.person_outlined,
                ),
                validator: controller.validateName,
              ),

              const SizedBox(height: 40),

              // --- Tombol Simpan ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.isTrue
                        ? null
                        : controller.saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.ctaPeach,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: controller.isLoading.isTrue
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- Link Ubah Kata Sandi (Tambahan) ---
              Center(
                child: TextButton(
                  onPressed: controller.goToChangePassword,
                  child: Text(
                    'Ubah Kata Sandi',
                    style: TextStyle(
                      color: ColorConst.primaryAccentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
