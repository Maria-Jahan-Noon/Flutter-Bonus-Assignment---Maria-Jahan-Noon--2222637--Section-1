import 'dart:convert';

List<CoffeeRecordsModel> coffeeRecordsModelFromJson(String str) =>
    List<CoffeeRecordsModel>.from(
        json.decode(str).map((x) => CoffeeRecordsModel.fromJson(x)));

String coffeeRecordsModelToJson(List<CoffeeRecordsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoffeeRecordsModel {
  String id;
  String beanOrigin;
  String roastProfile;
  String brewMethod;
  String tastingNotes;
  int rating;
  DateTime createdAt;

  CoffeeRecordsModel({
    required this.id,
    required this.beanOrigin,
    required this.roastProfile,
    required this.brewMethod,
    required this.tastingNotes,
    required this.rating,
    required this.createdAt,
  });

  factory CoffeeRecordsModel.fromJson(Map<String, dynamic> json) =>
      CoffeeRecordsModel(
        id: json["id"] ?? "",
        beanOrigin: json["beanOrigin"] ?? "",
        roastProfile: json["roastProfile"] ?? "",
        brewMethod: json["brewMethod"] ?? "",
        tastingNotes: json["tastingNotes"] ?? "",
        rating: json["rating"] ?? 0,
        createdAt: json["createdAt"] is String
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "beanOrigin": beanOrigin,
        "roastProfile": roastProfile,
        "brewMethod": brewMethod,
        "tastingNotes": tastingNotes,
        "rating": rating,
        "createdAt": createdAt.toIso8601String(),
      };
}