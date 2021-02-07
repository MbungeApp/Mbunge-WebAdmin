// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

List<EventModel> eventModelFromJson(String str) => List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x)));

String eventModelToJson(List<EventModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventModel {
    EventModel({
        this.body,
        this.createdAt,
        this.id,
        this.name,
        this.picture,
        this.updatedAt,
    });

    String body;
    DateTime createdAt;
    String id;
    String name;
    String picture;
    DateTime updatedAt;

    factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        body: json["body"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        name: json["name"],
        picture: json["picture"],
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "body": body,
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "name": name,
        "picture": picture,
        "updated_at": updatedAt.toIso8601String(),
    };
}
