
import 'dart:convert';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';



class NurseModel  extends NurseEntity{
  const NurseModel({
    required super.id,
    super.userData,
    required super.nurseId,
    required super.associationCard,
    required super.licence,
    required super.certificate,
    required super.reviewList,
    required super.languageList,
    required super.educationList,
    required super.publicationsList,
    required super.coursesList,
    required super.servicesList,
    super.distanceKM,
    super.distanceM
  });

  static NurseModel fromJson(Map<String, dynamic> json) {
    List<ServicesModel> list = json['services']==null || json['services'].toString()==""?[]: ServicesModel.listModelFromJson(json['services']);
    var nurse =  NurseModel(
      id: json['id'],
      userData: json['user']==null ? null : UserServiceModel.fromJson(json['user']),
      nurseId: "${ApiUrl.STORAGE_URL}${json['identification_card']}",
      associationCard: "${ApiUrl.STORAGE_URL}${json['association_card']}",
      licence:"${ApiUrl.STORAGE_URL}${json['license_practice']}",
      certificate: "${ApiUrl.STORAGE_URL}${json['graduation_certificate']}",
      reviewList: ReviewModel.listModelFromJson(jsonEncode(json['reviews'])),
      languageList: json['languages']==null || json['languages'] ==''  || json['languages'].toString()=='null'? [] : jsonDecode(json['languages']).cast<String>().toList(),
      educationList: json['education']==null || json['education'] =='' || json['education'].toString()=='null'? [] : jsonDecode(json['education']).cast<String>().toList(),
      publicationsList: json['publications']==null || json['publications'] =='' || json['publications'].toString()=='null'? [] : jsonDecode(json['publications']).cast<String>().toList(),
      coursesList: json['courses']==null || json['courses'] =='' || json['courses'].toString()=='null'? [] : jsonDecode(json['courses']).cast<String>().toList(),
      servicesList: list,
      distanceKM: double.tryParse(json['distanceKm']??"-1") ,
      distanceM: double.tryParse(json['distanceMe']??"-1") ,
    );
    return nurse;
  }

  static NurseModel fromJsonUser(Map<String, dynamic> json) {
    List<ServicesModel> list = json['services']==null || json['services'].toString()==""?[]: ServicesModel.listModelFromJson(json['services']);
    return NurseModel(
      id: json['id'],
      nurseId: "${ApiUrl.STORAGE_URL}${json['identification_card']}",
      associationCard: "${ApiUrl.STORAGE_URL}${json['association_card']}",
      licence:"${ApiUrl.STORAGE_URL}${json['license_practice']}",
      certificate: "${ApiUrl.STORAGE_URL}${json['graduation_certificate']}",
      reviewList: ReviewModel.listModelFromJson(jsonEncode(json['reviews'])),
      languageList: json['languages']==null || json['languages'] ==''? [] : jsonDecode(json['languages']).cast<String>().toList(),
      educationList: json['education']==null || json['education'] ==''? [] : jsonDecode(json['education']).cast<String>().toList(),
      publicationsList: json['publications']==null || json['publications'] ==''? [] : jsonDecode(json['publications']).cast<String>().toList(),
      coursesList: json['courses']==null || json['courses'] ==''? [] : jsonDecode(json['courses']).cast<String>().toList(),
      servicesList: list,
      distanceKM: double.tryParse(json['distanceKm']??"-1") ,
      distanceM: double.tryParse(json['distanceMe']??"-1") ,
    );
  }



  static Map<String, dynamic> toJsonLocal(CategoriesEntity item) {
    return {
      "id":int.tryParse(item.id.toString()),
    };
  }

  static List<NurseModel> listModelFromJson(String str) =>
      List<NurseModel>.from(
          json.decode(str).map((x) => NurseModel.fromJson(x)));



}


