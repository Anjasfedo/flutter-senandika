import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/sign_up_controller.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({Key? key}) : super(key: key);

  // Helper for consistent InputDecoration styling
  InputDecoration _inputDecoration(
    String hintText,
    IconData prefixIconData, {
    Widget? suffixIcon,
  }) {
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
      // Border: Menggunakan style yang lebih lembut dan rounded
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
      suffixIcon: suffixIcon,
    );
  }

  // Validator untuk email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mohon masukkan email Anda';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Mohon masukkan email yang valid';
    }
    return null;
  }

  // Validator untuk password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mohon masukkan kata sandi Anda';
    }
    if (value.length < 6) {
      return 'Kata sandi minimal 6 karakter';
    }
    return null;
  }

  // ⬅️ Validator untuk Konfirmasi Password
  String? _validatePasswordConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mohon konfirmasi kata sandi Anda';
    }
    if (value != controller.passwordController.text) {
      return 'Kata sandi tidak cocok';
    }
    return null;
  }

  // Validator untuk nama
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mohon masukkan nama Anda';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 40,
                  left: 24,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  color: ColorConst.secondaryAccentLavender,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConst.secondaryTextGrey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tombol Kembali
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: ColorConst.primaryTextDark,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 30),

                    // Title
                    Text(
                      'Daftar Akun Baru',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.primaryTextDark,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      'Bergabunglah bersama kami untuk memulai dialog batinmu.',
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorConst.secondaryTextGrey,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // Pesan Error dari Controller
                      Obx(
                        () => controller.errorMessage.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: ColorConst.moodNegative.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorConst.moodNegative,
                                    ),
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.nameController,
                        style: TextStyle(color: ColorConst.primaryTextDark),
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration(
                          'Masukkan Nama Lengkap',
                          Icons.person_outlined,
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 20),

                      // --- EMAIL FIELD ---
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorConst.primaryTextDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: ColorConst.primaryTextDark),
                        decoration: _inputDecoration(
                          'Masukkan Email',
                          Icons.email_outlined,
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),

                      // --- PASSWORD FIELD ---
                      Text(
                        'Kata Sandi',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorConst.primaryTextDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscureText: controller.obscurePassword.value,
                          style: TextStyle(color: ColorConst.primaryTextDark),
                          decoration: _inputDecoration(
                            'Buat Kata Sandi (min. 6 karakter)',
                            Icons.lock_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: ColorConst.secondaryTextGrey,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ⬅️ --- KONFIRMASI PASSWORD FIELD ---
                      Text(
                        'Konfirmasi Kata Sandi',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorConst.primaryTextDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextFormField(
                          controller: controller
                              .passwordConfirmController, // ⬅️ Controller baru
                          obscureText: controller
                              .obscurePasswordConfirm
                              .value, // ⬅️ State baru
                          style: TextStyle(color: ColorConst.primaryTextDark),
                          decoration: _inputDecoration(
                            'Ulangi Kata Sandi',
                            Icons.lock_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePasswordConfirm.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: ColorConst.secondaryTextGrey,
                              ),
                              onPressed: controller
                                  .togglePasswordConfirmVisibility, // ⬅️ Handler baru
                            ),
                          ),
                          validator:
                              _validatePasswordConfirm, // ⬅️ Validator baru
                        ),
                      ),

                      // ------------------------------------
                      const SizedBox(height: 40),

                      // --- SIGN UP BUTTON (CTA Peach) ---
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isLoading.isTrue
                                ? null
                                : controller.handleSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConst.ctaPeach,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 3,
                              disabledBackgroundColor: ColorConst
                                  .secondaryTextGrey
                                  .withOpacity(0.5),
                            ),
                            child: controller.isLoading.isTrue
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
                                    'Daftar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- OR divider ---
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: ColorConst.secondaryTextGrey.withOpacity(
                                0.5,
                              ),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'ATAU',
                              style: TextStyle(
                                color: ColorConst.secondaryTextGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: ColorConst.secondaryTextGrey.withOpacity(
                                0.5,
                              ),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // --- Google sign up button (Placeholder) ---
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(
                          () => OutlinedButton(
                            // ⬅️ Menggunakan isGoogleLoading dan handler baru
                            onPressed: controller.isGoogleLoading.isTrue
                                ? null
                                : controller.handleGoogleSignUp,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: ColorConst.primaryAccentGreen,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              disabledForegroundColor: ColorConst
                                  .secondaryTextGrey
                                  .withOpacity(0.5), // Style saat loading
                            ),
                            child: controller.isGoogleLoading.isTrue
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: ColorConst.primaryAccentGreen,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons
                                            .person_add_alt_1, // Placeholder icon
                                        color: ColorConst.primaryAccentGreen,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Daftar dengan Google',
                                        style: TextStyle(
                                          color: ColorConst.primaryAccentGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // --- FOOTER LINK (Go to Login) ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah memiliki akun? ',
                            style: TextStyle(color: ColorConst.primaryTextDark),
                          ),
                          TextButton(
                            onPressed: controller.goToLogin,
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                color: ColorConst.primaryAccentGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
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
