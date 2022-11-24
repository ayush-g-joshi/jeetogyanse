// To parse this JSON data, do
//
//     final selectSubject = selectSubjectFromJson(jsonString);

import 'dart:convert';

List<SelectSubject> selectSubjectFromJson(String str) =>
    List<SelectSubject>.from(
        json.decode(str).map((x) => SelectSubject.fromJson(x)));

String selectSubjectToJson(List<SelectSubject> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SelectSubject {
  SelectSubject({
    required this.name,
    required this.image,
  });

  String name;
  String image;

  factory SelectSubject.fromJson(Map<String, dynamic> json) => SelectSubject(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
