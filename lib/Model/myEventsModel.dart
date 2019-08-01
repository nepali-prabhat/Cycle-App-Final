// To parse this JSON data, do
//
//     final myEvents = myEventsFromJson(jsonString);

import 'dart:convert';

List<MyEventsModel> myEventsFromJson(String str) => new List<MyEventsModel>.from(json.decode(str).map((x) => MyEventsModel.fromMap(x)));

String myEventsToJson(List<MyEventsModel> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toMap())));

class MyEventsModel {
    int id;
    String name;
    String description;
    DateTime startDateTime;
    DateTime endDateTime;
    int host;
    int completed;
    DateTime createdAt;
    DateTime updatedAt;
    List<dynamic> participants;

    MyEventsModel({
        this.id,
        this.name,
        this.description,
        this.startDateTime,
        this.endDateTime,
        this.host,
        this.completed,
        this.createdAt,
        this.updatedAt,
        this.participants,
    });

    factory MyEventsModel.fromMap(Map<String, dynamic> json) => new MyEventsModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        startDateTime: DateTime.parse(json["start_date_time"]),
        endDateTime: DateTime.parse(json["end_date_time"]),
        host: json["host"],
        completed: json["completed"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        participants: new List<dynamic>.from(json["participants"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "start_date_time": startDateTime.toIso8601String(),
        "end_date_time": endDateTime.toIso8601String(),
        "host": host,
        "completed": completed,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "participants": new List<dynamic>.from(participants.map((x) => x)),
    };
}