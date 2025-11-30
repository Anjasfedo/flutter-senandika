import 'package:senandika/data/models/user_model.dart';

// UserEntity digunakan di lapisan Presentation/Controller
class UserEntity {
  final String id;
  final String name;
  final String email;
  final bool verified; // ⬅️ Tambahan
  final String? avatar;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.verified, // ⬅️ Tambahan
    this.avatar,
  });

  // Konversi dari UserModel ke UserEntity
  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      verified: model.verified, // ⬅️ Transfer data verified
      avatar: model.avatar,
    );
  }
}
