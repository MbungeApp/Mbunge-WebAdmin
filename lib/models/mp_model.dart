// To parse this JSON data, do
//
//     final mpModel = mpModelFromJson(jsonString);

import 'dart:convert';

List<MpModel> mpModelFromJson(String str) =>
    List<MpModel>.from(json.decode(str).map((x) => MpModel.fromJson(x)));

String mpModelToJson(List<MpModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MpModel {
  MpModel({
    this.bio,
    this.constituency,
    this.county,
    this.createdAt,
    this.dateBirth,
    this.id,
    this.image,
    this.images,
    this.martialStatus,
    this.name,
    this.updatedAt,
  });

  String bio;
  String constituency;
  String county;
  DateTime createdAt;
  DateTime dateBirth;
  String id;
  String image;
  dynamic images;
  String martialStatus;
  String name;
  DateTime updatedAt;

  factory MpModel.fromJson(Map<String, dynamic> json) => MpModel(
        bio: json["bio"],
        constituency: json["constituency"],
        county: json["county"],
        createdAt: DateTime.parse(json["created_at"]),
        dateBirth: DateTime.parse(json["date_birth"]),
        id: json["id"],
        image: json["image"],
        images: json["images"],
        martialStatus: json["martial_status"],
        name: json["name"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "constituency": constituency,
        "county": county,
        "created_at": createdAt.toIso8601String(),
        "date_birth": dateBirth.toIso8601String(),
        "id": id,
        "image": image,
        "images": images,
        "martial_status": martialStatus,
        "name": name,
        "updated_at": updatedAt.toIso8601String(),
      };
}
