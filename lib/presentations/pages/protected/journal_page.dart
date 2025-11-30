import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/journal_controller.dart';
import 'package:senandika/data/models/mood_log_model.dart'; // Import Model

class JournalPage extends GetView<JournalController> {
  const JournalPage({Key? key}) : super(key: key);

  // Helper untuk mendapatkan nama bulan (digunakan di UI)
  String _getMonthYear(DateTime date) {
    const List<String> monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  // --- Kalender Builder (Diperbarui) ---
  Widget _buildMonthCalendar(DateTime month, Map<int, int> moods) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Hitung offset hari pertama (0=Senin, 6=Minggu). Kita konversi ke 0=Min, 6=Sab.
    final firstDayWeekday = DateTime(month.year, month.month, 1).weekday % 7;

    // Kita butuh 6 baris (42 items) untuk menampung semua hari
    return Column(
      children: [
        // Headers Hari
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
              .map(
                (day) => SizedBox(
                  width: 32,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConst.secondaryTextGrey,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const Divider(height: 8, thickness: 1),

        // Grid of Moods
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1.0,
          ),
          itemCount: daysInMonth + firstDayWeekday,
          itemBuilder: (context, index) {
            // Hitung hari berdasarkan index dan offset
            final dayIndex = index - firstDayWeekday + 1;

            if (dayIndex <= 0 || dayIndex > daysInMonth) {
              return Container(); // Hari kosong
            }

            final mood = moods[dayIndex] ?? 0;
            final color = controller.getMoodColor(mood);
            final emoji = controller.getMoodEmoji(mood);

            final isToday =
                dayIndex == DateTime.now().day &&
                month.month == DateTime.now().month &&
                month.year == DateTime.now().year;

            return InkWell(
              onTap: () {
                // Navigasi ke detail jurnal/mood log untuk tanggal ini
                // Get.toNamed(RouteConstants.journal_mood_log, arguments: DateTime(month.year, month.month, dayIndex));
                print('Tapped day $dayIndex/${month.month}/${month.year}');
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday
                      ? Border.all(color: ColorConst.ctaPeach, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 14)),
                    Text(
                      dayIndex.toString(),
                      style: TextStyle(
                        color: mood > 3
                            ? ColorConst.primaryTextDark
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  // --- End Calendar Builder ---

  // --- Builder untuk Riwayat Entri ---
  Widget _buildJournalEntryCard(MoodLogModel log) {
    final isPositive = log.score > 3;
    final textSnippet = log.text.isEmpty
        ? "Tidak ada catatan jurnal."
        : log.text;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorConst.secondaryTextGrey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isPositive
              ? ColorConst.primaryAccentGreen.withOpacity(0.5)
              : ColorConst.moodNegative.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${log.timestamp.day} ${_getMonthYear(log.timestamp)} - Mood: ${controller.getMoodEmoji(log.score)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorConst.secondaryTextGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            textSnippet,
            style: TextStyle(
              fontSize: 14,
              color: ColorConst.primaryTextDark,
              fontStyle: log.text.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              log.text.isEmpty ? 'Lihat Detail' : 'Baca Selengkapnya >',
              style: TextStyle(
                color: ColorConst.primaryAccentGreen,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder untuk Empty State
  Widget _buildJournalEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 60,
              color: ColorConst.secondaryTextGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum ada entri jurnal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConst.secondaryTextGrey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Catat mood dan pikiran Anda hari ini untuk melihat pola emosi Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorConst.secondaryTextGrey),
            ),
          ],
        ),
      ),
    );
  }

  // --- End Builder ---

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Header dan Tombol Journaling Baru
          Container(
            height: 180 + statusBarHeight,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: statusBarHeight + 10,
              left: 24, // Padding horizontal disesuaikan
              right: 24, // Padding horizontal disesuaikan
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: ColorConst.secondaryAccentLavender,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConst.secondaryTextGrey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jurnal Batinmu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorConst.primaryTextDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Lihat pola emosimu dan catat pengalaman barumu.',
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorConst.secondaryTextGrey,
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Tambah Mood Hari Ini
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(RouteConstants.journal_mood_log);
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Tambahkan Mood Hari Ini',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.ctaPeach,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Konten Utama
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0, // Disesuaikan
                vertical: 16.0,
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Navigasi Bulan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color:
                                controller.focusedMonth.value.year * 100 +
                                        controller.focusedMonth.value.month ==
                                    controller.focusedMonthKey(now)
                                ? ColorConst.secondaryTextGrey.withOpacity(0.5)
                                : ColorConst.primaryTextDark,
                            size: 16,
                          ),
                          onPressed: controller.goToPreviousMonth, // ⬅️ Handler
                        ),

                        Text(
                          _getMonthYear(
                            controller.focusedMonth.value,
                          ), // ⬅️ Reaktif
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorConst.primaryTextDark,
                          ),
                        ),

                        // Tombol Next: Dinonaktifkan jika bulan adalah bulan saat ini
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color:
                                (controller.focusedMonth.value.year ==
                                        now.year &&
                                    controller.focusedMonth.value.month ==
                                        now.month)
                                ? ColorConst.secondaryTextGrey.withOpacity(0.5)
                                : ColorConst.primaryTextDark,
                            size: 16,
                          ),
                          // ⬅️ Tombol dinonaktifkan jika bulan == bulan sekarang
                          onPressed:
                              (controller.focusedMonth.value.year == now.year &&
                                  controller.focusedMonth.value.month ==
                                      now.month)
                              ? null
                              : controller.goToNextMonth,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Kalender
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorConst.secondaryBackground,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // ⚠️ Kita hapus PageView.builder karena ini bertentangan dengan
                      // logika Controller yang berbasis satu bulan yang fokus (focusedMonth).
                      child:
                          controller.isLoading.isTrue &&
                              controller.currentMonthMoodScores.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(30.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _buildMonthCalendar(
                              controller.focusedMonth.value,
                              controller.currentMonthMoodScores,
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Riwayat Entri
                    Text(
                      'Riwayat Entri',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.primaryTextDark,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // List of Entries (Conditional rendering)
                    controller.currentMonthLogs.isEmpty &&
                            !controller.isLoading.value
                        ? _buildJournalEmptyState() // Empty state
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.currentMonthLogs.length,
                            itemBuilder: (context, index) {
                              final log = controller.currentMonthLogs[index];
                              return _buildJournalEntryCard(log);
                            },
                          ),

                    // Jarak tambahan di bawah list
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Get.toNamed(RouteConstants.home);
              break;
            case 1:
              break; // Tetap di sini
            case 2:
              Get.toNamed(RouteConstants.meditation);
              break;
            case 3:
              Get.toNamed(RouteConstants.chat);
              break;
            case 4:
              Get.toNamed(RouteConstants.profile);
              break;
          }
        },
      ),
    );
  }
}
