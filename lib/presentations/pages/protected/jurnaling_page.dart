import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';

class JournalingPage extends StatefulWidget {
  const JournalingPage({Key? key}) : super(key: key);

  @override
  _JournalingPageState createState() => _JournalingPageState();
}

class _JournalingPageState extends State<JournalingPage> {
  // State to track which tab is selected
  bool _isMorningSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Background for the bottom navigation area
      body: Stack(
        children: [
          // 1. Purple Background Header
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6A5ACD), // Medium purple
                  Color(0xFF1565C0), // Indigo
                ],
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, top: 20.0, bottom: 20.0),
                  child: Text(
                    'Journaling',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // White Curved Container
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
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        // "Yuk mulai journaling" Text
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Yuk mulai journaling hari ini!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Main Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(RouteConstants.jurnaling_create);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1565C0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Mulai Journaling',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Custom Tab Bar (Morning / Evening)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              _buildTabItem(
                                title: 'Morning Journaling',
                                isSelected: _isMorningSelected,
                                onTap: () {
                                  setState(() {
                                    _isMorningSelected = true;
                                  });
                                },
                              ),
                              const SizedBox(width: 20),
                              _buildTabItem(
                                title: 'Evening Journaling',
                                isSelected: !_isMorningSelected,
                                onTap: () {
                                  setState(() {
                                    _isMorningSelected = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // Divider Line for tabs (optional, to make it look cleaner)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),

                        const SizedBox(height: 20),

                        // List of Placeholder Items
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            itemCount: 5, // Number of placeholders
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              return Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300], // Placeholder color
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  // Custom Widget for the Tab Text & Underline
  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFF0000FF)
                  : Colors.black, // Blue if selected
            ),
          ),
          const SizedBox(height: 8),
          // The Blue Underline Indicator
          Container(
            height: 3,
            width: isSelected
                ? 140
                : 0, // Animate or fix width based on selection
            color: isSelected ? const Color(0xFF0000FF) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
