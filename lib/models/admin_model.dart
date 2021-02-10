// To parse this JSON data, do
//
//     final adminModel = adminModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<AdminModel> adminModelFromJson(String str) {
  debugPrint("inside model: $str");
  return List<AdminModel>.from(
    json.decode(str).map((x) => AdminModel.fromJson(x)),
  );
}

String adminModelToJson(List<AdminModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminModel {
  AdminModel({
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

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
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
