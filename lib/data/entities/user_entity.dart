import 'package:senandika/data/models/user_model.dart';

// UserEntity digunakan di lapisan Presentation/Controller
// untuk memastikan keterpisahan yang bersih dari data model.
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  // Konversi dari UserModel ke UserEntity
  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      avatar: model.avatar,
    );
  }
}
