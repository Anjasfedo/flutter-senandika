import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';

// Mock Model TargetItem (didefinisikan di sini untuk menghindari dependency loop)
class TargetItem {
  String id;
  String title;
  String frequency;
  bool isActive;

  TargetItem({
    required this.id,
    required this.title,
    required this.frequency,
    this.isActive = true,
  });
}

class ProfileTargetHabitCreatePage extends StatefulWidget {
  // Opsi untuk menerima TargetItem jika ini adalah mode EDIT
  final TargetItem? initialTarget;

  const ProfileTargetHabitCreatePage({Key? key, this.initialTarget})
    : super(key: key);

  @override
  // FIX: Mengganti State<ProfileTargetHabitPage> menjadi State<ProfileTargetHabitCreatePage>
  _ProfileTargetHabitCreatePageState createState() =>
      _ProfileTargetHabitCreatePageState();
}

class _ProfileTargetHabitCreatePageState
    extends State<ProfileTargetHabitCreatePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late String _selectedFrequency;

  // Data mock frekuensi
  final List<String> frequencies = ['Harian', 'Mingguan', 'Sekali Waktu'];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dan state berdasarkan mode (Create atau Edit)
    _titleController = TextEditingController(
      text: widget.initialTarget?.title ?? '',
    );
    _selectedFrequency = widget.initialTarget?.frequency ?? frequencies.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Helper for consistent InputDecoration styling
  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: ColorConst.secondaryTextGrey),
      filled: true,
      fillColor: ColorConst.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 15.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Tanpa border untuk tampilan bersih
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorConst.primaryAccentGreen, width: 2),
      ),
    );
  }

  void _saveTarget() {
    if (_formKey.currentState!.validate()) {
      final newTargetData = TargetItem(
        id: widget.initialTarget?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        frequency: _selectedFrequency,
        isActive: widget.initialTarget?.isActive ?? true,
      );

      // Kirim data target kembali ke halaman sebelumnya (ProfileTargetHabitPage)
      Get.back(result: newTargetData);

      Get.snackbar(
        'Berhasil',
        widget.initialTarget != null
            ? 'Target diperbarui'
            : 'Target baru ditambahkan',
        backgroundColor: ColorConst.primaryAccentGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.initialTarget != null;

    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Ubah Target Kebiasaan' : 'Buat Target Baru',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Deskripsi
                Text(
                  isEditing
                      ? 'Sesuaikan rincian target kebiasaanmu untuk mencapai kemajuan.'
                      : 'Definisikan langkah kecil dan terukur untuk meningkatkan kesejahteraan mentalmu.',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConst.secondaryTextGrey,
                  ),
                ),

                const SizedBox(height: 30),

                // --- FIELD JUDUL TARGET ---
                Text(
                  'Nama Kebiasaan / Target',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConst.primaryTextDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: ColorConst.primaryTextDark),
                  decoration: _inputDecoration(
                    'Contoh: Meditasi 5 menit setiap pagi',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama target wajib diisi.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // --- FIELD FREKUENSI ---
                Text(
                  'Frekuensi Pengulangan',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConst.primaryTextDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: ColorConst.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedFrequency,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorConst.primaryAccentGreen,
                    ),
                    style: TextStyle(
                      color: ColorConst.primaryTextDark,
                      fontSize: 16,
                    ),
                    dropdownColor: ColorConst.primaryBackgroundLight,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    items: frequencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedFrequency = newValue!;
                      });
                    },
                  ),
                ),

                // --- FUTURE EXPANSION: Waktu Pengingat ---
                const SizedBox(height: 30),
                Text(
                  'Pengingat (Fitur Berikutnya)',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConst.secondaryTextGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.alarm,
                    color: ColorConst.secondaryTextGrey.withOpacity(0.5),
                  ),
                  title: Text(
                    'Atur Waktu Pengingat',
                    style: TextStyle(
                      color: ColorConst.secondaryTextGrey.withOpacity(0.8),
                    ),
                  ),
                  trailing: Text(
                    'Setiap ${_selectedFrequency}',
                    style: TextStyle(
                      color: ColorConst.secondaryTextGrey.withOpacity(0.8),
                    ),
                  ),
                  tileColor: ColorConst.secondaryBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    // Mock: Implementasi fitur pengingat di versi berikutnya
                    Get.snackbar(
                      'Segera Hadir!',
                      'Pengaturan waktu pengingat akan tersedia di update selanjutnya.',
                      backgroundColor: ColorConst.secondaryAccentLavender,
                      colorText: ColorConst.primaryTextDark,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),

                const SizedBox(height: 50),

                // --- Tombol Simpan ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveTarget,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.ctaPeach, // CTA Peach color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      isEditing ? 'Simpan Perubahan' : 'Tambah Target',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
