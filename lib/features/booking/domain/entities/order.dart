// ignore_for_file: camel_case_types, constant_identifier_names

import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final int? orderId;
  final int? code;
  final int? userId;
  final String? userName;
  final String? userGender;
  final int? addressId;
  final int? nurseID;
  final String? nurseName;
  final int? companyID;
  final String? area;
  final String? city;
  final String? shippingAddress;
  final String? desc;
  final String? type;
  final double? price;
  final double? discount;
  final String? couponDiscount;
  final double? totalPrice;
  final String? paymentMethod;
  final double? lat;
  final double? lng;
  final String? status;
  final String? statusView;
  final String? date;
  final String? week;
  final String? day;
  final String? hours;
  final bool? nurseCanEditPatientProfile;

  // Geofencing fields for order completion validation
  final double? nurseCurrentLat;
  final double? nurseCurrentLng;
  final DateTime? arrivedAtPatientTime;
  final double? distanceToPatient;

  final String? file;
  final String? heartRate;
  final String? bloodPressure;
  final String? height;
  final String? weight;
  final String? pulseRate;
  final String? mobile;
  final String? userImage;
  final List<String>? patientAllergies;

  // final String rejectedReason;

  const Booking(
      {this.orderId,
      this.code,
      this.userId,
      this.userName,
      this.userGender,
      this.nurseID,
      this.nurseName,
      this.companyID,
      this.addressId,
      this.desc,
      this.area,
      this.city,
      this.shippingAddress,
      this.status,
      this.statusView,
      this.type,
      this.price,
      this.discount,
      this.couponDiscount,
      this.totalPrice,
      this.paymentMethod,
      this.lat,
      this.lng,
      this.date,
      this.week,
      this.day,
      this.hours,
      this.file,
      this.heartRate,
      this.bloodPressure,
      this.height,
      this.weight,
      this.pulseRate,
      this.mobile,
      this.userImage,
      this.patientAllergies,
      this.nurseCanEditPatientProfile,
      this.nurseCurrentLat,
      this.nurseCurrentLng,
      this.arrivedAtPatientTime,
      this.distanceToPatient});

  @override
  List<Object?> get props => [
        userId,
        nurseID,
        addressId,
        status,
        type,
        price,
        totalPrice,
        discount,
        totalPrice,
        paymentMethod,
        lat,
        lng,
        heartRate,
        bloodPressure,
        height,
        weight,
        pulseRate,
        mobile,
        userImage,
        patientAllergies,
        // rejectedReason
      ];
}
