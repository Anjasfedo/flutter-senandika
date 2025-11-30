import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';

// --- Mock Model untuk Target ---
class TargetItem {
  String id;
  String title;
  String frequency; // 'Harian', 'Mingguan', 'Sekali Waktu'
  bool isActive;

  TargetItem({
    required this.id,
    required this.title,
    required this.frequency,
    this.isActive = true,
  });
}
// ------------------------------

class ProfileTargetHabitPage extends StatefulWidget {
  const ProfileTargetHabitPage({Key? key}) : super(key: key);

  @override
  _ProfileTargetHabitPageState createState() => _ProfileTargetHabitPageState();
}

class _ProfileTargetHabitPageState extends State<ProfileTargetHabitPage> {
  // Mock Data Target
  final List<TargetItem> _targets = [
    TargetItem(id: '1', title: 'Jalan kaki 10 menit', frequency: 'Harian'),
    TargetItem(id: '2', title: 'Minum 8 gelas air', frequency: 'Harian'),
    TargetItem(
      id: '3',
      title: 'Baca buku 15 menit',
      frequency: 'Mingguan',
      isActive: false,
    ),
    // Menambahkan beberapa item lagi untuk menguji scrolling dan FAB
    TargetItem(id: '4', title: 'Meditasi 5 menit', frequency: 'Harian'),
    TargetItem(id: '5', title: 'Telepon teman', frequency: 'Mingguan'),
    TargetItem(id: '6', title: 'Coba resep baru', frequency: 'Sekali Waktu'),
  ];

  // Helper untuk menampilkan dialog tambah/edit
  void _showAddEditTargetDialog({TargetItem? target}) {
    final bool isEditing = target != null;
    final TextEditingController titleController = TextEditingController(
      text: isEditing ? target.title : '',
    );
    String selectedFrequency = isEditing ? target.frequency : 'Harian';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Ubah Target' : 'Target Baru',
                style: TextStyle(color: ColorConst.primaryTextDark),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Input Judul Target
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Nama Kebiasaan',
                      hintText: 'Contoh: Meditasi pagi',
                      labelStyle: TextStyle(
                        color: ColorConst.secondaryTextGrey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorConst.primaryAccentGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pilihan Frekuensi
                  DropdownButtonFormField<String>(
                    value: selectedFrequency,
                    decoration: InputDecoration(
                      labelText: 'Frekuensi',
                      labelStyle: TextStyle(
                        color: ColorConst.secondaryTextGrey,
                      ),
                    ),
                    items: ['Harian', 'Mingguan', 'Sekali Waktu'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setStateSB(() {
                        selectedFrequency = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Batal',
                    style: TextStyle(color: ColorConst.secondaryTextGrey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        if (isEditing) {
                          // Edit existing
                          target.title = titleController.text;
                          target.frequency = selectedFrequency;
                        } else {
                          // Add new
                          _targets.add(
                            TargetItem(
                              id: DateTime.now().toString(),
                              title: titleController.text,
                              frequency: selectedFrequency,
                            ),
                          );
                        }
                      });
                      Get.back();
                      Get.snackbar(
                        'Berhasil',
                        isEditing
                            ? 'Target diperbarui'
                            : 'Target baru ditambahkan',
                        backgroundColor: ColorConst.primaryAccentGreen,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.ctaPeach,
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteTarget(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Target?'),
        content: const Text('Target ini akan dihapus dari daftar harianmu.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                _targets.removeAt(index);
              });
              Get.back();
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: ColorConst.moodNegative),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Increased bottom padding to ensure FAB doesn't overlap with content
    final double fabHeightPadding = 100.0;

    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Kelola Target Kebiasaan',
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

      // Tombol Tambah (Floating Action Button) - FIXED POSITION
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          bottom: 16.0,
        ), // Add margin to lift FAB higher
        child: FloatingActionButton.extended(
          onPressed: () => _showAddEditTargetDialog(),
          backgroundColor: ColorConst.primaryAccentGreen,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Tambah Target',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Menggunakan SafeArea di body untuk menghindari pemotongan konten oleh notch/status bar
      body: SafeArea(
        child: _targets.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checklist_rtl_outlined,
                      size: 80,
                      color: ColorConst.secondaryTextGrey.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada target kebiasaan.',
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorConst.secondaryTextGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mulai dengan langkah kecil hari ini!',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConst.primaryAccentGreen,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                // Increased bottom padding to prevent overlap
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                itemCount: _targets.length,
                itemBuilder: (context, index) {
                  final target = _targets[index];
                  return _buildTargetCard(target, index);
                },
              ),
      ),
    );
  }

  Widget _buildTargetCard(TargetItem target, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Icon Indikator
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: target.isActive
                        ? ColorConst.primaryAccentGreen.withOpacity(0.15)
                        : ColorConst.secondaryTextGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.track_changes,
                    color: target.isActive
                        ? ColorConst.primaryAccentGreen
                        : ColorConst.secondaryTextGrey,
                  ),
                ),
                const SizedBox(width: 16),

                // Judul & Frekuensi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        target.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: target.isActive
                              ? ColorConst.primaryTextDark
                              : ColorConst.secondaryTextGrey,
                          decoration: target.isActive
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConst.secondaryBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          target.frequency,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConst.secondaryTextGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Switch Aktif/Nonaktif
                Switch(
                  value: target.isActive,
                  activeColor: ColorConst.primaryAccentGreen,
                  onChanged: (bool value) {
                    setState(() {
                      target.isActive = value;
                    });
                  },
                ),
              ],
            ),

            // Divider & Action Buttons
            if (target.isActive) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showAddEditTargetDialog(target: target),
                    icon: Icon(
                      Icons.edit,
                      size: 16,
                      color: ColorConst.secondaryTextGrey,
                    ),
                    label: Text(
                      'Ubah',
                      style: TextStyle(color: ColorConst.secondaryTextGrey),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _deleteTarget(index),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: ColorConst.moodNegative,
                    ),
                    label: Text(
                      'Hapus',
                      style: TextStyle(color: ColorConst.moodNegative),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
