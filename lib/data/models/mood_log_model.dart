import 'package:pocketbase/pocketbase.dart';

class MoodLogModel {
  final String id;
  final String userId;
  final int score;
  final String text;
  final DateTime timestamp; // Stored as UTC internally

  MoodLogModel({
    required this.id,
    required this.userId,
    required this.score,
    required this.text,
    required this.timestamp,
  });

  factory MoodLogModel.fromRecord(RecordModel record) {
    // Parse the timestamp as UTC
    final DateTime utcTime = DateTime.parse(
      record.getStringValue('timestamp'),
    ).toUtc();

    return MoodLogModel(
      id: record.id,
      userId: record.getStringValue('user'),
      score: record.getIntValue('score'),
      text: record.getStringValue('text'),
      timestamp: utcTime, // Keep as UTC internally
    );
  }

  // Getter to get the local date without time component
  DateTime get localDate {
    // Convert to local time and then create a new DateTime with just the date part
    final localTime = timestamp.toLocal();
    return DateTime(localTime.year, localTime.month, localTime.day);
  }

  // Getter to get the formatted date string for display
  String get formattedDate {
    final localTime = timestamp.toLocal();
    return '${localTime.day}-${localTime.month}-${localTime.year}';
  }

  // Method to convert model to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'user': userId,
      'score': score,
      'text': text,
      // Store as UTC
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }
}
