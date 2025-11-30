import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';

class ProfileEmergencyContactPage extends StatefulWidget {
  const ProfileEmergencyContactPage({Key? key}) : super(key: key);

  @override
  _ProfileEmergencyContactPageState createState() =>
      _ProfileEmergencyContactPageState();
}

class _ProfileEmergencyContactPageState
    extends State<ProfileEmergencyContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Mock Data Awal (seharusnya dimuat dari USERS table)
  String mockContactName = "Ibu/Saudara Kandung";
  String mockContactPhone = "081234567890";
  final String nationalCrisisNumber =
      "1500451"; // Nomor Krisis Nasional (Kemenkes/Layanan Jiwa)

  @override
  void initState() {
    super.initState();
    _nameController.text = mockContactName;
    _phoneController.text = mockContactPhone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
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

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      // Logika penyimpanan data ke database (Firestore) akan diimplementasikan di versi berikutnya
      print(
        'Emergency Contact Updated: Name=${_nameController.text}, Phone=${_phoneController.text}',
      );

      // Update mock data
      setState(() {
        mockContactName = _nameController.text;
        mockContactPhone = _phoneController.text;
      });

      // Kembali ke halaman Profile utama
      Get.back();

      // Tampilkan feedback sukses
      Get.snackbar(
        'Berhasil',
        'Kontak darurat berhasil diperbarui.',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Kontak Darurat',
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
              // --- Deskripsi & Peringatan ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConst.secondaryAccentLavender.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorConst.crisisOrange.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: ColorConst.crisisOrange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Kontak darurat digunakan jika Anda menekan tombol "Krisis" di halaman utama. Pastikan kontak ini adalah orang yang Anda percaya.',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConst.primaryTextDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- INFORMASI KRISIS NASIONAL ---
              Text(
                'Layanan Krisis Nasional (24 Jam)',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.primaryTextDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildNationalCrisisInfo(),

              const SizedBox(height: 30),

              // --- FIELD NAMA KONTAK PRIBADI ---
              Text(
                'Nama Kontak Pribadi',
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
                  'Contoh: Ibu/Sahabat',
                  Icons.person_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kontak wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              // --- FIELD NOMOR TELEPON ---
              Text(
                'Nomor Telepon Kontak',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.primaryTextDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: _inputDecoration(
                  'Contoh: 08XXXXXXXXXX',
                  Icons.phone_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon wajib diisi.';
                  }
                  if (value.length < 8) {
                    return 'Nomor telepon terlalu pendek.';
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
                  onPressed: _saveContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.ctaPeach, // CTA Peach color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Simpan Kontak Darurat',
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

  // Helper untuk menampilkan kotak info krisis nasional
  Widget _buildNationalCrisisInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConst.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorConst.secondaryTextGrey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: ColorConst.crisisOrange),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layanan Kesehatan Jiwa',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorConst.primaryTextDark,
                  ),
                ),
                Text(
                  'Telepon: $nationalCrisisNumber',
                  style: TextStyle(color: ColorConst.secondaryTextGrey),
                ),
                const SizedBox(height: 5),
                Text(
                  'Nomor ini akan selalu tersedia di tombol krisis.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: ColorConst.secondaryTextGrey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
