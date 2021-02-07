// To parse this JSON data, do
//
//     final addAdminModel = addAdminModelFromJson(jsonString);

import 'dart:convert';

AddAdminModel addAdminModelFromJson(String str) =>
    AddAdminModel.fromJson(json.decode(str));

String addAdminModelToJson(AddAdminModel data) => json.encode(data.toJson());

class AddAdminModel {
  AddAdminModel({
    this.name,
    this.nationalId,
    this.emailAddress,
    this.role,
  });

  String name;
  String nationalId;
  String emailAddress;
  int role;

  factory AddAdminModel.fromJson(Map<String, dynamic> json) => AddAdminModel(
        name: json["name"],
        nationalId: json["national_id"],
        emailAddress: json["email_address"],
        role: json["role"]
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "national_id": nationalId,
        "email_address": emailAddress,
        "role": role
        // "role": role
      };
}
