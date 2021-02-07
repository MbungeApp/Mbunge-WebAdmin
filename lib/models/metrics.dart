// To parse this JSON data, do
//
//     final metrics = metricsFromJson(jsonString);

import 'dart:convert';

Metrics metricsFromJson(String str) => Metrics.fromJson(json.decode(str));

String metricsToJson(Metrics data) => json.encode(data.toJson());

class Metrics {
    Metrics({
        this.card,
        this.genderRation,
        this.mpOfTheWeek,
        this.usersLocation,
    });

    MetricCard card;
    GenderRation genderRation;
    MpOfTheWeek mpOfTheWeek;
    List<UsersLocation> usersLocation;

    factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        card: MetricCard.fromJson(json["card"]),
        genderRation: GenderRation.fromJson(json["gender_ration"]),
        mpOfTheWeek: MpOfTheWeek.fromJson(json["mp_of_the_week"]),
        usersLocation: List<UsersLocation>.from(json["users_location"].map((x) => UsersLocation.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "card": card.toJson(),
        "gender_ration": genderRation.toJson(),
        "mp_of_the_week": mpOfTheWeek.toJson(),
        "users_location": List<dynamic>.from(usersLocation.map((x) => x.toJson())),
    };
}

class MetricCard {
    MetricCard({
        this.totalEvents,
        this.totalParticipation,
        this.totalResponses,
        this.totalUsers,
    });

    int totalEvents;
    int totalParticipation;
    int totalResponses;
    int totalUsers;

    factory MetricCard.fromJson(Map<String, dynamic> json) => MetricCard(
        totalEvents: json["total_events"],
        totalParticipation: json["total_participation"],
        totalResponses: json["total_responses"],
        totalUsers: json["total_users"],
    );

    Map<String, dynamic> toJson() => {
        "total_events": totalEvents,
        "total_participation": totalParticipation,
        "total_responses": totalResponses,
        "total_users": totalUsers,
    };
}

class GenderRation {
    GenderRation({
        this.female,
        this.male,
    });

    int female;
    int male;

    factory GenderRation.fromJson(Map<String, dynamic> json) => GenderRation(
        female: json["female"],
        male: json["male"],
    );

    Map<String, dynamic> toJson() => {
        "female": female,
        "male": male,
    };
}

class MpOfTheWeek {
    MpOfTheWeek({
        this.age,
        this.constituency,
        this.county,
        this.name,
        this.picture,
    });

    int age;
    String constituency;
    String county;
    String name;
    String picture;

    factory MpOfTheWeek.fromJson(Map<String, dynamic> json) => MpOfTheWeek(
        age: json["age"],
        constituency: json["constituency"],
        county: json["county"],
        name: json["name"],
        picture: json["picture"],
    );

    Map<String, dynamic> toJson() => {
        "age": age,
        "constituency": constituency,
        "county": county,
        "name": name,
        "picture": picture,
    };
}

class UsersLocation {
    UsersLocation({
        this.count,
        this.latitude,
        this.longitude,
        this.name,
    });

    int count;
    double latitude;
    double longitude;
    String name;

    factory UsersLocation.fromJson(Map<String, dynamic> json) => UsersLocation(
        count: json["count"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "latitude": latitude,
        "longitude": longitude,
        "name": name,
    };
}
