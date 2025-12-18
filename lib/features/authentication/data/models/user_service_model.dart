import 'dart:convert';

import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/nurse/data/models/nurse_model.dart';
import 'package:icare/features/doctor/data/models/doctor_model.dart';

class UserServiceModel extends UserService {
  const UserServiceModel({
    required super.userId,
    required super.userName,
    required super.email,
    required super.phoneNumber,
    required super.userType,
    super.isWomen,
    required super.address,
    required super.image,
    super.governorate,
    super.cityID,
    super.lat,
    super.long,
    super.allergiesList,
    super.publications,
    super.medicalConditions,
    super.status,
    super.nurse,
    super.doctor,
    super.emergencyContactsList,
    super.distanceKM,
    super.distanceM,
  });

  static UserServiceModel fromJson(Map<String, dynamic> fromJson) {
    var lat = double.tryParse(fromJson['latitude'] ?? "") != null
        ? double.parse(fromJson['latitude'] ?? "")
        : 0.0;
    var long = double.tryParse(fromJson['longitude'] ?? "") != null
        ? double.parse(fromJson['longitude'] ?? "")
        : 0.0;
    List<String> emergencyContactsList = [];
    if (fromJson['emergency_contacts'] != null &&
        fromJson['emergency_contacts'] != '') {
      var emergencyContactsRaw = fromJson['emergency_contacts'];
      if (fromJson['user_type'] == 'customer') {
        emergencyContactsRaw = emergencyContactsRaw.replaceAllMapped(
            RegExp(r'\b(\d+)\b'), // For any numbers
            (match) => '"${match.group(0)}"' // Enclose them in quotes
            );
      }
      emergencyContactsList = getEmergencyList(emergencyContactsRaw);
    }
    return UserServiceModel(
      userId: fromJson['id'] ?? Util.getUserID(),
      userName: fromJson['name'].toString().replaceAll("null", ""),
      email: fromJson['email'].toString().replaceAll("null", ""),
      image: getImage(fromJson['avatar']),
      phoneNumber: fromJson['phone'].toString().replaceAll("null", ""),
      userType: fromJson['user_type'].toString().replaceAll("null", ""),
      isWomen: fromJson['is_male'] == null
          ? false
          : (fromJson['is_male'].toString().trim() == "0"),
      address: fromJson['address'].toString().replaceAll("null", ""),
      lat: lat,
      long: long,
      allergiesList: fromJson['allergies'] == null ||
              fromJson['allergies'].toString() == ""
          ? []
          : AllergiesModel.listModelFromJson(fromJson['allergies']),
      publications: fromJson['publications'] ?? "",
      medicalConditions: fromJson['medical_conditions'] ?? "",
      governorate: fromJson['governorate'] ?? '',
      cityID: fromJson['city'] ?? '',
      status: fromJson['status'] == "online",
      emergencyContactsList: fromJson['emergency_contacts'] == null ||
              fromJson['emergency_contacts'] == ''
          ? []
          : emergencyContactsList,
      nurse: fromJson['nurse'] == null ||
              fromJson['nurse'].toString() == '' ||
              fromJson['nurse'].toString() == 'null'
          ? null
          : NurseModel.fromJsonUser(fromJson['nurse']),
      doctor: fromJson['doctor'] == null ||
              fromJson['doctor'].toString() == '' ||
              fromJson['doctor'].toString() == 'null'
          ? null
          : DoctorModel.fromJsonUser(fromJson['doctor']),
      distanceKM: double.tryParse(fromJson['distanceKm'] ?? "-1"),
      distanceM: double.tryParse(fromJson['distanceMe'] ?? "-1"),
    );
  }

  static String getImage(String? image) {
    if (image == null || image == "" || image == "uploads/all/") return "";
    return ApiUrl.STORAGE_URL + image;
  }

  static getEmergencyList(var emergencyContactsRaw) {
    List<String> emergencyContactsList = [];
    if (emergencyContactsRaw is String) {
      // If it's a string, we need to decode it (it represents a JSON array)
      List<dynamic> decodedList = jsonDecode(emergencyContactsRaw);
      // Convert the list to List<String>
      emergencyContactsList =
          decodedList.map((number) => number.toString()).toList();
    } else if (emergencyContactsRaw is List) {
      // If it's already a list, convert it
      emergencyContactsList =
          emergencyContactsRaw.map((number) => number.toString()).toList();
    }
    return emergencyContactsList;
  }
}

class Shipping {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;

  Shipping(
      {this.firstName,
      this.lastName,
      this.company,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.postcode,
      this.country});

  Shipping.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    data['country'] = country;
    return data;
  }
}
