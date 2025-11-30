import 'package:flutter/material.dart';

// --- Session Data Model ---
class ChatSession {
  final String title;
  final String lastMessage;
  final String date;
  final Color moodColor;

  ChatSession({
    required this.title,
    required this.lastMessage,
    required this.date,
    required this.moodColor,
  });
}
