import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Asumsikan import ini ada dan mengarah ke file konstanta
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/constants/route_constant.dart';
// ------------------------------------------------------------------------

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(RouteConstants.onboarding);
    });

    // Mengganti Gradient dengan solid color atau gradient yang lebih soft/calm
    return Scaffold(
      // Menggunakan warna background utama yang light/tenang
      backgroundColor: ColorConst.primaryBackgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Ikon Aplikasi (Mengganti Icon menjadi lebih kalem dan relevan)
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                // Menggunakan warna Aksen untuk lingkaran
                color: ColorConst.primaryAccentGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                // Menggunakan ikon yang lebih merepresentasikan pikiran atau dialog
                Icons.mode_comment_outlined,
                color: ColorConst
                    .primaryBackgroundLight, // Kontras dengan warna hijau
                size: 50,
              ),
            ),
            const SizedBox(height: 30),

            // 2. Nama Aplikasi
            Text(
              'Senandika',
              style: TextStyle(
                fontSize: 48, // Ukuran sedikit dikecilkan agar lebih modern
                fontWeight: FontWeight.bold,
                color:
                    ColorConst.primaryTextDark, // Menggunakan warna teks hangat
                // Jika Anda memiliki custom font, gunakan di sini
              ),
            ),
            const SizedBox(height: 10),

            // 3. Subtitle yang Relevan
            Text(
              'Ruang Aman untuk Dialog Batinmu', // Subtitle yang lebih relevan dengan 'Senandika'
              style: TextStyle(
                fontSize: 18,
                color: ColorConst
                    .secondaryTextGrey, // Menggunakan warna abu-abu lembut
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 60),

            // Indikator Loading (Opsional, jika diperlukan)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                ColorConst.secondaryAccentLavender,
              ),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
