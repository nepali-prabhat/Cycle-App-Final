// To parse this JSON data, do
//
//     final nearbyUsers = nearbyUsersFromJson(jsonString);

import 'dart:convert';

List<NearbyUsers> nearbyUsersFromJson(String str) => new List<NearbyUsers>.from(json.decode(str).map((x) => NearbyUsers.fromMap(x)));

String nearbyUsersToJson(List<NearbyUsers> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toMap())));

class NearbyUsers {
    User user;
    double long;
    double lat;

    NearbyUsers({
        this.user,
        this.long,
        this.lat,
    });

    factory NearbyUsers.fromMap(Map<String, dynamic> json) => new NearbyUsers(
        user: User.fromMap(json["user"]),
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "user": user.toMap(),
        "long": long,
        "lat": lat,
    };
}

class User {
    String username;
    String bio;

    User({
        this.username,
        this.bio,
    });

    factory User.fromMap(Map<String, dynamic> json) => new User(
        username: json["username"],
        bio: json["bio"],
    );

    Map<String, dynamic> toMap() => {
        "username": username,
        "bio": bio,
    };
}
