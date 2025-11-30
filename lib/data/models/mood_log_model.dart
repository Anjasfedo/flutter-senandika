import 'package:pocketbase/pocketbase.dart';

class MoodLogModel {
  final String id;
  final String userId;
  final int score;
  final String text;
  final DateTime timestamp;

  MoodLogModel({
    required this.id,
    required this.userId,
    required this.score,
    required this.text,
    required this.timestamp,
  });

  factory MoodLogModel.fromRecord(RecordModel record) {
    final DateTime utcTime = DateTime.parse(
      record.getStringValue('timestamp'),
    );

    return MoodLogModel(
      id: record.id,
      userId: record.getStringValue('user'),
      score: record.getIntValue('score'),
      text: record.getStringValue('text'),
      timestamp: utcTime,
    );
  }
}
