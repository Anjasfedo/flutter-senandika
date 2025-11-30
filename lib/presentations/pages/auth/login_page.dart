import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/constants/color_constant.dart'; // Import color constants

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Implementasi logika login di sini
      // Saat ini, langsung navigasi ke Home untuk tujuan MVP
      // Menggunakan Get.offAllNamed untuk menghapus stack navigasi Onboarding/Login
      Get.offAllNamed(RouteConstants.home);
    }
  }

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
      // Menggunakan background utama yang terang
      backgroundColor: ColorConst.primaryBackgroundLight,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Header: Menggunakan warna aksen dan konten yang tenang
              Container(
                width: double.infinity,
                // **FIXED ERROR HERE:** Remove 'color: ColorConst.secondaryAccentLavender,' from Container widget
                padding: const EdgeInsets.only(
                  top: 50, // Increased top padding for better visual balance
                  bottom: 40,
                  left: 24,
                  right: 24,
                ),
                decoration: BoxDecoration(
                  // COLOR MUST BE INSIDE BoxDecoration when decoration is used
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
                      onPressed: () {
                        // Kembali ke Onboarding
                        Get.back();
                      },
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

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
                        controller: _emailController,
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
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
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
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(color: ColorConst.primaryTextDark),
                        decoration: _inputDecoration(
                          'Masukkan Kata Sandi',
                          Icons.lock_outlined,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: ColorConst.secondaryTextGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
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

                      const SizedBox(height: 10),

                      // Remember me and Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
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
                              Text(
                                'Ingat Saya',
                                style: TextStyle(
                                  color: ColorConst.primaryTextDark,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password
                            },
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
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                ColorConst.ctaPeach, // CTA Peach color
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // OR divider (Menggunakan warna yang lembut)
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
                            // Process Google login
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
                              // Ikon Google (Placeholder) - Biasanya menggunakan asset,
                              // tapi kita pakai ikon placeholder dengan warna aksen
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
                            onPressed: () {
                              // Navigasi ke halaman sign up (asumsi rute sudah ada)
                              Get.toNamed(RouteConstants.sign_up);
                            },
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
