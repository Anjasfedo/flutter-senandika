import 'package:pocketbase/pocketbase.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  // final bool verified;
  final String created;
  final String? updated;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    // required this.verified,
    this.avatar,
    required this.created,
    this.updated,
  });

  /// 1. Factory untuk membuat model dari PocketBase RecordModel (misalnya, setelah fetch/get user)
  /// Ini digunakan saat mengambil data dari koleksi 'USERS' secara langsung.
  factory UserModel.fromRecord(RecordModel record) {
    return UserModel(
      id: record.id,
      name: record.getStringValue('name'),
      email: record.getStringValue('email'),
      avatar: record.getStringValue('avatar', null),
      created: record.get<String>('created'),
      updated: record.get<String>('updated', null),
    );
  }

  factory UserModel.fromAuthStore(RecordModel record) {
    return UserModel(
      id: record.id,
      name: record.getStringValue('name'),
      email: record.getStringValue('email'),
      avatar: record.getStringValue('avatar', null),
      created: record.get<String>('created'),
      updated: record.get<String>('updated', null),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'avatar': avatar};
  }
}
