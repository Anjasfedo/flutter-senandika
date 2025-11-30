import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/forget_password_controller.dart';

class ForgetPasswordPage extends GetView<ForgetPasswordController> {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  // Helper untuk membuat input decoration yang konsisten
  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(
        color: ColorConst.secondaryTextGrey.withOpacity(0.7),
      ),
      hintStyle: TextStyle(
        color: ColorConst.secondaryTextGrey.withOpacity(0.7),
      ),
      prefixIcon: Icon(prefixIcon, color: ColorConst.primaryAccentGreen),
      // Styling Border Default
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: ColorConst.secondaryTextGrey.withOpacity(0.5),
        ),
      ),
      // Styling Border saat aktif (fokus)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: ColorConst.primaryAccentGreen,
          width: 2,
        ),
      ),
      // Styling Border saat error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ColorConst.moodNegative, width: 2),
      ),
      // Styling Border saat tidak fokus/normal
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: ColorConst.secondaryTextGrey.withOpacity(0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Lupa Kata Sandi',
          style: TextStyle(color: ColorConst.primaryTextDark),
        ),
        backgroundColor: ColorConst.secondaryAccentLavender,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorConst.primaryTextDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Atur Ulang Kata Sandi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Masukkan email yang terdaftar untuk menerima tautan atur ulang kata sandi.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.secondaryTextGrey,
                ),
              ),
              const SizedBox(height: 30),

              // --- Input Email (Menggunakan Styling Helper) ---
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateEmail,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _buildInputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan alamat email Anda',
                  prefixIcon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 30),

              // --- Pesan Status/Error ---
              Obx(() {
                if (controller.infoMessage.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorConst.successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorConst.successGreen),
                    ),
                    width: double.infinity,
                    child: Text(
                      controller.infoMessage.value,
                      style: TextStyle(
                        color: ColorConst.successGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (controller.errorMessage.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorConst.moodNegative.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorConst.moodNegative),
                    ),
                    width: double.infinity,
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        color: ColorConst.moodNegative,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 10),

              // --- Tombol Kirim Permintaan ---
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.isFalse
                        ? controller.sendResetRequest
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.ctaPeach,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      // Menonaktifkan tombol secara visual saat isLoading
                      disabledBackgroundColor: ColorConst.ctaPeach.withOpacity(
                        0.5,
                      ),
                    ),
                    child: controller.isLoading.isTrue
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Kirim Tautan Reset',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
