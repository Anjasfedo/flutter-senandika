import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/presentations/controllers/home_controller.dart'; // Import Controller Anda

// Hapus definisi TargetItem di sini karena sudah dipindahkan ke home_controller.dart
// class TargetItem { ... }

// Ganti dari StatefulWidget menjadi GetView
class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ⚠️ Hapus semua state (_tabController, _selectedIndex, dll.) dari sini
    // dan pindahkan ke Controller/state local jika benar-benar diperlukan.
    // Untuk TabController, biasanya dibuat di initState, jadi kita akan buat di dalam build atau pindah ke Controller.

    // Kita buat TabController di sini (state lokal) karena membutuhkan vsync (SingleTickerProviderStateMixin),
    // atau jika ingin memindahkannya ke Controller, HomeController harus menggunakan GetSingleTickerProviderStateMixin.
    // Untuk kesederhanaan, kita gunakan DefaultTabController atau biarkan state internal yang minimal.

    // Karena tidak ada state lokal yang kompleks selain TabController,
    // kita gunakan DefaultTabController jika mungkin, atau kita buat TabController lokal
    // dan letakkan TabBarView di Obx.

    // Menggunakan DefaultTabController untuk menghindari State/Mixin di Controller
    return DefaultTabController(
      length: 3, // Harian, Mingguan, Sekali Waktu
      child: Scaffold(
        backgroundColor: ColorConst.primaryBackgroundLight,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Top Section with Stack (Lavender BG + overlapping Card)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. The Lavender Background
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorConst.secondaryAccentLavender,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConst.secondaryTextGrey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),

                  // 2. The Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notifikasi dan Tombol Darurat
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Placeholder Icon (seharusnya mengarah ke Profile Edit)
                              GestureDetector(
                                onTap: () => controller.navigateTo(
                                  4,
                                ), // Navigasi ke Profile
                                child: _buildAvatarHeader(controller),
                              ),

                              // Tombol Darurat (Emergency Quick Dial)
                              ElevatedButton.icon(
                                onPressed: controller
                                    .launchCrisisCall, // ⬅️ Panggil Controller
                                icon: const Icon(Icons.call, size: 18),
                                label: const Text('Krisis'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConst.crisisOrange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Kartu Mood Log & Greetings
                          _buildMoodCard(controller), // ⬅️ Teruskan controller
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Main Body Content: Goals and Quick Actions
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Progress Monitoring (Tabs) ---
                    Text(
                      'Target dan Kemajuanmu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.primaryTextDark,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Tab Bar View Container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: ColorConst.secondaryTextGrey.withOpacity(
                              0.1,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Custom Tab Bar
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 10,
                              right: 10,
                            ),
                            child: TabBar(
                              // Gunakan DefaultTabController
                              indicatorColor: ColorConst.primaryAccentGreen,
                              labelColor: ColorConst.primaryTextDark,
                              unselectedLabelColor:
                                  ColorConst.secondaryTextGrey,
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: const [
                                Tab(text: 'Harian'),
                                Tab(text: 'Mingguan'),
                                Tab(text: 'Sekali Waktu'),
                              ],
                            ),
                          ),

                          // Tab Bar Content (Goals List + Progress Bar)
                          SizedBox(
                            height: 350,
                            child: TabBarView(
                              children: [
                                _buildGoalListWithProgress(
                                  'Harian',
                                  controller,
                                ),
                                _buildGoalListWithProgress(
                                  'Mingguan',
                                  controller,
                                ),
                                _buildGoalListWithProgress(
                                  'Sekali Waktu',
                                  controller,
                                ),
                              ],
                            ),
                          ),

                          // Progress Bar Global
                          _buildTotalSummary(controller),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- Quick Action: Guided Breathing (Meditation Menu) ---
                    _buildQuickActionCard(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: 0, // Default 0
          onItemTapped: controller.navigateTo,
        ),
      ),
    );
  }

  // --- Reusable Widgets (diubah menjadi metode statis atau metode non-state) ---

  // Mood Card (Menggunakan Obx untuk nama pengguna)
  Widget _buildMoodCard(HomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              // ⬅️ Menggunakan Obx untuk nama
              'Halo, ${controller.userName.value}!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorConst.primaryTextDark,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bagaimana perasaanmu saat ini?',
            style: TextStyle(fontSize: 16, color: ColorConst.secondaryTextGrey),
          ),
          const SizedBox(height: 16),

          // Mood Selector Mockup (Aksi Quick Log)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  // ⬅️ Menggunakan Obx untuk mood score
                  'Mood Hari Ini: ${controller.getMoodEmoji(controller.moodScore.value)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConst.primaryTextDark,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(RouteConstants.journal_mood_log);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConst.ctaPeach,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text('Log Mood'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Progress Bar Sederhana
  Widget _buildSimpleProgressBar(Map<String, int> progress, String frequency) {
    final completed = progress['completed']!;
    final total = progress['total']!;
    final ratio = total == 0 ? 0.0 : completed / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kemajuan Target $frequency:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorConst.primaryTextDark,
                ),
              ),
              Text(
                '${(ratio * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorConst.primaryAccentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: ratio,
            backgroundColor: ColorConst.secondaryBackground,
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorConst.primaryAccentGreen,
            ),
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 5),
          Text(
            '$completed dari $total Selesai',
            style: TextStyle(color: ColorConst.secondaryTextGrey, fontSize: 14),
          ),
          const Divider(height: 30, thickness: 1),
        ],
      ),
    );
  }

  // Widget Gabungan List dan Progress Bar
  Widget _buildGoalListWithProgress(
    String frequency,
    HomeController controller,
  ) {
    // Menggunakan Obx untuk mereaksi perubahan di allTargets dan isCompleted
    return Obx(() {
      final goals = controller.allTargets
          .where((t) => t.frequency == frequency && t.isActive)
          .toList();
      final progress = controller.calculateProgress(frequency);

      return ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. Progress Bar untuk Tab yang Aktif
          _buildSimpleProgressBar(progress, frequency),

          // 2. Daftar Goals
          ...goals.map((goal) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Obx(
                    () => Checkbox(
                      // ⬅️ Obx untuk reaktivitas Checkbox
                      value: goal.isCompleted.value,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          controller.toggleTargetCompletion(
                            goal,
                            newValue,
                          ); // ⬅️ Panggil Controller
                        }
                      },
                      activeColor: ColorConst.successGreen,
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: ColorConst.secondaryTextGrey.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        // ⬅️ Obx untuk reaktivitas Text
                        goal.title,
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              goal
                                  .isCompleted
                                  .value // ⬅️ Gunakan .value
                              ? ColorConst.secondaryTextGrey
                              : ColorConst.primaryTextDark,
                          decoration: goal.isCompleted.value
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(
                        RouteConstants.profile_target_habit_form,
                        arguments: goal,
                      );
                    },
                    icon: Icon(
                      Icons.chevron_right,
                      color: ColorConst.secondaryTextGrey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 10),
        ],
      );
    });
  }

  // Widget Ringkasan Total Keseluruhan
  Widget _buildTotalSummary(HomeController controller) {
    return Obx(() {
      // ⬅️ Obx untuk reaktivitas Total Summary
      final List<String> frequencies = ['Harian', 'Mingguan', 'Sekali Waktu'];
      int totalOverallCompleted = 0;
      int totalOverallGoals = 0;

      for (var frequency in frequencies) {
        final progress = controller.calculateProgress(frequency);
        totalOverallCompleted += progress['completed']!;
        totalOverallGoals += progress['total']!;
      }

      final ratio = totalOverallGoals == 0
          ? 0.0
          : totalOverallCompleted / totalOverallGoals;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Total Kemajuan:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConst.primaryTextDark,
              ),
            ),
            const SizedBox(height: 8),

            if (totalOverallGoals > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: ColorConst.secondaryAccentLavender,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorConst.ctaPeach,
                    ),
                    minHeight: 15,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$totalOverallCompleted dari $totalOverallGoals Target Selesai (${(ratio * 100).toStringAsFixed(0)}% Keseluruhan)',
                    style: TextStyle(
                      color: ColorConst.secondaryTextGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            else
              Text(
                'Belum ada target yang aktif untuk dihitung.',
                style: TextStyle(
                  color: ColorConst.secondaryTextGrey,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildQuickActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConst.secondaryBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: ColorConst.secondaryTextGrey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aksi Cepat: Tenangkan Diri',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorConst.primaryTextDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Latihan Pernapasan 4-7-8',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConst.secondaryTextGrey,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Get.toNamed(RouteConstants.meditation);
            },
            icon: Icon(
              Icons.play_circle_fill,
              size: 36,
              color: ColorConst.primaryAccentGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarHeader(HomeController controller) {
    return Obx(() {
      final String url = controller.avatarUrl.value;

      // Jika URL tidak null dan tidak kosong
      if (url.isNotEmpty) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ColorConst.primaryTextDark, width: 1.5),
            image: DecorationImage(
              image: NetworkImage(url), // ⬅️ Tampilkan NetworkImage
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        // Default: Ikon
        return Icon(
          Icons.account_circle,
          color: ColorConst.primaryTextDark,
          size: 28,
        );
      }
    });
  }
}
