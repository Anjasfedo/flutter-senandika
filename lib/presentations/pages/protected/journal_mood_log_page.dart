import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';

class JournalMoodLogPage extends StatefulWidget {
  const JournalMoodLogPage({Key? key}) : super(key: key);

  @override
  _JournalMoodLogPageState createState() => _JournalMoodLogPageState();
}

class _JournalMoodLogPageState extends State<JournalMoodLogPage> {
  final TextEditingController _journalController = TextEditingController();
  final TextEditingController _tagInputController =
      TextEditingController(); // Controller baru untuk tag kustom
  final List<String> availableTags = [
    'Work Stress',
    'Sleep Issues',
    'Socializing',
    'Exercise',
    'Tiredness',
    'Family Time',
    'Food Craving',
  ];

  int _selectedMoodScore = 3; // Default ke Netral (3)
  List<String> _selectedTags = [];

  // Definisi Mood (Sama dengan yang digunakan di JournalPage)
  final List<Map<String, dynamic>> moods = [
    {'score': 1, 'emoji': '😭', 'label': 'Sangat Buruk'},
    {'score': 2, 'emoji': '😟', 'label': 'Buruk'},
    {'score': 3, 'emoji': '😐', 'label': 'Netral'},
    {'score': 4, 'emoji': '😊', 'label': 'Baik'},
    {'score': 5, 'emoji': '🤩', 'label': 'Sangat Baik'},
  ];

