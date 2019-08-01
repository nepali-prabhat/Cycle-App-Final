// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

class UserModel {
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

    UserModel({
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
    });

    factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserModel.fromMap(Map<String, dynamic> json) => new UserModel(
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
    };
}
