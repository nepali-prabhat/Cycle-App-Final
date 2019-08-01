import 'dart:convert';

List<ParticipantsModel> participantsModelFromJson(String str) => new List<ParticipantsModel>.from(json.decode(str).map((x) => ParticipantsModel.fromMap(x)));

String participantsModelToJson(List<ParticipantsModel> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toMap())));

class ParticipantsModel {
    int id;
    String username;
    String fName;
    String lName;
    String email;
    String phoneNo;
    String address;
    int permission;
    String bio;
    DateTime createdAt;
    DateTime updatedAt;
    Pivot pivot;

    ParticipantsModel({
        this.id,
        this.username,
        this.fName,
        this.lName,
        this.email,
        this.phoneNo,
        this.address,
        this.permission,
        this.bio,
        this.createdAt,
        this.updatedAt,
        this.pivot,
    });

    factory ParticipantsModel.fromMap(Map<String, dynamic> json) => new ParticipantsModel(
        id: json["id"],
        username: json["username"],
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        phoneNo: json["phone_no"],
        address: json["address"],
        permission: json["permission"],
        bio: json["bio"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pivot: Pivot.fromMap(json["pivot"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "f_name": fName,
        "l_name": lName,
        "email": email,
        "phone_no": phoneNo,
        "address": address,
        "permission": permission,
        "bio": bio,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pivot": pivot.toMap(),
    };
}

class Pivot {
    int eventId;
    int userId;

    Pivot({
        this.eventId,
        this.userId,
    });

    factory Pivot.fromMap(Map<String, dynamic> json) => new Pivot(
        eventId: json["event_id"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toMap() => {
        "event_id": eventId,
        "user_id": userId,
    };
}