import 'package:pocketbase/pocketbase.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final bool verified; // ⬅️ Tambahan
  final String? avatar;
  final String created;
  final String? updated;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.verified, // ⬅️ Tambahan
    this.avatar,
    required this.created,
    this.updated,
  });

  /// 1. Factory untuk membuat model dari PocketBase RecordModel (misalnya, setelah fetch/get user)
  factory UserModel.fromRecord(RecordModel record) {
    return UserModel(
      id: record.id,
      name: record.getStringValue('name'),
      email: record.getStringValue('email'),
      verified: record.getBoolValue(
        'verified',
        false,
      ), // ⬅️ Ambil status verified
      avatar: record.getStringValue('avatar', null),
      created: record.get<String>('created'),
      updated: record.get<String>('updated', null),
    );
  }

  /// Factory untuk membuat model dari PocketBase Auth Store (digunakan setelah login/sign up)
  factory UserModel.fromAuthStore(RecordModel record) {
    return UserModel(
      id: record.id,
      name: record.getStringValue('name'),
      email: record.getStringValue('email'),
      verified: record.getBoolValue(
        'verified',
        false,
      ), // ⬅️ Ambil status verified
      avatar: record.getStringValue('avatar', null),
      created: record.get<String>('created'),
      updated: record.get<String>('updated', null),
    );
  }

  Map<String, dynamic> toJson() {
    // Tambahkan verified jika diperlukan di JSON
    return {
      'name': name,
      'email': email,
      'avatar': avatar,
      'verified': verified,
    };
  }
}
