import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? name;
  final String? email;
  final String? id;

  UserModel({this.name, this.email, this.id});
  // UserModel fromJson(){}
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'id': id,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        id: json['id'],
        name: json['name'],
      );

  @override
  List<Object?> get props => [
        name,
        email,
        id,
      ];
}
