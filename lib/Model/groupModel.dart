import 'dart:convert';

GroupModel groupModelFromJson(String str) => GroupModel.fromMap(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toMap());

class GroupModel {
    int id;
    String name;
    int eventId;

    GroupModel({
        this.id,
        this.name,
        this.eventId,
    });

    factory GroupModel.fromMap(Map<String, dynamic> json) => new GroupModel(
        id: json["id"],
        name: json["name"],
        eventId: json["event_id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "event_id": eventId,
    };
}