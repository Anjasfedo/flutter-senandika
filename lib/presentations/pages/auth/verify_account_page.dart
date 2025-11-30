import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/controllers/verify_account_controller.dart';

class VerifyAccountPage extends GetView<VerifyAccountController> {
  const VerifyAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Icon Notifikasi
              Obx(
                () => Icon(
                  Icons.email_outlined,
                  size: 100,
                  color: controller.isLoading.isTrue
                      ? Colors.grey
                      : ColorConst.ctaPeach,
                ),
              ),
              const SizedBox(height: 30),

              // Title
              Text(
                'Verifikasi Akunmu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              // Subtitle
              Text(
                'Tautan verifikasi telah dikirim ke:',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.secondaryTextGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Email - menggunakan Obx
              Obx(
                () => Text(
                  controller.userEmail.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConst.primaryAccentGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),

              // --- Loading Indicator for Initial Send ---
              Obx(() {
                if (controller.isLoading.isTrue &&
                    controller.infoMessage.isEmpty) {
                  return Column(
                    children: [
                      CircularProgressIndicator(
                        color: ColorConst.primaryAccentGreen,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Mengirim email verifikasi...',
                        style: TextStyle(
                          color: ColorConst.secondaryTextGrey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // --- Info/Error Message ---
              Obx(() {
                if (controller.infoMessage.isNotEmpty) {
                  return _buildMessageCard(
                    message: controller.infoMessage.value,
                    color: ColorConst.successGreen,
                    onTap: controller.clearMessages,
                  );
                } else if (controller.errorMessage.isNotEmpty) {
                  return _buildMessageCard(
                    message: controller.errorMessage.value,
                    color: ColorConst.moodNegative,
                    onTap: controller.clearMessages,
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 20),

              // --- Tombol Kirim Ulang Verifikasi ---
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        controller.resendDisabled.isFalse &&
                            controller.isLoading.isFalse
                        ? controller.resendVerification
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.primaryAccentGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: ColorConst.primaryAccentGreen
                          .withOpacity(0.5),
                    ),
                    child: controller.isLoading.isTrue
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            controller.resendDisabled.isTrue
                                ? 'Kirim Ulang dalam ${controller.countdown.value} detik'
                                : 'Kirim Ulang Verifikasi',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // --- Tombol Cek Status Verifikasi ---
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: controller.isLoading.isFalse
                        ? controller.checkVerificationStatus
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorConst.primaryAccentGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: controller.isLoading.isTrue
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorConst.primaryAccentGreen,
                            ),
                          )
                        : Text(
                            'Saya Sudah Verifikasi',
                            style: TextStyle(
                              color: ColorConst.primaryAccentGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- Tombol Logout ---
              TextButton(
                onPressed: controller.isLoading.isFalse
                    ? controller.handleLogout
                    : null,
                child: Text(
                  'Keluar dari Akun',
                  style: TextStyle(
                    color: ColorConst.secondaryTextGrey.withOpacity(
                      controller.isLoading.isFalse ? 1.0 : 0.5,
                    ),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageCard({
    required String message,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.close, color: color, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
