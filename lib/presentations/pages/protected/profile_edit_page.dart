// lib/presentations/pages/protected/profile_edit_page.dart

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
          key: controller.formKey, // ⬅️ Menggunakan Controller Key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Gambar Profil ---
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: ColorConst.primaryAccentGreen,
                      child: Icon(
                        Icons.person_outline,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {
                        /* Future: Change Picture */
                      },
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

              const SizedBox(height: 30),

              // ⬅️ Pesan Error dari Controller
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
                controller: controller.nameController, // ⬅️ Controller
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Masukkan nama lengkap Anda',
                  Icons.person_outlined,
                ),
                validator: controller.validateName, // ⬅️ Validator
              ),

              const SizedBox(height: 25),

              // --- EMAIL FIELD ---
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.primaryTextDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.emailController, // ⬅️ Controller
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Masukkan alamat email',
                  Icons.email_outlined,
                ),
                validator: controller.validateEmail, // ⬅️ Validator
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
                        : controller.saveProfile, // ⬅️ Handler
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
                  onPressed: controller.goToChangePassword, // ⬅️ Handler
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
