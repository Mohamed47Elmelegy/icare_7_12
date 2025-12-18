import 'dart:convert';

class AllergiesModel {
  final int id;
  final String value;
  const AllergiesModel({required this.id, required this.value});

  static AllergiesModel fromJsonAllergies(Map<String, dynamic> json) {
    return AllergiesModel(
      id: json['id'],
      value: json['value'] ?? "",
    );
  }

  static List<AllergiesModel> listModelFromJson(String str) =>
      List<AllergiesModel>.from(
          json.decode(str).map((x) => AllergiesModel.fromJsonAllergies(x)));
}
