import 'package:flutter/material.dart';

// 1. Define a model to hold the Question and its Controller together
class JournalQuestion {
  final String text;
  final TextEditingController controller;

  JournalQuestion(this.text) : controller = TextEditingController();
}

class JournalingCreatePage extends StatefulWidget {
  const JournalingCreatePage({Key? key}) : super(key: key);

  @override
  _JournalingCreatePageState createState() => _JournalingCreatePageState();
}

class _JournalingCreatePageState extends State<JournalingCreatePage> {
  // 2. Define the questions as a Variable (List)
  // You can easily add more questions here!
  late List<JournalQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = [
      JournalQuestion('Mau melakukan apa saja hari ini?'),
      JournalQuestion('Ada yang mengganjal dalam pikiran?'),
      JournalQuestion('Apakah ada ide-ide yang muncul di pagi ini?'),
      JournalQuestion('Apa afirmasi untuk dirimu di pagi hari ini?'),
    ];
  }

  @override
  void dispose() {
    // 3. Clean up controllers dynamically
    for (var q in _questions) {
      q.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Purple Header
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF6A5ACD), Color(0xFF4B0082)],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header Title
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Morning Journaling',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // White Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(24.0),
                      children: [
                        const Text(
                          'Tanggal journaling',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Senin, 14 Oktober 2024',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 4. Generate the Input Fields Dynamically using .map()
                        ..._questions.map((item) {
                          return _buildJournalField(
                            label: item.text,
                            controller: item.controller,
                          );
                        }).toList(),

                        const SizedBox(height: 10),

                        // Submit Button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _handleSubmit();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F4198),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3F4198),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Journaling',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Helper to build the field
  Widget _buildJournalField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextFormField(
              controller: controller,
              maxLines: 3,
              minLines: 2,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to handle submit
  void _handleSubmit() {
    // Example: Print all answers
    for (var q in _questions) {
      print("Question: ${q.text}");
      print("Answer: ${q.controller.text}");
      print("---");
    }
  }
}
