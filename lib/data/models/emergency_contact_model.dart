import 'package:pocketbase/pocketbase.dart';

class EmergencyContactModel {
  final String? id; // ID record kontak darurat (bisa null jika belum ada)
  final String name;
  final String phone;
  final String userId;

  EmergencyContactModel({
    this.id,
    required this.name,
    required this.phone,
    required this.userId,
  });

  factory EmergencyContactModel.fromRecord(RecordModel record) {
    return EmergencyContactModel(
      id: record.id,
      name: record.getStringValue('name'),
      phone: record.getStringValue('phone'),
      userId: record.getStringValue('user'),
    );
  }

  EmergencyContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? userId,
  }) {
    return EmergencyContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
    );
  }
}
