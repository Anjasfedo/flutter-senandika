import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/profile_emergency_contact_controller.dart';

class ProfileEmergencyContactPage extends GetView<EmergencyContactController> {
  const ProfileEmergencyContactPage({Key? key}) : super(key: key);

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

  // Helper untuk menampilkan kotak info krisis nasional
  Widget _buildNationalCrisisInfo(String number) {
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
                  'Telepon: $number',
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
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.isTrue && controller.initialName.isEmpty) {
            // Tampilkan Loading awal jika data belum termuat
            return const Center(child: CircularProgressIndicator());
          }
        
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: controller.formKey,
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
                  _buildNationalCrisisInfo(controller.nationalCrisisNumber),
        
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
                    controller: controller.nameController,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(color: ColorConst.primaryTextDark),
                    decoration: _inputDecoration(
                      'Contoh: Ibu/Sahabat',
                      Icons.person_outlined,
                    ),
                    validator: controller.validateName,
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
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: ColorConst.primaryTextDark),
                    decoration: _inputDecoration(
                      'Contoh: 08XXXXXXXXXX',
                      Icons.phone_outlined,
                    ),
                    validator: controller.validatePhone,
                  ),
        
                  const SizedBox(height: 50),
        
                  // --- Tombol Simpan ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.isFalse
                          ? controller.saveContact
                          : null,
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
                              'Simpan Kontak Darurat',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
