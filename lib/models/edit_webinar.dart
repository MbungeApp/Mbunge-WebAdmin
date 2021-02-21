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
        this.postponed,
        this.scheduleAt,
    });

    String agenda;
    String hostedBy;
    String description;
    int duration;
    bool postponed;
    DateTime scheduleAt;

    factory EditWebinarModel.fromJson(Map<String, dynamic> json) => EditWebinarModel(
        agenda: json["agenda"] == null ? null : json["agenda"],
        hostedBy: json["hosted_by"] == null ? null : json["hosted_by"],
        description: json["description"] == null ? null : json["description"],
        duration: json["duration"] == null ? null : json["duration"],
        postponed: json["postponed"] == null ? null : json["postponed"],
        scheduleAt: json["schedule_at"] == null ? null : DateTime.parse(json["schedule_at"]),
    );

    Map<String, dynamic> toJson() => {
        "agenda": agenda == null ? null : agenda,
        "hosted_by": hostedBy == null ? null : hostedBy,
        "description": description == null ? null : description,
        "duration": duration == null ? null : duration,
        "postponed": postponed == null ? null : postponed,
        "schedule_at": scheduleAt == null ? null : scheduleAt.toIso8601String(),
    };
}
