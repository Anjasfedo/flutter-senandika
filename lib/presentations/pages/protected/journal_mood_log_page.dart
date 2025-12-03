import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/journal_mood_log_controller.dart';

// Ganti StatefulWidget menjadi GetView
class JournalMoodLogPage extends GetView<JournalMoodLogController> {
  const JournalMoodLogPage({Key? key}) : super(key: key);

  // Helper untuk mendapatkan warna mood (Dipindahkan ke Controller, tapi disalin di sini untuk helper UI)
  Color _getMoodColor(int score) {
    switch (score) {
      case 5:
        return ColorConst.moodPositive;
      case 4:
        return ColorConst.primaryAccentGreen.withOpacity(0.8);
      case 3:
        return ColorConst.moodNeutral;
      case 2:
        return ColorConst.secondaryTextGrey.withOpacity(0.5);
      case 1:
        return ColorConst.moodNegative;
      default:
        return Colors.transparent;
    }
  }

  // Widget untuk pemilih Mood
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
                          color: _getMoodColor(
                            score,
                          ).withOpacity(isSelected ? 1.0 : 0.4),
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

  // Widget untuk pemilih Tags Preset
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
              // 💡 DIUBAH MENJADI CHIP
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
                        // Tambahkan border jika terpilih
                        color: ColorConst.primaryAccentGreen,
                        width: 1.5,
                      )
                    : BorderSide.none,
              ),
              // TIDAK ADA deleteIcon di sini
            ),
          );
        }).toList(),
      ),
    );
  }

  // 💡 BARU: Widget untuk menampilkan dan menghapus Tag Kustom
  Widget _buildCustomTagChips() {
    return Obx(
      () => Wrap(
        spacing: 8.0, // Sesuaikan spacing agar sama dengan preset
        runSpacing: 8.0,
        children: controller.selectedCustomTags
            .map(
              (tag) => Chip(
                label: Text(tag),
                // Warna & Gaya disesuaikan agar sama dengan preset saat dipilih
                backgroundColor: ColorConst
                    .primaryAccentGreen, // Anggap tag kustom selalu "terpilih"
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

                // ⬅️ LOGIKA HAPUS TAG KUSTOM
                onDeleted: () => controller.removeCustomTag(tag),
                deleteIcon: Icon(
                  // 💡 ICON HAPUS
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // 💡 BARU: Widget Input Tag Kustom
  Widget _buildCustomTagInput() {
    return TextField(
      controller:
          controller.customTagController, // ⬅️ Gunakan controller kustom
      textInputAction: TextInputAction.done,
      style: TextStyle(color: ColorConst.primaryTextDark),
      decoration: InputDecoration(
        hintText: 'Pemicu lainnya',
        hintStyle: TextStyle(
          color: ColorConst.secondaryTextGrey.withOpacity(0.7),
        ),
        filled: true,
        fillColor: ColorConst.secondaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: InkWell(
          // ⬅️ InkWell untuk menangani tap pada ikon
          onTap: () {
            // Panggil handler addCustomTag saat ikon ditekan
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
      // ⬅️ Handler saat user menekan 'Done' pada keyboard
      onSubmitted: (value) => controller.addCustomTag(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Catat Jurnal Harian',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. MOOD QUICK LOG (MANDATORY) ---
              Text(
                '1. Bagaimana perasaanmu sekarang?',
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
                '2. Ceritakan lebih banyak (Opsional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Apa satu hal yang paling memengaruhi moodmu hari ini, baik positif maupun negatif?',
                style: TextStyle(
                  fontSize: 15,
                  color: ColorConst.secondaryTextGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: controller.journalController, // ⬅️ Controller
                maxLines: 5,
                maxLength: 500,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: InputDecoration(
                  hintText:
                      'Tuliskan pikiran, peristiwa, atau pemicu yang kamu rasakan...',
                  hintStyle: TextStyle(
                    color: ColorConst.secondaryTextGrey.withOpacity(0.7),
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

              const SizedBox(height: 15),

              // --- Tombol Simpan ---
              Obx(
                () => SizedBox(
                  // ⬅️ Bungkus tombol dengan Obx
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.isFalse
                        ? controller.saveLog
                        : null, // ⬅️ Handler
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
                            'Simpan Log Jurnal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
