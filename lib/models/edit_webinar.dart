// To parse this JSON data, do
//
//     final editWebinarModel = editWebinarModelFromJson(jsonString);

import 'dart:convert';

EditWebinarModel editWebinarModelFromJson(String str) => EditWebinarModel.fromJson(json.decode(str));

String editWebinarModelToJson(EditWebinarModel data) => json.encode(data.toJson());

class EditWebinarModel {
    EditWebinarModel({
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

    factory EditWebinarModel.fromJson(Map<String, dynamic> json) => EditWebinarModel(
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
