// presentations/pages/protected/journal_mood_log_show_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/data/models/mood_log_model.dart';
import 'package:senandika/presentations/controllers/journal_mood_log_show_controller.dart';

class JournalMoodLogShowPage extends GetView<JournalMoodLogShowController> {
  const JournalMoodLogShowPage({Key? key}) : super(key: key);

  // Widget untuk Chip Tags
  Widget _buildTags(List<String> tags) {
    if (tags.isEmpty) {
      return const Text(
        'Tidak ada pemicu yang ditandai.',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: ColorConst.secondaryTextGrey,
        ),
      );
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags
          .map(
            (tag) => Chip(
              label: Text(tag),
              backgroundColor: ColorConst.secondaryAccentLavender,
              labelStyle: TextStyle(
                color: ColorConst.primaryTextDark,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )
          .toList(),
    );
  }

  // Widget untuk Detail Log
  Widget _buildLogDetail(MoodLogModel log) {
    final moodEmoji = controller.getMoodEmoji(log.score);
    final moodColor = controller.getMoodColor(log.score);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Mood & Tanggal ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: moodColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: moodColor),
            ),
            child: Row(
              children: [
                Text(moodEmoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood pada ${log.formattedDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConst.secondaryTextGrey,
                      ),
                    ),
                    Text(
                      'Skor: ${log.score}/5',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.primaryTextDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- Catatan Jurnal ---
          Text(
            'Catatan Jurnal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConst.primaryTextDark,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorConst.secondaryTextGrey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              log.text.isNotEmpty
                  ? log.text
                  : "Tidak ada catatan terperinci untuk log ini.",
              style: TextStyle(
                fontSize: 16,
                color: ColorConst.primaryTextDark,
                fontStyle: log.text.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // --- Pemicu/Tags ---
          Text(
            'Pemicu/Tags',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConst.primaryTextDark,
            ),
          ),
          const SizedBox(height: 10),
          _buildTags(log.tags),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        // 💡 PERUBAHAN 1: Tengahkan judul
        centerTitle: true,
        title: Text(
          'Detail Jurnal',
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
        // 💡 PERUBAHAN 2: Tambahkan ikon Edit ke actions
        actions: [
          Obx(() {
            // Tampilkan ikon edit hanya jika log sudah dimuat
            if (controller.moodLog.value != null &&
                controller.isLoading.isFalse) {
              return IconButton(
                icon: Icon(Icons.edit, color: ColorConst.primaryTextDark),
                onPressed: () {
                  Get.toNamed(
                    RouteConstants.journal_mood_log_edit,
                    arguments:
                        controller.moodLog.value, // Mengirim MoodLogModel
                  );
                },
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Panggil pemuatan ulang menggunakan ID log yang sudah ada
          if (controller.logId != null) {
            await controller.loadLogDetail(controller.logId!);
          }
        },
        child: Obx(() {
          if (controller.isLoading.isTrue) {
            return Center(
              child: CircularProgressIndicator(color: ColorConst.ctaPeach),
            );
          }

          final log = controller.moodLog.value;
          if (log == null) {
            return Center(
              child: Text(
                'Gagal memuat detail jurnal.',
                style: TextStyle(color: ColorConst.moodNegative),
              ),
            );
          }

          return _buildLogDetail(log);
        }),
      ),
    );
  }
}
