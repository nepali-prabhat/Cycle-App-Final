import 'dart:convert';

import 'package:cycle_app/Model/UserModel.dart';

List<MessageModel> messageModelFromJson(String str) => new List<MessageModel>.from(json.decode(str).map((x) => MessageModel.fromMap(x)));

String messageModelToJson(List<MessageModel> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toMap())));

class MessageModel {
    int id;
    String text;
    int groupId;
    int userId;
    DateTime createdAt;
    DateTime updatedAt;
    UserModel user;

    MessageModel({
        this.id,
        this.text,
        this.groupId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    factory MessageModel.fromMap(Map<String, dynamic> json) => new MessageModel(
        id: json["id"],
        text: json["text"],
        groupId: json["group_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: UserModel.fromMap(json["user"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "text": text,
        "group_id": groupId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toMap(),
    };
}