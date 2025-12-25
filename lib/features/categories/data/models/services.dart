import 'dart:convert';

class ServicesModel {
  final int id;
  final String value;
  final String? name;
  final String? userType; // nurse, assistant, doctor

  const ServicesModel({
    required this.id,
    required this.value,
    this.name,
    this.userType,
  });

  static ServicesModel fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      id: json['id'],
      value: json['value'] ?? "",
      name: json['name'] ?? "",
      userType: json['user_type'],
    );
  }

  static List<ServicesModel> listModelFromJson(dynamic data) {
    if (data == null) return [];

    List<dynamic> parsedList = [];
    if (data is String) {
      if (data.isEmpty || data == 'null') return [];
      try {
        parsedList = json.decode(data);
      } catch (e) {
        return [];
      }
    } else if (data is List) {
      parsedList = data;
    } else {
      return [];
    }

    return parsedList.map((x) {
      if (x is Map<String, dynamic>) {
        return ServicesModel.fromJson(x);
      } else if (x is int) {
        return ServicesModel(id: x, value: "");
      } else if (x is String) {
        return ServicesModel(id: int.tryParse(x) ?? 0, value: "");
      }
      return const ServicesModel(id: 0, value: "");
    }).toList();
  }
}
