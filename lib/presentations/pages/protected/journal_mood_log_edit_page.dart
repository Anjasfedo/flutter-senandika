// presentations/pages/protected/journal_mood_log_edit_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/journal_mood_log_edit_controller.dart';

class JournalMoodLogEditPage extends GetView<JournalMoodLogEditController> {
  const JournalMoodLogEditPage({Key? key}) : super(key: key);

  // ❌ DIHAPUS: Helper _getMoodColor (Sekarang diambil dari controller)
  // Anda tidak perlu lagi mendefinisikan ulang fungsi di sini.

  // Widget untuk pemilih Mood (Sama seperti halaman Create, menggunakan Controller.getMoodColor)
  Widget _buildMoodSelector() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: controller.moods.map((mood) {
          final score = mood['score'] as int;
          final emoji = mood['emoji'] as String;
          final label = mood['label'] as String;
          final isSelected = controller.selectedMoodScore.value == score;

          final scaleFactor = isSelected ? 1.2 : 1.0;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.setSelectedMoodScore(score),
              child: AnimatedScale(
                scale: scaleFactor,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: SizedBox(
                  height: 85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          // 💡 PERUBAHAN: Ambil warna langsung dari Controller
                          color: controller
                              .getMoodColor(score)
                              .withValues(alpha: isSelected ? 1.0 : 0.4),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: ColorConst.primaryTextDark,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? ColorConst.primaryTextDark
                              : ColorConst.secondaryTextGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget untuk pemilih Tags Preset (Tidak ada perubahan)
  Widget _buildPresetTagSelector() {
    return Obx(
      () => Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: controller.availableTags.map((tag) {
          final isSelected = controller.selectedTags.contains(tag);

          return GestureDetector(
            onTap: () => controller.togglePresetTag(tag),
            child: Chip(
              label: Text(tag),
              backgroundColor: isSelected
                  ? ColorConst.primaryAccentGreen
                  : ColorConst.secondaryBackground,
              labelStyle: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : ColorConst.primaryTextDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: isSelected
                    ? BorderSide(
                        color: ColorConst.primaryAccentGreen,
                        width: 1.5,
                      )
                    : BorderSide.none,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget untuk menampilkan dan menghapus Tag Kustom (Tidak ada perubahan)
  Widget _buildCustomTagChips() {
    return Obx(
      () => Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: controller.selectedCustomTags
            .map(
              (tag) => Chip(
                label: Text(tag),
                backgroundColor: ColorConst.primaryAccentGreen,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: ColorConst.primaryAccentGreen,
                    width: 1.5,
                  ),
                ),
                onDeleted: () => controller.removeCustomTag(tag),
                deleteIcon: Icon(Icons.close, size: 16, color: Colors.white),
              ),
            )
            .toList(),
      ),
    );
  }

  // Widget Input Tag Kustom (Tidak ada perubahan)
  Widget _buildCustomTagInput() {
    return TextField(
      controller: controller.customTagController,
      textInputAction: TextInputAction.done,
      style: TextStyle(color: ColorConst.primaryTextDark),
      decoration: InputDecoration(
        hintText: 'Pemicu lainnya',
        hintStyle: TextStyle(
          color: ColorConst.secondaryTextGrey.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: ColorConst.secondaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: InkWell(
          onTap: () {
            controller.addCustomTag(controller.customTagController.text);
          },
          child: Icon(Icons.add_circle, color: ColorConst.primaryAccentGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorConst.primaryAccentGreen,
            width: 2,
          ),
        ),
      ),
      onSubmitted: (value) => controller.addCustomTag(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Jurnal Harian',
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
      body: Obx(() {
        if (controller.originalMoodLog.value == null &&
            controller.isLoading.isFalse) {
          // Tampilkan pesan jika log tidak ditemukan dan tidak sedang loading
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: ColorConst.moodNegative,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Gagal memuat jurnal untuk diedit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConst.moodNegative,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.moodNegative,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          );
        }

        // Tampilkan loading saat pertama kali memuat data atau saat update
        if (controller.isLoading.isTrue) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: ColorConst.ctaPeach),
                const SizedBox(height: 16),
                Text(
                  controller.originalMoodLog.value == null
                      ? 'Memuat data jurnal...'
                      : 'Menyimpan perubahan...',
                  style: TextStyle(
                    color: ColorConst.secondaryTextGrey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. MOOD QUICK LOG (MANDATORY) ---
                Text(
                  '1. Bagaimana perasaanmu pada hari ini?', // 💡 Teks disesuaikan
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConst.primaryTextDark,
                  ),
                ),
                const SizedBox(height: 16),

                // Mood Selector (Emoji)
                _buildMoodSelector(),

                const SizedBox(height: 30),

                // --- 2. JOURNAL ENTRY (OPTIONAL) ---
                Text(
                  '2. Catatan Jurnal (Opsional)', // 💡 Teks disesuaikan
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConst.primaryTextDark,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  'Apa satu hal yang paling memengaruhi moodmu pada hari ini?', // 💡 Teks disesuaikan
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorConst.secondaryTextGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: controller.journalController,
                  maxLines: 5,
                  maxLength: 500,
                  style: TextStyle(color: ColorConst.primaryTextDark),
                  decoration: InputDecoration(
                    hintText:
                        'Tuliskan pikiran, peristiwa, atau pemicu yang kamu rasakan...',
                    hintStyle: TextStyle(
                      color: ColorConst.secondaryTextGrey.withValues(alpha: 0.7),
                    ),
                    filled: true,
                    fillColor: ColorConst.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: ColorConst.primaryAccentGreen,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // --- 3. QUICK TAGS / TRIGGERS (OPTIONAL) ---
                Text(
                  '3. Tandai pemicu utama (Opsional)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConst.primaryTextDark,
                  ),
                ),
                const SizedBox(height: 10),

                _buildPresetTagSelector(),
                const SizedBox(height: 8),
                _buildCustomTagChips(),

                const SizedBox(height: 15),

                // 💡 INPUT TAG KUSTOM
                _buildCustomTagInput(),

                const SizedBox(height: 50),

                // 💡 Tombol Simpan/Update
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.isFalse
                        ? controller.updateLog
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.ctaPeach,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      disabledBackgroundColor: ColorConst.secondaryTextGrey
                          .withValues(alpha: 0.5),
                    ),
                    child: controller.isLoading.isTrue
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Perbarui Jurnal', // 💡 Teks tombol disesuaikan
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
    );
  }
}
