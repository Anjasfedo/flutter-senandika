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

  // Durasi Siklus Pernapasan 4-7-8
  static const int inhaleDuration = 4; // Tarik 4s (Scale Up)
  static const int holdDuration = 7; // Tahan 7s (Stay Still)
  static const int exhaleDuration = 8; // Hembuskan 8s (Scale Down)
  static const int totalCycleDuration =
      inhaleDuration + holdDuration + exhaleDuration; // Total 19s

  // Keterangan Teks yang akan berganti
  String _currentInstruction = "Sentuh untuk Mulai";
  int _currentTimeRemaining = totalCycleDuration;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: totalCycleDuration),
    );

    // Listener untuk mengubah teks instruksi dan menghitung sisa waktu
    _controller.addListener(_updateInstruction);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset dan Ulangi siklus
        _controller.forward(from: 0.0);
      }
    });
  }

  void _updateInstruction() {
    final double rawTime = _controller.value * totalCycleDuration;

    int remaining = 0;
    String instruction = "Mulai";

    setState(() {
      if (rawTime < inhaleDuration) {
        // Fase TARIK: 0s hingga 4s
        instruction = "TARIK NAPAS";
        remaining = inhaleDuration - rawTime.floor();
      } else if (rawTime < inhaleDuration + holdDuration) {
        // Fase TAHAN: 4s hingga 11s
        instruction = "TAHAN";
        final double timeInHold = rawTime - inhaleDuration;
        remaining = holdDuration - timeInHold.floor();
      } else {
        // Fase HEMBUSKAN: 11s hingga 19s
        instruction = "HEMBUSKAN";
        final double timeInExhale = rawTime - (inhaleDuration + holdDuration);
        remaining = exhaleDuration - timeInExhale.floor();

        // Handle ketika timeInExhale tepat 8 (end of cycle)
        if (rawTime >= totalCycleDuration - 0.1) remaining = 1;
      }

      _currentInstruction = instruction;
      // Memastikan remaining minimal 1 saat animasi berjalan
      _currentTimeRemaining = remaining > 0 ? remaining : 1;
    });
  }

  // Memperbaiki floor() function (sudah tidak perlu didefinisikan secara manual jika menggunakan .floor())
  // Dihapus: int floor(double value) => value.floor();

  // Definisikan animasi skala menggunakan TweenSequence
  Animation<double> _createScaleAnimation(AnimationController controller) {
    // Total Durasi: 19s

    // Tween untuk Scale Up (0.5 -> 1.0)
    final scaleUpTween = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeInOutSine));

    // Tween untuk Scale Down (1.0 -> 0.5)
    final scaleDownTween = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).chain(CurveTween(curve: Curves.easeInOutSine));

    // Tween untuk Hold (1.0 -> 1.0)
    final scaleHoldTween = Tween<double>(begin: 1.0, end: 1.0);

    return TweenSequence<double>([
      // Stage 1: Inhale (0.0 - 4/19) -> Scale Up
      TweenSequenceItem(tween: scaleUpTween, weight: inhaleDuration.toDouble()),
      // Stage 2: Hold (4/19 - 11/19) -> Stay Big
      TweenSequenceItem(tween: scaleHoldTween, weight: holdDuration.toDouble()),
      // Stage 3: Exhale (11/19 - 1.0) -> Scale Down
      TweenSequenceItem(
        tween: scaleDownTween,
        weight: exhaleDuration.toDouble(),
      ),
    ]).animate(controller);
  }

  // Animasi Warna
  Animation<Color?> _createColorAnimation(AnimationController controller) {
    // Stage 1: Inhale (0s to 4s)
    final ColorTween inhaleTween = ColorTween(
      begin: ColorConst.primaryAccentGreen.withOpacity(0.7),
      end: ColorConst.primaryAccentGreen,
    );

    // Stage 2: Hold (4s to 11s)
    final ColorTween holdTween = ColorTween(
      begin: ColorConst.primaryAccentGreen,
      end: ColorConst.secondaryAccentLavender,
    );

    // Stage 3: Exhale (11s to 19s)
    final ColorTween exhaleTween = ColorTween(
      begin: ColorConst.secondaryAccentLavender,
      end: ColorConst.primaryAccentGreen.withOpacity(0.7),
    );

    // Menggabungkan Transisi Warna menggunakan Weights (4+7+8 = 19)
    return TweenSequence<Color?>([
      // Stage 1: Inhale (Weight 4)
      TweenSequenceItem(tween: inhaleTween, weight: inhaleDuration.toDouble()),
      // Stage 2: Hold (Weight 7)
      TweenSequenceItem(tween: holdTween, weight: holdDuration.toDouble()),
      // Stage 3: Exhale (Weight 8)
      TweenSequenceItem(tween: exhaleTween, weight: exhaleDuration.toDouble()),
    ]).animate(controller);
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
        _currentTimeRemaining = totalCycleDuration;
      });
    } else {
      if (_controller.value == 0.0) {
        _controller.repeat(); // Mulai dan ulangi
      } else {
        _controller.repeat(); // Lanjutkan
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = _createScaleAnimation(_controller);
    final colorAnimation = _createColorAnimation(_controller);

    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ), // Beri batas horizontal
              child: Text(
                'Teknik Ketenangan 4-7-8',
                textAlign: TextAlign.center, // ⬅️ Pastikan rata tengah
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 2. Subtitle Instruksi
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ), // Beri batas horizontal
              child: Text(
                _controller.isAnimating
                    ? "Fokus pada gelembung dan hitungan mundur."
                    : 'Sentuh lingkaran untuk memulai sesi.',
                textAlign: TextAlign.center, // ⬅️ Pastikan rata tengah
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.secondaryTextGrey,
                  fontStyle: _controller.isAnimating
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // --- ANIMASI PERNAPASAN (The Breathing Bubble) ---
            GestureDetector(
              onTap: _toggleBreathing,
              child: AnimatedBuilder(
                animation: Listenable.merge([_controller, colorAnimation]),
                builder: (context, child) {
                  // Text displayed in the center
                  Widget centerContent;

                  if (!_controller.isAnimating && _controller.value == 0.0) {
                    centerContent = const Text(
                      "Mulai",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  } else if (!_controller.isAnimating) {
                    centerContent = Text(
                      _currentInstruction,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    centerContent = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentInstruction,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${_currentTimeRemaining}', // Menampilkan hitungan mundur
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }

                  return Transform.scale(
                    scale: scaleAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: colorAnimation.value,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                colorAnimation.value?.withOpacity(0.6) ??
                                ColorConst.primaryAccentGreen.withOpacity(0.6),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(child: centerContent),
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
                    'Ulangi siklus ini 4-8 kali, atau sampai merasa tenang.',
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
      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2,
        onItemTapped: (index) {
          if (index != 2) {
            _controller.stop();
          }
          switch (index) {
            case 0:
              Get.toNamed(RouteConstants.home);
              break;
            case 1:
              Get.toNamed(RouteConstants.journal);
              break;
            case 2:
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
          // 1. Action (Tidak dibungkus, lebarnya tetap)
          Text(
            action,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorConst.primaryTextDark,
              fontSize: 16,
            ),
          ),

          // Tambahkan jarak horizontal (opsional)
          const SizedBox(width: 16),

          // 2. Detail (Dibungkus dengan Flexible agar menyesuaikan lebar yang tersisa)
          Flexible(
            child: Text(
              detail,
              style: TextStyle(
                color: ColorConst.secondaryTextGrey,
                fontSize: 16,
              ),
              textAlign: TextAlign
                  .right, // Opsional: Rata kanan agar alignment lebih baik
            ),
          ),
        ],
      ),
    );
  }
}
