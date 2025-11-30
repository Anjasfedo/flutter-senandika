import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/color_constant.dart'; // Import color constants
import 'package:senandika/constants/route_constant.dart'; // Import route constants

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Default index for Home

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Implementasi navigasi antar tab, di MVP ini diasumsikan selalu kembali ke Home saat index 0
    // Dalam aplikasi multi-screen, Get.toNamed akan digunakan untuk navigasi
    switch (index) {
      case 0:
        Get.toNamed(RouteConstants.home);
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

  // Placeholder Data untuk MVP
  String userName = "Pengguna Senandika";
  int moodScore = 4; // 1-5 scale
  int goalsCompleted = 2;
  int goalsTotal = 3;

  // Placeholder List of Daily Goals/Targets
  final List<String> dailyTargets = [
    'Log Mood (Wajib Harian)',
    'Jalan kaki 10 menit',
    'Latihan Pernapasan (4-7-8)',
  ];

  // Placeholder untuk State Checklist
  final List<bool> targetStatus = [true, false, true];

  // Emergency Call Action (Nomor krisis nasional Indonesia: 112/119 atau 1500451)
  final String crisisNumber = '1500451';

  void _launchCrisisCall() async {
    // Implementasi panggilan telepon menggunakan url_launcher (diabaikan di sini, hanya logika)
    // const url = 'tel:$crisisNumber';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   // handle error
    // }
    print('Calling Crisis Number: $crisisNumber');
  }

  // Helper untuk menampilkan mood emoji
  String _getMoodEmoji(int score) {
    if (score >= 4) return '😊';
    if (score == 3) return '😐';
    return '😞';
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
                // 1. The Lavender Background (Menggunakan Secondary Accent)
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // Mengganti Gradient ungu dengan solid color/gradient yang tenang
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
                            // Ikon Profil
                            Icon(
                              Icons.account_circle,
                              color: ColorConst.primaryTextDark,
                              size: 28,
                            ),

                            // Tombol Darurat (Emergency Quick Dial)
                            ElevatedButton.icon(
                              onPressed: _launchCrisisCall,
                              icon: const Icon(Icons.call, size: 18),
                              label: const Text('Krisis'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorConst.crisisOrange, // Warna Kritis
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          // Menggunakan warna background card yang kontras tapi lembut
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
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ColorConst.secondaryTextGrey,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Mood Selector Mockup (Aksi Quick Log)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      // Action: Navigate to Quick Log Modal/Journal Page
                                      Get.toNamed(RouteConstants.journal);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorConst
                                          .ctaPeach, // CTA Peach color
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
                        ),
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
                  // --- Progress Monitoring (Goals) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Target Harianmu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConst.primaryTextDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to Goal Settings (Profile Menu)
                          Get.toNamed(RouteConstants.profile);
                        },
                        child: Text(
                          'Atur Target >',
                          style: TextStyle(
                            color: ColorConst.primaryAccentGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Progress Bar Mockup
                  LinearProgressIndicator(
                    value: goalsCompleted / goalsTotal,
                    backgroundColor: ColorConst.secondaryBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorConst.primaryAccentGreen,
                    ),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${goalsCompleted} dari ${goalsTotal} Selesai (${((goalsCompleted / goalsTotal) * 100).toStringAsFixed(0)}%)',
                    style: TextStyle(
                      color: ColorConst.secondaryTextGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Checklist of Goals
                  ...List.generate(dailyTargets.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: targetStatus[index],
                            onChanged: (bool? newValue) {
                              setState(() {
                                // Logika untuk update status goal
                                targetStatus[index] = newValue!;
                                // Update goal counter here in real app
                              });
                            },
                            activeColor: ColorConst.successGreen,
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: ColorConst.secondaryTextGrey.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              dailyTargets[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: targetStatus[index]
                                    ? ColorConst.secondaryTextGrey
                                    : ColorConst.primaryTextDark,
                                decoration: targetStatus[index]
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  // --- Quick Action: Guided Breathing (Meditation Menu) ---
                  Text(
                    'Aksi Cepat: Tenangkan Diri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConst.primaryTextDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorConst.secondaryBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latihan Pernapasan 4-7-8',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorConst.primaryTextDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '3 Menit untuk meredakan cemas',
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
                  ),

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
}