  @override
  void dispose() {
    _journalController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
      // Hapus dari availableTags juga jika itu tag kustom
      if (availableTags.contains(tag) &&
          ![
            'Work Stress',
            'Sleep Issues',
            'Socializing',
            'Exercise',
            'Tiredness',
            'Family Time',
            'Food Craving',
          ].contains(tag)) {
        availableTags.remove(tag);
      }
    });
  }

  void _addCustomTag() {
    final newTag = _tagInputController.text.trim();
    if (newTag.isNotEmpty && !availableTags.contains(newTag)) {
      setState(() {
        availableTags.add(newTag);
        _selectedTags.add(newTag);
      });
      _tagInputController.clear();
    }
  }

  void _saveLog() {
    if (_selectedMoodScore == 0) {
      Get.snackbar(
        'Perhatian',
        'Mohon pilih suasana hati Anda terlebih dahulu.',
        backgroundColor: ColorConst.crisisOrange.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Logika penyimpanan data (Mood: _selectedMoodScore, Journal: _journalController.text, Tags: _selectedTags)
    print(
      'Mood Log Saved: Score=$_selectedMoodScore, Journal=${_journalController.text}, Tags=$_selectedTags',
    );

    Get.back(); // Kembali setelah menyimpan
    Get.snackbar(
      'Tercatat!',
      'Suasana hati dan jurnal Anda berhasil dicatat.',
      backgroundColor: ColorConst.primaryAccentGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  // Helper untuk mendapatkan warna mood
  Color _getMoodColor(int score) {
    switch (score) {
      case 5:
        return ColorConst.moodPositive;
      case 4:
        return ColorConst.primaryAccentGreen.withOpacity(0.8);
      case 3:
        return ColorConst.moodNeutral;
      case 2:
        return ColorConst.secondaryTextGrey.withOpacity(0.5);
      case 1:
        return ColorConst.moodNegative;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Catat Jurnal Harian',
          style: TextStyle(
            color: ColorConst.primaryTextDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorConst.secondaryAccentLavender,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConst.primaryTextDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. MOOD QUICK LOG (MANDATORY) ---
              Text(
                '1. Bagaimana perasaanmu sekarang?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
              ),
              const SizedBox(height: 16),

              // Mood Selector (Emoji)
              _buildMoodSelector(),

              const SizedBox(height: 30),

              // --- 2. JOURNAL ENTRY (OPTIONAL) ---
              Text(
                '2. Ceritakan lebih banyak (Opsional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
              ),
              const SizedBox(height: 10),

              // Pertanyaan tambahan untuk memicu refleksi
              Text(
                'Apa satu hal yang paling memengaruhi moodmu hari ini, baik positif maupun negatif?',
                style: TextStyle(
                  fontSize: 15,
                  color: ColorConst.secondaryTextGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _journalController,
                maxLines: 5,
                maxLength: 500,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: InputDecoration(
                  hintText:
                      'Tuliskan pikiran, peristiwa, atau pemicu yang kamu rasakan...',
                  hintStyle: TextStyle(
                    color: ColorConst.secondaryTextGrey.withOpacity(0.7),
                  ),
                  filled: true,
                  fillColor: ColorConst.secondaryBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: ColorConst.primaryAccentGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // --- 3. QUICK TAGS / TRIGGERS (OPTIONAL) ---
              Text(
                '3. Tandai pemicu utama (Opsional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConst.primaryTextDark,
                ),
              ),
              const SizedBox(height: 10),

              _buildTagSelector(),

              const SizedBox(height: 15),

              // Input Tag Kustom
              TextField(
                controller: _tagInputController,
                style: TextStyle(color: ColorConst.primaryTextDark),
                decoration: InputDecoration(
                  hintText:
                      'Tambahkan tag kustom baru (mis: "Kopi Berlebihan")',
                  hintStyle: TextStyle(
                    color: ColorConst.secondaryTextGrey.withOpacity(0.7),
                  ),
                  filled: true,
                  fillColor: ColorConst.secondaryBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: ColorConst.primaryAccentGreen,
                    ),
                    onPressed: _addCustomTag,
                  ),
                ),
                onSubmitted: (value) => _addCustomTag(),
              ),

              const SizedBox(height: 50),

              // --- Tombol Simpan ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.ctaPeach, // CTA Peach color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Simpan Log Jurnal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk pemilih Mood
  Widget _buildMoodSelector() {
    return Row(
      // Menggunakan spaceBetween dan wrapping setiap item dengan Expanded
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: moods.map((mood) {
        final score = mood['score'];
        final emoji = mood['emoji'];
        final isSelected = _selectedMoodScore == score;

        // Scale faktor untuk membuat emoji membesar saat dipilih
        final scaleFactor = isSelected ? 1.2 : 1.0;

        return Expanded(
          // Memastikan setiap item mengambil lebar yang sama
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedMoodScore = score;
              });
            },
            child: AnimatedScale(
              // Menggunakan AnimatedScale untuk transisi yang mulus
              scale: scaleFactor,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              // FIX: Membungkus Column dengan SizedBox yang memiliki tinggi tetap untuk perataan vertikal
              child: SizedBox(
                height:
                    85, // Tinggi yang cukup untuk Container (55) + Spasi (5) + Teks 2 baris (25)
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Pastikan dimulai dari atas
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        // Opacity penuh saat dipilih
                        color: _getMoodColor(
                          score,
                        ).withOpacity(isSelected ? 1.0 : 0.4),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: ColorConst.primaryTextDark,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // FIX: Teks memiliki maxLines: 2 untuk menjaga tinggi yang konsisten
                    Text(
                      mood['label'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? ColorConst.primaryTextDark
                            : ColorConst.secondaryTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Widget untuk pemilih Tags (Sudah Diperbarui)
  Widget _buildTagSelector() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: availableTags.map((tag) {
        final isSelected = _selectedTags.contains(tag);

        // Cek apakah ini tag default (tidak bisa dihapus)
        final isDefaultTag = [
          'Work Stress',
          'Sleep Issues',
          'Socializing',
          'Exercise',
          'Tiredness',
          'Family Time',
          'Food Craving',
        ].contains(tag);

        return GestureDetector(
          onTap: () => _toggleTag(tag),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorConst.primaryAccentGreen
                  : ColorConst.secondaryBackground,
              borderRadius: BorderRadius.circular(20),
              border: isSelected
                  ? Border.all(color: ColorConst.primaryAccentGreen, width: 1.5)
                  : null,
            ),
            child: Row(
              // Menggunakan Row untuk menampung teks dan tombol hapus
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tag,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? Colors.white
                        : ColorConst.primaryTextDark,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                // Tombol Hapus hanya muncul jika tag dipilih ATAU jika itu tag kustom yang baru ditambahkan
                if (isSelected &&
                    !isDefaultTag) // Hanya tampilkan tombol hapus jika tag dipilih dan bukan tag default
                  GestureDetector(
                    onTap: (tag != null) ? () => _removeTag(tag) : null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: isSelected
                            ? Colors.white
                            : ColorConst.primaryTextDark,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
