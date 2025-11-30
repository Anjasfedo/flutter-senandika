import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';

class ProfileEditPage extends StatefulWidget {
  // Asumsi halaman ini menerima data profil saat navigasi,
  // namun kita akan menggunakan mock data internal untuk MVP
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Mock data awal (seharusnya dimuat dari database atau state management)
  String initialName = "Pengguna Senandika";
  String initialEmail = "user.senandika@email.com";

  @override
  void initState() {
    super.initState();
    _nameController.text = initialName;
    _emailController.text = initialEmail;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Logika penyimpanan data ke database (Firestore) akan diimplementasikan di versi berikutnya
      print(
        'Profile Updated: Name=${_nameController.text}, Email=${_emailController.text}',
      );

      // Update mock data untuk feedback visual (di MVP)
      setState(() {
        initialName = _nameController.text;
        initialEmail = _emailController.text;
      });

      // Kembali ke halaman Profile utama
      Get.back();

      // Tampilkan feedback sukses (menggunakan snackbar sebagai ganti alert)
      Get.snackbar(
        'Berhasil',
        'Perubahan profil berhasil disimpan.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
          key: _formKey,
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
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Masukkan nama lengkap Anda',
                  Icons.person_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Masukkan alamat email',
                  Icons.email_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!GetUtils.isEmail(value)) {
                    // Menggunakan GetUtils untuk validasi email
                    return 'Mohon masukkan email yang valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // --- Tombol Simpan ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.ctaPeach, // CTA Peach color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- Link Ubah Kata Sandi (Tambahan) ---
              Center(
                child: TextButton(
                  onPressed: () {
                    // Future: Navigate to Change Password Page
                    Get.toNamed(RouteConstants.profile_edit_change_password);
                  },
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
