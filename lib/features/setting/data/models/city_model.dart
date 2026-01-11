import 'dart:convert';
import 'package:icare/features/setting/domain/entities/city_entity.dart';
import 'package:icare/features/setting/domain/entities/governorate_entity.dart';

class CityModel {
  final int id;
  final String title;
  final int governorateID;
  final double latitude;
  final double longitude;
  CityModel(
      {required this.id,
      required this.title,
      required this.governorateID,
      required this.longitude,
      required this.latitude});

  static List<CityModel> listFromJson(String str) =>
      List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));

  static CityModel fromJson(Map<String, dynamic> jsonObject) {
    return CityModel(
      id: jsonObject['id'],
      title: jsonObject['name'],
      latitude: double.parse(
          jsonObject['latitude'] == null || jsonObject['latitude'] == ""
              ? "0"
              : jsonObject['latitude']),
      longitude: double.parse(
          jsonObject['longitude'] == null || jsonObject['longitude'] == ""
              ? "0"
              : jsonObject['longitude']),
      governorateID:
          int.parse((jsonObject['governorate_id'] ?? "0").toString()),
    );
  }
}

/// Extension for mapping CityModel to domain entities
extension CityModelMapper on CityModel {
  /// Maps to CityEntity (for cities list)
  CityEntity toCityEntity() {
    return CityEntity(
      id: id,
      title: title,
      governorateId: governorateID,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Maps to GovernorateEntity (for governorates list)
  /// Note: CityModel is reused for governorates in the API
  GovernorateEntity toGovernorateEntity() {
    return GovernorateEntity(
      id: id,
      title: title,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
