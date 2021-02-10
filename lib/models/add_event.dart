// To parse this JSON data, do
//
//     final addEventModel = addEventModelFromJson(jsonString);

import 'dart:convert';

import 'dart:typed_data';

AddEventModel addEventModelFromJson(String str) =>
    AddEventModel.fromJson(json.decode(str));

String addEventModelToJson(AddEventModel data) => json.encode(data.toJson());

class AddEventModel {
  AddEventModel({
    this.name,
    this.body,
  });

  String name;
  Uint8List picture;
  String body;

  factory AddEventModel.fromJson(Map<String, String> json) => AddEventModel(
        name: json["name"],
        body: json["body"],
      );

  Map<String, String> toJson() => {
        "name": name,
        "body": body,
      };
}
