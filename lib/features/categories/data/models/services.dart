
import 'dart:convert';

class ServicesModel{
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

  static List<ServicesModel> listModelFromJson(String str) =>
      List<ServicesModel>.from(
          json.decode(str).map((x) => ServicesModel.fromJson(x)));

}