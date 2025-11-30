import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/route_constant.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({Key? key}) : super(key: key);

  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Durasi Siklus Pernapasan 4-7-8
  static const int inhaleDuration = 4; // Inhale 4s
  static const int holdDuration = 7; // Hold 7s
  static const int exhaleDuration = 8; // Exhale 8s
  static const int totalCycleDuration =
      inhaleDuration + holdDuration + exhaleDuration; // Total 19s

  // Keterangan Teks yang akan berganti
  String _currentInstruction = "Sentuh untuk Mulai";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: totalCycleDuration),
    );

    // Animation for scaling the circle (0.5 to 1.0)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);

    // Listener untuk mengubah teks instruksi berdasarkan waktu siklus
    _controller.addListener(() {
      final time = _controller.value * totalCycleDuration;
      setState(() {
        if (time < inhaleDuration) {
          _currentInstruction = "Tarik Napas (4)";
        } else if (time < inhaleDuration + holdDuration) {
          _currentInstruction = "Tahan (7)";
        } else {
          _currentInstruction = "Hembuskan (8)";
        }
      });
    });

    // Listener untuk mengulang siklus setelah selesai
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat(); // Ulangi terus menerus
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleBreathing() {
    if (_controller.isAnimating) {
      _controller.stop();
      setState(() {
        _currentInstruction = "Jeda. Sentuh untuk Lanjut";
      });
    } else {
      if (_controller.value == 0.0) {
        // Mulai dari awal jika belum pernah dimulai
        _controller.forward();
      } else {
        // Lanjutkan jika dipause
        _controller.repeat();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Latihan Pernapasan',
          style: TextStyle(color: ColorConst.primaryTextDark),
        ),
        backgroundColor: ColorConst.secondaryAccentLavender,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConst.primaryTextDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Teknik 4-7-8',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ColorConst.primaryTextDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sentuh lingkaran untuk memulai sesi.',
              style: TextStyle(
                fontSize: 16,
                color: ColorConst.secondaryTextGrey,
              ),
            ),

            const SizedBox(height: 50),

            // --- ANIMASI PERNAPASAN (The Breathing Bubble) ---
            GestureDetector(
              onTap: _toggleBreathing,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        // Menggunakan warna aksen yang menenangkan
                        color: ColorConst.primaryAccentGreen.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ColorConst.primaryAccentGreen.withOpacity(
                              0.4,
                            ),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _currentInstruction,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Teks putih agar kontras dengan Sage Green
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- END ANIMATION ---
            const SizedBox(height: 50),

            // Instruksi Singkat (4-7-8)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  _buildInstructionRow("Tarik", "4 Detik (melalui hidung)"),
                  _buildInstructionRow("Tahan", "7 Detik"),
                  _buildInstructionRow("Hembuskan", "8 Detik (melalui mulut)"),

                  const SizedBox(height: 30),

                  Text(
                    'Ulangi siklus ini selama 3-5 menit untuk menenangkan sistem saraf.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConst.secondaryTextGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar - Menjaga konsistensi navigasi
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2, // Index untuk 'Tenang'/'Meditation'
        onItemTapped: (index) {
          // Implementasi navigasi ke halaman lain
          switch (index) {
            case 0:
              Get.toNamed(RouteConstants.home);
              break;
            case 1:
              Get.toNamed(RouteConstants.journal);
              break;
            case 2:
              // Tetap di sini
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

  // Helper untuk baris instruksi
  Widget _buildInstructionRow(String action, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            action,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorConst.primaryTextDark,
              fontSize: 16,
            ),
          ),
          Text(
            detail,
            style: TextStyle(color: ColorConst.secondaryTextGrey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
