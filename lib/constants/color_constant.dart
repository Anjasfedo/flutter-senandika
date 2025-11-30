// Constants File: constants/color_constant.dart

import 'package:flutter/material.dart';

class ColorConst {
  // 1. PRIMARY & BACKGROUND COLORS (The Calming Foundation)

  // Background Utama: Sangat terang, hampir putih, tetapi lebih hangat dari putih murni.
  // Mereduksi ketegangan mata (eye strain).
  static const Color primaryBackgroundLight = Color(0xFFF7F9FC);

  // Secondary Background: Digunakan untuk cards, containers, atau modals.
  static const Color secondaryBackground = Color(0xFFEFEFF7);

  // Primary Accent: Warna lembut yang diasosiasikan dengan alam dan ketenangan.
  static const Color primaryAccentGreen = Color(0xFFA7C9A0); // Muted Sage Green

  // Secondary Accent: Warna ungu muda yang menenangkan, cocok untuk fitur Meditasi/Breathing.
  static const Color secondaryAccentLavender = Color(0xFFE6E6FA);

  // 2. TEXT & ICON COLORS (Readability and Contrast)

  // Text Utama: Hangat dan lembut (Warm Gray) untuk kontras tanpa ketegasan hitam murni.
  static const Color primaryTextDark = Color(0xFF384656);

  // Text Sekunder: Untuk deskripsi atau teks yang tidak terlalu penting.
  static const Color secondaryTextGrey = Color(0xFF6B7A8F);

  // 3. FUNCTIONAL & CTA COLORS (Action & Emphasis)

  // Primary Call-to-Action (CTA): Warna hangat untuk tombol utama (mis. Log Mood).
  static const Color ctaPeach = Color(0xFFF4A261);

  // Crisis Safety: Warna berbeda yang menarik perhatian, tapi tidak agresif (Digunakan pada Quick Dial).
  static const Color crisisOrange = Color(0xFFFF9000);

  // Completion/Success: Untuk checkmark Goal Setting.
  static const Color successGreen = Color(0xFF4BB543);

  // 4. MOOD TRACKING COLORS (Data Visualization)

  // Mood: Great (5)
  static const Color moodPositive = Color(0xFFF7C670); // Soft Gold/Yellow

  // Mood: Bad (1)
  static const Color moodNegative = Color(0xFF4A6070); // Desaturated Navy

  // Mood: Neutral (3)
  static const Color moodNeutral = Color(0xFFD8D5C5); // Light Taupe
}
