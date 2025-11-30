import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/login_controller.dart';

// Menggunakan GetView untuk mengakses controller
class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

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
      fillColor: ColorConst
          .primaryBackgroundLight, // Fill color using light background
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
        borderSide: BorderSide(
          color: ColorConst.primaryAccentGreen, // Focus color is Sage Green
          width: 2,
        ),
      ),
      prefixIcon: Icon(
        prefixIconData,
        color: ColorConst.primaryAccentGreen, // Icon color is Sage Green
      ),
      suffixIcon: suffixIcon,
    );
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
                  top: 50, // Increased top padding for better visual balance
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
                      'Selamat Datang Kembali',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.primaryTextDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Subtitle
                    Text(
                      'Masuk untuk melanjutkan dialog batin dan memantau kemajuanmu.',
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
                // Menggunakan GlobalKey dari Controller
                child: Form(
                  key: controller.loginFormKey,
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
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      // Email field
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
                        // Menggunakan TextEditingController dari Controller
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: ColorConst.primaryTextDark),
                        decoration: _inputDecoration(
                          'Masukkan Email',
                          Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan email Anda';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Mohon masukkan email yang valid';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password field
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
                          // Menggunakan TextEditingController dari Controller
                          controller: controller.passwordController,
                          // Menggunakan RxBool dari Controller
                          obscureText: controller.obscurePassword.value,
                          style: TextStyle(color: ColorConst.primaryTextDark),
                          decoration: _inputDecoration(
                            'Masukkan Kata Sandi',
                            Icons.lock_outlined,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: ColorConst.secondaryTextGrey,
                              ),
                              // Memanggil method toggle dari Controller
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon masukkan kata sandi Anda';
                            }
                            if (value.length < 6) {
                              return 'Kata sandi minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Remember me and Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  // Menggunakan RxBool dari Controller
                                  value: controller.rememberMe.value,
                                  // Memanggil method toggle dari Controller
                                  onChanged: controller.toggleRememberMe,
                                  // Checkbox style (Sage Green)
                                  activeColor: ColorConst.primaryAccentGreen,
                                  checkColor: Colors.white,
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>((
                                        Set<MaterialState> states,
                                      ) {
                                        if (states.contains(
                                          MaterialState.selected,
                                        )) {
                                          return ColorConst.primaryAccentGreen;
                                        }
                                        return ColorConst.secondaryBackground;
                                      }),
                                ),
                              ),
                              Text(
                                'Ingat Saya',
                                style: TextStyle(
                                  color: ColorConst.primaryTextDark,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: controller.goToForgotPassword,
                            child: Text(
                              'Lupa sandi?',
                              style: TextStyle(
                                color:
                                    ColorConst.primaryAccentGreen, // Link color
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Login button (CTA Peach)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(
                          () => ElevatedButton(
                            // Memanggil Form Handler di Controller
                            onPressed: controller.isLoading.isTrue
                                ? null
                                : controller.handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorConst.ctaPeach, // CTA Peach color
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
                                    'Masuk',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // OR divider
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
                              'ATAU', // Diubah ke Bahasa Indonesia
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

                      // Google login button (Aksen Sage Green)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            // Implementasi Google login
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: ColorConst.primaryAccentGreen,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add_alt_1, // Placeholder icon
                                color: ColorConst.primaryAccentGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Masuk dengan Google',
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

                      const SizedBox(height: 30),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum memiliki akun? ',
                            style: TextStyle(color: ColorConst.primaryTextDark),
                          ),
                          TextButton(
                            onPressed: controller.goToSignUp,
                            child: Text(
                              'Daftar Sekarang', // Diubah ke Bahasa Indonesia
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
