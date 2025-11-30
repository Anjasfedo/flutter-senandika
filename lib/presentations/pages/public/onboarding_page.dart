import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- Konten Onboarding yang Disesuaikan untuk Senandika ---
  final List<Map<String, dynamic>> _onboardingContent = [
    {
      'icon': Icons.edit_note, // Jurnal & Mood Log
      'title': 'Kenali Pola Diri Lewat Senandika',
      'subtitle':
          'Catat suasana hati harianmu dan kenali pemicu emosi dengan fitur jurnal yang terintegrasi. Kesadaran adalah langkah pertama. Kami menyediakan ruang aman untuk merefleksikan perasaan terdalammu tanpa penghakiman.',
      'showButton': false,
    },
    {
      'icon': Icons.psychology_alt, // Chatbot & Dukungan
      'title': 'Temukan Jawaban dalam Dialog Batin',
      'subtitle':
          'Senandika, Chatbot kontekstual, akan memandu refleksi berdasarkan riwayat jurnalmu. Dapatkan dukungan kapan saja, tanpa rasa cemas, dan ubah pola pikir negatifmu.',
      'showButton': false,
    },
    {
      'icon': Icons.track_changes, // Goals & Breathing
      'title': 'Mulai Tumbuh, Satu Langkah Sehari',
      'subtitle':
          'Terapkan kebiasaan positif dengan menetapkan tujuan kecil yang terukur (Progress Targets) dan tenangkan pikiran dengan teknik pernapasan yang teruji ilmiah.',
      'showButton': true,
    },
  ];
  // -----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.toNamed(RouteConstants.login);
                },
                child: Text(
                  'Lewati',
                  style: TextStyle(
                    color: ColorConst.secondaryTextGrey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // PageView for the onboarding screens (Expanded agar mengambil sisa ruang)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingContent.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    icon: _onboardingContent[index]['icon'] as IconData,
                    title: _onboardingContent[index]['title'] as String,
                    subtitle: _onboardingContent[index]['subtitle'] as String,
                    showButton: _onboardingContent[index]['showButton'] as bool,
                  );
                },
              ),
            ),

            // Bagian Bawah: Page Indicators dan Tombol Aksi
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_onboardingContent.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? ColorConst.primaryAccentGreen
                              : ColorConst.secondaryAccentLavender.withOpacity(
                                  0.7,
                                ),
                        ),
                      );
                    }),
                  ),

                  // Tombol Aksi (Next / Finish Button)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 40,
                      right: 40,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: _currentPage == _onboardingContent.length - 1
                          ? // Tombol Halaman Terakhir (Masuk)
                            ElevatedButton(
                              onPressed: () {
                                Get.toNamed(RouteConstants.login);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConst.ctaPeach,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Mulai Masuk ke Senandika',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : // Tombol Halaman 1 & 2 (Lanjut)
                            OutlinedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: ColorConst.primaryAccentGreen,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Lanjut',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConst.primaryAccentGreen,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Unified Builder
  Widget _buildOnboardingPage({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool showButton,
  }) {
    // Membungkus konten dengan SingleChildScrollView untuk mengatasi overflow
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          // Gunakan mainAxisSize.min agar Column hanya mengambil tinggi yang diperlukan
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Jarak tambahan di atas
            const SizedBox(height: 30),

            // 1. Image/Icon Placeholder
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorConst.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ColorConst.secondaryTextGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 100,
                  color: ColorConst.primaryAccentGreen,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 2. Title
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ColorConst.primaryTextDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 3. Subtitle (Description)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: ColorConst.secondaryTextGrey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Memberikan jarak yang cukup di bawah konten
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
