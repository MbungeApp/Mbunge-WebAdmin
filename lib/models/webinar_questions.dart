// To parse this JSON data, do
//
//     final questions = questionsFromJson(jsonString);

import 'dart:convert';

List<Questions> questionsFromJson(String str) =>
    List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));

String questionsToJson(List<Questions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questions {
  Questions({
    this.id,
    this.userId,
    this.userName,
    this.participationId,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  String id;
  String userId;
  String userName;
  String participationId;
  String body;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        id: json["id"],
        userId: json["user_id"],
        userName: json["user_name"],
        participationId: json["participation_id"],
        body: json["body"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "user_name": userName,
        "participation_id": participationId,
        "body": body,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.emailAddress,
  });

  String id;
  String firstName;
  String lastName;
  String emailAddress;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        emailAddress: json["email_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email_address": emailAddress,
      };
}
