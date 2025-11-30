import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';

// Import Mock Model TargetItem dari file Target Habit Page
// Asumsi TargetItem didefinisikan di ProfileTargetHabitPage.dart
class TargetItem {
  String id;
  String title;
  String frequency;
  bool isActive;
  bool isCompleted; // Menambahkan status complete untuk checklist

  TargetItem({
    required this.id,
    required this.title,
    required this.frequency,
    this.isActive = true,
    this.isCompleted = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0; // Default index for Home

  // Placeholder Data untuk MVP
  String userName = "Pengguna Senandika";
  int moodScore = 4; // Mock Mood Score
  final String crisisNumber = '1500451';

  // Mock Data Target (Menggunakan TargetItem)
  final List<TargetItem> _allTargets = [
    TargetItem(
      id: '1',
      title: 'Log Mood (Wajib Harian)',
      frequency: 'Harian',
      isCompleted: true,
    ),
    TargetItem(
      id: '2',
      title: 'Jalan kaki 10 menit',
      frequency: 'Harian',
      isCompleted: false,
    ),
    TargetItem(
      id: '3',
      title: 'Meditasi 5 menit',
      frequency: 'Harian',
      isCompleted: true,
    ),

    TargetItem(
      id: '4',
      title: 'Baca buku 15 menit',
      frequency: 'Mingguan',
      isCompleted: false,
    ),
    TargetItem(
      id: '5',
      title: 'Telepon teman',
      frequency: 'Mingguan',
      isCompleted: true,
    ),

    TargetItem(
      id: '6',
      title: 'Coba resep baru',
      frequency: 'Sekali Waktu',
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Implementasi navigasi antar tab
    switch (index) {
      case 0:
        // Tetap di sini
        break;
      case 1:
        Get.toNamed(RouteConstants.journal);
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
  }

  void _launchCrisisCall() {
    print('Calling Crisis Number: $crisisNumber');
    // Implementasi real call menggunakan url_launcher
  }

  String _getMoodEmoji(int score) {
    if (score >= 4) return '😊';
    if (score == 3) return '😐';
    return '😞';
  }

  // Helper untuk menghitung Progress berdasarkan frekuensi
  Map<String, int> _calculateProgress(String frequency) {
    final filteredGoals = _allTargets
        .where((t) => t.frequency == frequency && t.isActive)
        .toList();
    final completed = filteredGoals.where((t) => t.isCompleted).length;
    final total = filteredGoals.length;

    return {'completed': completed, 'total': total};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              onTap: () => Get.toNamed(RouteConstants.profile),
                              child: Icon(
                                Icons.account_circle,
                                color: ColorConst.primaryTextDark,
                                size: 28,
                              ),
                            ),

                            // Tombol Darurat (Emergency Quick Dial)
                            ElevatedButton.icon(
                              onPressed: _launchCrisisCall,
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

                        // Kartu Mood Log & Greetings (Awal Mood Log)
                        _buildMoodCard(),
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
                          color: ColorConst.secondaryTextGrey.withOpacity(0.1),
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
                            controller: _tabController,
                            indicatorColor: ColorConst.primaryAccentGreen,
                            labelColor: ColorConst.primaryTextDark,
                            unselectedLabelColor: ColorConst.secondaryTextGrey,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: [
                              Tab(text: 'Harian'),
                              Tab(text: 'Mingguan'),
                              Tab(text: 'Sekali Waktu'),
                            ],
                          ),
                        ),

                        // Tab Bar Content (Goals List + Progress Bar)
                        SizedBox(
                          height:
                              350, // Increased height to accommodate the internal progress bar
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildGoalListWithProgress('Harian'),
                              _buildGoalListWithProgress('Mingguan'),
                              _buildGoalListWithProgress('Sekali Waktu'),
                            ],
                          ),
                        ),

                        // Progress Bar Global (Ringkasan Total, ditempatkan di luar TabBarView)
                        _buildTotalSummary(),
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
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // --- Reusable Widgets ---

  Widget _buildMoodCard() {
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
          Text(
            'Halo, $userName!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorConst.primaryTextDark,
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
              Text(
                'Mood Hari Ini: ${_getMoodEmoji(moodScore)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
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

  // --- Widget Progress Bar Sederhana ---
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

  // --- Widget Gabungan List dan Progress Bar ---
  Widget _buildGoalListWithProgress(String frequency) {
    final goals = _allTargets
        .where((t) => t.frequency == frequency && t.isActive)
        .toList();
    final progress = _calculateProgress(frequency);

    return ListView(
      padding: EdgeInsets.zero, // Padding diatur di dalam item
      children: [
        // 1. Progress Bar untuk Tab yang Aktif
        _buildSimpleProgressBar(progress, frequency),

        // 2. Daftar Goals
        ...goals.map((goal) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Checkbox(
                  value: goal.isCompleted,
                  onChanged: (bool? newValue) {
                    setState(() {
                      goal.isCompleted = newValue!;
                    });
                  },
                  activeColor: ColorConst.successGreen,
                  checkColor: Colors.white,
                  side: BorderSide(
                    color: ColorConst.secondaryTextGrey.withOpacity(0.5),
                  ),
                ),
                Expanded(
                  child: Text(
                    goal.title,
                    style: TextStyle(
                      fontSize: 15,
                      color: goal.isCompleted
                          ? ColorConst.secondaryTextGrey
                          : ColorConst.primaryTextDark,
                      decoration: goal.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigasi ke Edit Page
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

        // Jarak bawah jika list pendek
        const SizedBox(height: 10),
      ],
    );
  }

  // --- Widget Ringkasan Total Keseluruhan ---
  Widget _buildTotalSummary() {
    final List<String> frequencies = ['Harian', 'Mingguan', 'Sekali Waktu'];
    int totalOverallCompleted = 0;
    int totalOverallGoals = 0;

    for (var frequency in frequencies) {
      final progress = _calculateProgress(frequency);
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
  }
  // --- End Widget Ringkasan Total Keseluruhan ---

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
}
