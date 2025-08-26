import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class UserModel {
  const UserModel({this.id, this.name, this.email, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );
  }

  final int? id;

  final String? name;

  final String? email;

  final String? role;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }
}
