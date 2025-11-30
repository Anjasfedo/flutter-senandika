import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';

class ProfileEditChangePasswordPage extends StatefulWidget {
  const ProfileEditChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ProfileEditChangePasswordPageState createState() =>
      _ProfileEditChangePasswordPageState();
}

class _ProfileEditChangePasswordPageState
    extends State<ProfileEditChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Implementasi logika otentikasi dan perubahan password akan di sini (Firebase Auth)
      print('Changing password...');

      // Mock: Cek apakah password baru cocok
      if (_newPasswordController.text != _confirmPasswordController.text) {
        Get.snackbar(
          'Gagal',
          'Kata sandi baru dan konfirmasi tidak cocok.',
          backgroundColor: ColorConst.moodNegative.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Mock: Jika berhasil
      Get.snackbar(
        'Berhasil',
        'Kata sandi Anda berhasil diperbarui.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.back(); // Kembali ke halaman Edit Profil
    }
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
          key: _formKey,
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
              TextFormField(
                controller: _oldPasswordController,
                obscureText: _obscureOldPassword,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Verifikasi kata sandi lama',
                  Icons.lock_outlined,
                  _obscureOldPassword,
                  () {
                    setState(() {
                      _obscureOldPassword = !_obscureOldPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi lama wajib diisi.';
                  }
                  // Di aplikasi nyata, verifikasi dilakukan di backend
                  return null;
                },
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
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Masukkan kata sandi baru (min. 6 karakter)',
                  Icons.vpn_key_outlined,
                  _obscureNewPassword,
                  () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi baru wajib diisi.';
                  }
                  if (value.length < 6) {
                    return 'Kata sandi minimal 6 karakter.';
                  }
                  return null;
                },
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
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Ketik ulang kata sandi baru',
                  Icons.vpn_key_outlined,
                  _obscureConfirmPassword,
                  () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi kata sandi wajib diisi.';
                  }
                  // Cek kecocokan password baru
                  if (value != _newPasswordController.text) {
                    return 'Konfirmasi kata sandi tidak cocok.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 50),

              // --- Tombol Simpan ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.ctaPeach, // CTA Peach color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Perbarui Kata Sandi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
