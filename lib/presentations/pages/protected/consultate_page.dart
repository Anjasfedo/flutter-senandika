import 'package:flutter/material.dart';
import 'package:pulih/presentations/widgets/bottom_navigation_bar.dart';

// Simple model for a chat message
class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class ConsultatePage extends StatefulWidget {
  const ConsultatePage({Key? key}) : super(key: key);

  @override
  _ConsultatePageState createState() => _ConsultatePageState();
}

class _ConsultatePageState extends State<ConsultatePage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Dummy initial chat history
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Halo! Saya asisten virtual Pulih. Bagaimana perasaanmu hari ini? Ada yang ingin kamu ceritakan?",
      isUser: false,
      time: "08:00",
    ),
  ];

  void _handleSend() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      // 1. Add User Message
      _messages.add(
        ChatMessage(
          text: _textController.text,
          isUser: true,
          time: _getCurrentTime(),
        ),
      );

      String userText = _textController.text;
      _textController.clear();

      // 2. Simulate Bot Response (Delayed)
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add(
              ChatMessage(
                text: _getBotResponse(userText),
                isUser: false,
                time: _getCurrentTime(),
              ),
            );
          });
          _scrollToBottom();
        }
      });
    });
    _scrollToBottom();
  }

  // Simple logic to scroll to the latest message
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  // Updated dummy response generator with Date & Time
  String _getBotResponse(String input) {
    // Get current full date and time for the dummy response
    final now = DateTime.now();
    final dateStr = "${now.day}/${now.month}/${now.year}";
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    final timestamp = "$dateStr, $timeStr";

    input = input.toLowerCase();
    String responseText;

    if (input.contains("sedih") ||
        input.contains("cemas") ||
        input.contains("takut")) {
      responseText =
          "Saya mengerti perasaan itu berat. Ingatlah bahwa perasaaan ini valid. Apakah ada kejadian tertentu yang memicunya?";
    } else if (input.contains("terima kasih") || input.contains("makasih")) {
      responseText =
          "Sama-sama! Saya di sini kapanpun kamu butuh teman bercerita.";
    } else if (input.contains("halo") || input.contains("hi")) {
      responseText = "Halo! Ada yang bisa saya bantu hari ini?";
    } else {
      responseText =
          "Terima kasih sudah berbagi. Ceritakan lebih banyak, saya mendengarkan.";
    }

    // Append the dummy datetime to the response
    return "$responseText\n\n(Diterima pada: $timestamp)";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Purple Header Background
          Container(
            height: 150,
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

          // 2. Main Chat Area
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar Area
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0,
                  ),
                  child: Row(
                    children: [
                      // Bot Avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.smart_toy_outlined,
                          color: Color(0xFF6A5ACD),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konsultasi Pulih',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // White Container for Chat List
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
                        // Chat List
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(20),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final msg = _messages[index];
                              return _buildChatBubble(msg);
                            },
                          ),
                        ),

                        // Input Area
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, -1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextField(
                                    controller: _textController,
                                    decoration: const InputDecoration(
                                      hintText: 'Ketik pesan...',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: const Color(0xFF3F4198),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: _handleSend,
                                ),
                              ),
                            ],
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

  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: msg.isUser ? const Color(0xFF3F4198) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isUser
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: msg.isUser
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isUser ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              msg.time,
              style: TextStyle(
                color: msg.isUser ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
