import 'package:flutter/material.dart';
import 'package:senandika/constants/color_constant.dart';

/// Reusable constants and helper functions for journal mood functionality
class JournalMoodConstant {
  // Private constructor to prevent instantiation
  JournalMoodConstant._();

  // Mood data structure with all mood options
  static const List<Map<String, dynamic>> moods = [
    {
      'score': 1,
      'emoji': '😭',
      'label': 'Sangat Buruk',
      'color': ColorConst.moodNegative,
    },
    {
      'score': 2,
      'emoji': '😟',
      'label': 'Buruk',
      'color': ColorConst.secondaryTextGrey,
    },
    {
      'score': 3,
      'emoji': '😐',
      'label': 'Netral',
      'color': ColorConst.moodNeutral,
    },
    {
      'score': 4,
      'emoji': '😊',
      'label': 'Baik',
      'color': ColorConst.primaryAccentGreen,
    },
    {
      'score': 5,
      'emoji': '🤩',
      'label': 'Sangat Baik',
      'color': ColorConst.moodPositive,
    },
  ];

  // Available preset tags for mood logging
  static const List<String> availableTags = [
    'Pekerjaan',
    'Keluarga',
    'Teman',
    'Hubungan',
    'Kesehatan',
    'Keuangan',
    'Hobi',
    'Tidur',
    'Makan',
    'Olahraga',
    'Stres',
    'Bahagia',
    'Sedih',
    'Marah',
    'Cemas',
    'Bersyukur',
  ];

  // Helper functions for mood data

  /// Get mood emoji based on score
  static String getMoodEmoji(int score) {
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
        return '⚪';
    }
  }

  /// Get mood color based on score
  static Color getMoodColor(int score) {
    switch (score) {
      case 5:
        return ColorConst.moodPositive;
      case 4:
        return ColorConst.primaryAccentGreen;
      case 3:
        return ColorConst.moodNeutral;
      case 2:
        return ColorConst.secondaryTextGrey.withValues(alpha: 0.5);
      case 1:
        return ColorConst.moodNegative;
      default:
        return Colors.transparent;
    }
  }

  /// Get mood color based on score (for UI where opacity is needed)
  static Color getMoodColorWithOpacity(int score, double opacity) {
    final baseColor = getMoodColor(score);
    if (opacity >= 1.0) return baseColor;
    return baseColor.withValues(alpha: opacity);
  }

  /// Get mood label based on score
  static String getMoodLabel(int score) {
    switch (score) {
      case 5:
        return 'Sangat Baik';
      case 4:
        return 'Baik';
      case 3:
        return 'Netral';
      case 2:
        return 'Buruk';
      case 1:
        return 'Sangat Buruk';
      default:
        return 'Tidak Diketahui';
    }
  }

  /// Get mood data entry based on score
  static Map<String, dynamic>? getMoodData(int score) {
    try {
      return moods.firstWhere((mood) => mood['score'] == score);
    } catch (e) {
      return null;
    }
  }

  /// Check if mood score is valid (1-5)
  static bool isValidMoodScore(int score) {
    return score >= 1 && score <= 5;
  }

  /// Get all mood scores
  static List<int> getAllMoodScores() {
    return moods.map((mood) => mood['score'] as int).toList();
  }

  /// Get default mood score (neutral)
  static int get defaultMoodScore => 3;

  /// Check if mood is positive (score >= 4)
  static bool isPositiveMood(int score) {
    return score >= 4;
  }

  /// Check if mood is negative (score <= 2)
  static bool isNegativeMood(int score) {
    return score <= 2;
  }

  /// Check if mood is neutral (score == 3)
  static bool isNeutralMood(int score) {
    return score == 3;
  }

  /// Search available tags by keyword
  static List<String> searchTags(String keyword) {
    if (keyword.isEmpty) return availableTags;

    final lowerKeyword = keyword.toLowerCase();
    return availableTags
        .where((tag) => tag.toLowerCase().contains(lowerKeyword))
        .toList();
  }

  /// Get suggested tags based on mood score
  static List<String> getSuggestedTagsForMood(int score) {
    switch (score) {
      case 1: // Sangat Buruk
        return ['Stres', 'Sedih', 'Marah', 'Cemas', 'Kesehatan'];
      case 2: // Buruk
        return ['Stres', 'Keuangan', 'Pekerjaan', 'Tidur', 'Kesehatan'];
      case 3: // Netral
        return ['Makan', 'Olahraga', 'Tidur', 'Hobi'];
      case 4: // Baik
        return ['Bahagia', 'Bersyukur', 'Keluarga', 'Teman', 'Hobi'];
      case 5: // Sangat Baik
        return ['Bahagia', 'Bersyukur', 'Keluarga', 'Teman', 'Hubungan'];
      default:
        return [];
    }
  }

  /// Validate tag against available tags
  static bool isValidTag(String tag) {
    return availableTags.contains(tag);
  }

  /// Get tag categories (for potential future enhancement)
  static Map<String, List<String>> getTagCategories() {
    return {
      'Pribadi': ['Kesehatan', 'Tidur', 'Makan', 'Olahraga'],
      'Sosial': ['Keluarga', 'Teman', 'Hubungan'],
      'Profesional': ['Pekerjaan', 'Keuangan'],
      'Emosional': ['Stres', 'Bahagia', 'Sedih', 'Marah', 'Cemas', 'Bersyukur'],
      'Rekreasi': ['Hobi'],
    };
  }

  /// Get color intensity for mood scores (0.0 to 1.0)
  static double getMoodIntensity(int score) {
    switch (score) {
      case 1:
        return 0.2;
      case 2:
        return 0.4;
      case 3:
        return 0.6;
      case 4:
        return 0.8;
      case 5:
        return 1.0;
      default:
        return 0.0;
    }
  }
}