import 'dart:convert';

EditEventModel addEventModelFromJson(String str) =>
    EditEventModel.fromJson(json.decode(str));

String editEventModelToJson(EditEventModel data) => json.encode(data.toJson());

class EditEventModel {
  EditEventModel({
    this.name,
    this.picture,
    this.body,
  });

  String name;
  String picture;
  String body;

  factory EditEventModel.fromJson(Map<String, String> json) => EditEventModel(
        name: json["name"],
        picture: json["picture"],
        body: json["body"],
      );

  Map<String, String> toJson() => {
        "name": name,
        "body": body,
        "picture": picture,
      };
}
