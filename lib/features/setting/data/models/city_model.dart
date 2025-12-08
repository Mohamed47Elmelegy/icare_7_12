
import 'dart:convert';

class CityModel{
  final int id;
  final String title;
  final int governorateID;
  final double latitude;
  final double longitude;
  CityModel({required this.id,required this.title,required this.governorateID,required this.longitude,required this.latitude});



  static List<CityModel> listFromJson(String str) =>
      List<CityModel>.from(
          json.decode(str).map((x) => CityModel.fromJson(x)));

  static CityModel fromJson(Map<String, dynamic> jsonObject) {
    return CityModel(
      id: jsonObject['id'],
      title: jsonObject['name'],
      latitude: double.parse(jsonObject['latitude']==null||jsonObject['latitude']=="" ? "0" : jsonObject['latitude']),
      longitude: double.parse(jsonObject['longitude']==null||jsonObject['longitude']=="" ? "0" : jsonObject['longitude']),
      governorateID: int.parse((jsonObject['governorate_id'] ?? "0").toString()),
    );
  }
}