// To parse this JSON data, do
//
//     final addWebinarModel = addWebinarModelFromJson(jsonString);

import 'dart:convert';

AddWebinarModel addWebinarModelFromJson(String str) =>
    AddWebinarModel.fromJson(json.decode(str));

String addWebinarModelToJson(AddWebinarModel data) =>
    json.encode(data.toJson());

class AddWebinarModel {
  AddWebinarModel({
    this.agenda,
    this.hostedBy,
    this.description,
    this.duration,
    this.scheduleAt,
  });

  String agenda;
  String hostedBy;
  String description;
  int duration;
  DateTime scheduleAt;

  factory AddWebinarModel.fromJson(Map<String, dynamic> json) =>
      AddWebinarModel(
        agenda: json["agenda"],
        hostedBy: json["hosted_by"],
        description: json["description"],
        duration: json["duration"],
        scheduleAt: DateTime.parse(json["schedule_at"]),
      );

  Map<String, dynamic> toJson() => {
        "agenda": agenda,
        "hosted_by": hostedBy,
        "description": description,
        "duration": duration,
        "schedule_at": scheduleAt.toIso8601String(),
      };
}
