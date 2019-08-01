import 'dart:convert';
class LongLat {
    double long;
    double lat;

    LongLat({
        this.long,
        this.lat,
    });

    factory LongLat.fromJson(String str) => LongLat.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LongLat.fromMap(Map<String, dynamic> json) => new LongLat(
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "long": long,
        "lat": lat,
    };
}
