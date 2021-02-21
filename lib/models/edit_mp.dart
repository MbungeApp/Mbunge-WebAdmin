// To parse this JSON data, do
//
//     final editMpModel = editMpModelFromJson(jsonString);

import 'dart:convert';

EditMpModel editMpModelFromJson(String str) => EditMpModel.fromJson(json.decode(str));

String editMpModelToJson(EditMpModel data) => json.encode(data.toJson());

class EditMpModel {
    EditMpModel({
        this.bio,
        this.constituency,
        this.county,
        this.dateOfBirth,
        this.picture,
        this.martialStatus,
        this.name,
    });

    String bio;
    String constituency;
    String county;
    DateTime dateOfBirth;
    String picture;
    String martialStatus;
    String name;

    factory EditMpModel.fromJson(Map<String, dynamic> json) => EditMpModel(
        bio: json["bio"],
        constituency: json["constituency"],
        county: json["county"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        picture: json["picture"],
        martialStatus: json["martial_status"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "bio": bio,
        "constituency": constituency,
        "county": county,
        "date_of_birth": dateOfBirth.toIso8601String(),
        "picture": picture,
        "martial_status": martialStatus,
        "name": name,
    };
}
