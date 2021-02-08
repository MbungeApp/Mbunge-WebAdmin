// To parse this JSON data, do
//
//     final addMpModel = addMpModelFromJson(jsonString);

import 'dart:convert';

import 'dart:typed_data';

AddMpModel addMpModelFromJson(String str) =>
    AddMpModel.fromJson(json.decode(str));

String addMpModelToJson(AddMpModel data) => json.encode(data.toJson());

class AddMpModel {
  AddMpModel({
    this.name,
    this.picture,
    this.constituency,
    this.county,
    this.martialStatus,
    this.dateOfBirth,
    this.bio,
  });

  String name;
  Uint8List picture;
  String constituency;
  String county;
  String martialStatus;
  DateTime dateOfBirth;
  String bio;

  factory AddMpModel.fromJson(Map<String, dynamic> json) => AddMpModel(
        name: json["name"],
        constituency: json["constituency"],
        county: json["county"],
        martialStatus: json["martial_status"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        bio: json["bio"],
      );

  Map<String, String> toJson() => {
        "name": name,
        "constituency": constituency,
        "county": county,
        "martial_status": martialStatus,
        "date_of_birth": dateOfBirth.toIso8601String(),
        "bio": bio,
      };
}
