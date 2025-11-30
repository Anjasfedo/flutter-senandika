import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/color_constant.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // --- Data & Helpers untuk Mock Kalender ---
  final Map<int, int> mockMonthlyMoods = {
    1: 4,
    2: 3,
    3: 5,
    4: 2,
    5: 4,
    6: 5,
    7: 3,
    8: 4,
    9: 4,
    10: 5,
    11: 3,
    12: 2,
    13: 1,
    14: 3,
    15: 4,
    16: 5,
    17: 4,
    18: 3,
    19: 5,
    20: 5,
    21: 4,
    22: 3,
    23: 2,
    24: 4,
    25: 4,
    26: 5,
    27: 3,
    28: 4,
    29: 3,
    30: 5,
  };

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

  String _getMoodEmoji(int score) {
    switch (score) {
      case 5:
        return '🤩';
      case 4:
        return '😊';
      case 3:
        return '😐';
      case 2:
        return '😟';
      case 1:
        return '😭';
      default:
        return '❓';
    }
  }

  Widget _buildMonthCalendar(String monthName, Map<int, int> moods) {
    final daysInMonth = 30;
    // Asumsi bulan dimulai dari hari Rabu (index 3), jadi kita butuh 4 hari kosong di awal
    final firstDayOffset = 4;

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

        // FIXED: Grid of Moods dengan perhitungan yang benar
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1.0,
          ),
          // Total items = offset awal + jumlah hari dalam bulan
          // Kita butuh 6 baris (42 items) untuk menampung semua hari
          itemCount: 42, // 6 weeks * 7 days = 42 items
          itemBuilder: (context, index) {
            // Hitung hari berdasarkan index dan offset
            final dayIndex = index - firstDayOffset + 1;

            // Jika index berada sebelum offset atau setelah hari terakhir, tampilkan container kosong
            if (index < firstDayOffset - 1 ||
                dayIndex > daysInMonth ||
                dayIndex < 1) {
              return Container(); // Hari kosong
            }

            final mood = moods[dayIndex] ?? 0;
            final color = _getMoodColor(mood);
            final emoji = _getMoodEmoji(mood);

            return InkWell(
              onTap: () {
                print('Tapped day $dayIndex');
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                  border:
                      dayIndex == DateTime.now().day &&
                          monthName == 'November 2025'
                      ? Border.all(
                          color: ColorConst.primaryTextDark,
                          width: 1.5,
                        )
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
                        fontSize: 9,
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

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

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
              left: 16,
              right: 16,
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

                // Tombol Mulai Senandika Baru
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
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Navigasi Bulan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorConst.primaryTextDark,
                          size: 16,
                        ),
                        onPressed: () {
                          print('Previous Month');
                        },
                      ),
                      Text(
                        'November 2025',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConst.primaryTextDark,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: ColorConst.primaryTextDark,
                          size: 16,
                        ),
                        onPressed: () {
                          print('Next Month');
                        },
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
                    child: SizedBox(
                      height: 300, // Increased height to accommodate 6 rows
                      child: PageView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          if (index == 1) {
                            return _buildMonthCalendar(
                              'November 2025',
                              mockMonthlyMoods,
                            );
                          }
                          return Center(
                            child: Text(
                              index == 0 ? 'Oktober 2025' : 'Desember 2025',
                              style: TextStyle(
                                color: ColorConst.secondaryTextGrey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Riwayat Entri Jurnal
                  Text(
                    'Riwayat Entri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConst.primaryTextDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // List of Placeholder Items
                  ...List.generate(4, (index) {
                    final isPositive = index.isEven;
                    final entryDay = 30 - index;
                    final moodEntry = mockMonthlyMoods[entryDay] ?? 3;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ColorConst.secondaryTextGrey.withOpacity(
                              0.1,
                            ),
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
                            '${entryDay} November 2025 - Mood: ${_getMoodEmoji(moodEntry)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorConst.secondaryTextGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isPositive
                                ? 'Refleksi hari ini: Saya berhasil menyelesaikan semua target harian dan merasa lega setelah sesi pernapasan.'
                                : 'Saya merasa lelah dan tag "Work Stress" muncul lagi. Chatbot Senandika memberi validasi yang menenangkan.',
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorConst.primaryTextDark,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Baca Selengkapnya >',
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
                  }),
                  const SizedBox(height: 16),
                ],
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
              break;
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
