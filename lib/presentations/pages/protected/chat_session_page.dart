import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/color_constant.dart';
import 'package:senandika/presentations/widgets/bottom_navigation_bar.dart';
import 'package:senandika/constants/route_constant.dart';

// --- Chat Message Model ---
class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}
// --------------------------

class ChatSessionPage extends StatefulWidget {
  const ChatSessionPage({Key? key}) : super(key: key);

  @override
  _ChatSessionPageState createState() => _ChatSessionPageState();
}

class _ChatSessionPageState extends State<ChatSessionPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock Data untuk percakapan kontekstual
  List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Halo Pengguna Senandika. Saya siap mendengarkan. Aku melihat mood terakhirmu 'Cukup Baik'. Apakah ada yang ingin kamu bagi hari ini?",
      isUser: false,
      time: "14:30",
    ),
    ChatMessage(
      text:
          "Aku merasa agak cemas karena deadline pekerjaan hari ini. Aku ingin sekali menunda semuanya.",
      isUser: true,
      time: "14:31",
    ),
    ChatMessage(
      text:
          "Aku mengerti perasaan itu valid. Perasaan cemas sering muncul menjelang tenggat waktu. Mari kita coba teknik sederhana: Apa satu langkah kecil (satu menit!) yang bisa kamu ambil sekarang? Ingat, tujuanmu 'Mulai Tumbuh'.",
      isUser: false,
      time: "14:32",
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper untuk mendapatkan format waktu HH:MM
  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    // 1. Tambahkan pesan pengguna dengan waktu saat ini
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      time: _getCurrentTime(),
    );

    setState(() {
      _messages.insert(0, userMessage); // Insert di awal untuk reversed list
    });

    // Simulasi respons bot (di aplikasi nyata, ini akan memanggil Gemini API)
    _simulateBotResponse(text);
  }

  void _simulateBotResponse(String userText) {
    // Simulasi analisis konteks sederhana
    String botResponse;
    if (userText.toLowerCase().contains('cemas') ||
        userText.toLowerCase().contains('stres')) {
      botResponse =
          "Terima kasih sudah berbagi. Karena kamu merasa cemas, apakah kamu mau mencoba latihan pernapasan 4-7-8 yang sudah kita pelajari? Itu bisa membantu menenangkan sistem sarafmu.";
    } else if (userText.toLowerCase().contains('bagus') ||
        userText.toLowerCase().contains('baik')) {
      botResponse =
          "Itu kabar baik! Apakah kamu sudah mencatatnya di Jurnal? Mungkin kita bisa identifikasi hal positif apa yang memicu mood baik ini.";
    } else {
      botResponse =
          "Aku mendengarkanmu. Mari kita telusuri lebih jauh perasaan itu. Apa hal yang paling memberatkan di pikiranmu saat ini?";
    }

    // Waktu bot adalah 1 detik setelah user mengirim
    final botTime = _getCurrentTime();

    final botMessage = ChatMessage(
      text: botResponse,
      isUser: false,
      time: botTime,
    );

    Future.delayed(const Duration(seconds: 1), () {
      // Mengurangi delay menjadi 1 detik
      setState(() {
        _messages.insert(0, botMessage);
      });
      // Scroll ke bawah (atas list yang di reverse)
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // --- Widget Build Utama ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          'Senandika - Pendamping Batin',
          style: TextStyle(color: ColorConst.primaryTextDark),
        ),
        backgroundColor: ColorConst.secondaryAccentLavender,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConst.primaryTextDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Daftar Pesan
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              reverse: true, // Untuk membuat pesan terbaru ada di bawah
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          const Divider(height: 1.0),

          // Input Area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: ColorConst.secondaryTextGrey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: _handleSubmitted,
                        style: TextStyle(color: ColorConst.primaryTextDark),
                        decoration: InputDecoration.collapsed(
                          hintText: "Tuliskan perasaanmu di sini...",
                          hintStyle: TextStyle(
                            color: ColorConst.secondaryTextGrey.withOpacity(
                              0.7,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: ColorConst
                            .primaryAccentGreen, // Tombol kirim warna Sage Green
                      ),
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  // Helper untuk membuat Message Bubble yang unik
  Widget _buildMessageBubble(ChatMessage message) {
    // Aligment pesan
    final alignment = message.isUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // Warna bubble (User = CTA Peach, Bot = Lavender)
    final bubbleColor = message.isUser
        ? ColorConst.ctaPeach
        : ColorConst.secondaryAccentLavender;

    // Warna teks
    final textColor = message.isUser
        ? Colors.white
        : ColorConst.primaryTextDark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Align(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(message.isUser ? 16 : 4),
                  topRight: const Radius.circular(16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
            ),

            // Time stamp
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0),
              child: Text(
                message.time,
                style: TextStyle(
                  color: ColorConst.secondaryTextGrey.withOpacity(0.6),
                  fontSize: 10.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
