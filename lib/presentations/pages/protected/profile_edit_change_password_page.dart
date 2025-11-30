import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/profile_edit_change_password_controller.dart'; // Import Controller

class ProfileEditChangePasswordPage
    extends GetView<ProfileEditChangePasswordController> {
  const ProfileEditChangePasswordPage({Key? key}) : super(key: key);

  // Helper for consistent InputDecoration styling
  InputDecoration _inputDecoration(
    String hintText,
    IconData prefixIconData,
    bool isObscure,
    VoidCallback toggleVisibility,
  ) {
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
      suffixIcon: IconButton(
        icon: Icon(
          isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: ColorConst.secondaryTextGrey,
        ),
        onPressed: toggleVisibility,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Ubah Kata Sandi',
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
              // Deskripsi
              Text(
                'Masukkan kata sandi lama Anda untuk verifikasi, kemudian masukkan kata sandi baru.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.secondaryTextGrey,
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

              // --- FIELD KATA SANDI LAMA ---
              Text(
                'Kata Sandi Lama',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.primaryTextDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => TextFormField(
                  controller: controller.oldPasswordController, // ⬅️ Controller
                  obscureText: controller.obscureOldPassword.value, // ⬅️ RxBool
                  style: TextStyle(color: ColorConst.primaryTextDark),
                  decoration: _inputDecoration(
                    'Verifikasi kata sandi lama',
                    Icons.lock_outlined,
                    controller.obscureOldPassword.value,
                    controller.toggleOldPasswordVisibility, // ⬅️ Handler
                  ),
                  validator: (value) =>
                      controller.validateRequired(value, 'Kata sandi lama'),
                ),
              ),

              const SizedBox(height: 25),

              // --- FIELD KATA SANDI BARU ---
              Text(
                'Kata Sandi Baru',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.primaryTextDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => TextFormField(
                  controller: controller.newPasswordController, // ⬅️ Controller
                  obscureText: controller.obscureNewPassword.value, // ⬅️ RxBool
                  style: TextStyle(color: ColorConst.primaryTextDark),
                  decoration: _inputDecoration(
                    'Masukkan kata sandi baru (min. 6 karakter)',
                    Icons.vpn_key_outlined,
                    controller.obscureNewPassword.value,
                    controller.toggleNewPasswordVisibility, // ⬅️ Handler
                  ),
                  validator: (value) {
                    final requiredError = controller.validateRequired(
                      value,
                      'Kata sandi baru',
                    );
                    if (requiredError != null) return requiredError;
                    return controller.validatePasswordLength(value);
                  },
                ),
              ),

              const SizedBox(height: 25),

              // --- FIELD KONFIRMASI KATA SANDI BARU ---
              Text(
                'Konfirmasi Kata Sandi Baru',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.primaryTextDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => TextFormField(
                  controller:
                      controller.confirmPasswordController, // ⬅️ Controller
                  obscureText:
                      controller.obscureConfirmPassword.value, // ⬅️ RxBool
                  style: TextStyle(color: ColorConst.primaryTextDark),
                  decoration: _inputDecoration(
                    'Ketik ulang kata sandi baru',
                    Icons.vpn_key_outlined,
                    controller.obscureConfirmPassword.value,
                    controller.toggleConfirmPasswordVisibility, // ⬅️ Handler
                  ),
                  validator: controller.validateConfirmPassword, // ⬅️ Validator
                ),
              ),

              const SizedBox(height: 50),

              // --- Tombol Simpan ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.isTrue
                        ? null
                        : controller.changePassword, // ⬅️ Handler
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.ctaPeach,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      disabledBackgroundColor: ColorConst.secondaryTextGrey
                          .withOpacity(0.5),
                    ),
                    child: controller.isLoading.isTrue
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Perbarui Kata Sandi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
