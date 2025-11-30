import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';

// Mock Model TargetItem
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
    TargetItem(id: '4', title: 'Meditasi 5 menit', frequency: 'Harian'),
    TargetItem(id: '5', title: 'Telepon teman', frequency: 'Mingguan'),
    TargetItem(id: '6', title: 'Coba resep baru', frequency: 'Sekali Waktu'),
  ];

  // Logic navigasi ke halaman Create/Edit
  void _addEditTarget({TargetItem? target, int? index}) async {
    // Navigasi ke halaman create/edit, mengirim data jika mode Edit
    final result = await Get.toNamed(
      // Asumsi rute ini sudah didefinisikan di RouteConstants
      RouteConstants.profile_target_habit_create,
      arguments:
          target, // Mengirim objek target untuk diedit (null jika mode Create)
    );

    // Menerima hasil (TargetItem yang sudah diupdate/dibuat)
    if (result != null && result is TargetItem) {
      setState(() {
        if (target != null && index != null) {
          // Mode Edit: Ganti item lama dengan hasil yang dikembalikan
          _targets[index] = result;
        } else {
          // Mode Create: Tambahkan item baru
          _targets.add(result);
        }
      });
    }
  }

  // --- CUSTOM DELETE CONFIRMATION DIALOG ---
  void _deleteTarget(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          // Content utama diatur di sini
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 50,
                color: ColorConst
                    .moodNegative, // Warna merah lembut untuk peringatan
              ),
              const SizedBox(height: 15),
              Text(
                'Konfirmasi Penghapusan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Apakah Anda yakin ingin menghapus target "${_targets[index].title}"? Tindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConst.secondaryTextGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Batal
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Batal',
                    style: TextStyle(color: ColorConst.primaryAccentGreen),
                  ),
                ),
                // Tombol Hapus (Aksi utama)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _targets.removeAt(index);
                    });
                    Get.back();
                    Get.snackbar(
                      'Target Dihapus',
                      'Target kebiasaan telah berhasil dihapus.',
                      backgroundColor: ColorConst.moodNegative.withOpacity(0.8),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.moodNegative,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.only(
            bottom: 10,
            left: 20,
            right: 20,
          ),
        );
      },
    );
  }
  // --- END CUSTOM DELETE CONFIRMATION DIALOG ---

  @override
  Widget build(BuildContext context) {
    final double fabHeightPadding = 80.0; // Ruang ekstra untuk FAB

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

      // Tombol Tambah (Floating Action Button)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addEditTarget(), // Navigasi ke halaman Create baru
        backgroundColor: ColorConst.primaryAccentGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Target',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

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
                // Menambahkan padding di bagian bawah ListView
                padding: EdgeInsets.fromLTRB(20, 20, 20, fabHeightPadding),
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
                    onPressed: () => _addEditTarget(
                      target: target,
                      index: index,
                    ), // Navigasi ke Edit Page
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
