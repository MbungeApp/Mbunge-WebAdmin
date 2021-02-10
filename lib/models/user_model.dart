// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.token,
        this.admin,
    });

    String token;
    Admin admin;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["Token"],
        admin: Admin.fromJson(json["Admin"]),
    );

    Map<String, dynamic> toJson() => {
        "Token": token,
        "Admin": admin.toJson(),
    };
}

class Admin {
    Admin({
        this.id,
        this.name,
        this.nationalId,
        this.emailAddress,
        this.password,
        this.role,
        this.createdAt,
        this.updatedAt,
    });

    String id;
    String name;
    String nationalId;
    String emailAddress;
    String password;
    int role;
    DateTime createdAt;
    DateTime updatedAt;

    factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json["id"],
        name: json["name"],
        nationalId: json["national_id"],
        emailAddress: json["email_address"],
        password: json["password"],
        role: json["role"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "national_id": nationalId,
        "email_address": emailAddress,
        "password": password,
        "role": role,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
