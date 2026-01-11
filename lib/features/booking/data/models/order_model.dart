import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/core/strings/api/api_url.dart';

class OrderModel extends Booking {
  const OrderModel(
      {super.orderId,
      super.code,
      super.userId,
      super.userName,
      super.userGender,
      super.nurseID,
      super.nurseName,
      super.companyID,
      super.desc,
      super.area,
      super.city,
      super.shippingAddress,
      super.addressId,
      super.status,
      super.statusView,
      super.type,
      super.price,
      super.discount,
      super.couponDiscount,
      super.totalPrice,
      super.paymentMethod,
      super.lat,
      super.lng,
      super.date,
      super.file,
      super.heartRate,
      super.bloodPressure,
      super.height,
      super.weight,
      super.pulseRate,
      super.mobile,
      super.userImage,
      super.patientAllergies,
      super.nurseCanEditPatientProfile,
      super.nurseCurrentLat,
      super.nurseCurrentLng,
      super.arrivedAtPatientTime,
      super.distanceToPatient});

  static OrderModel fromJson(Map<String, dynamic> jsonObject) {
    return OrderModel(
      orderId: int.parse((jsonObject['id'] ?? "0").toString()),
      code: int.parse((jsonObject['id'] ?? "0").toString()),
      desc: jsonObject['desc'].toString(),
      status: jsonObject['order_status'],
      statusView: getStatus(jsonObject['order_status']),
      date: jsonObject['created_at'] ?? "",
      city: jsonObject['address'] ?? "",
      shippingAddress: jsonObject['address'] ?? "",
      userId: int.tryParse((jsonObject['user_id'] ?? "0").toString()) ??
          int.parse("0"),
      userName: jsonObject['user']?['name'] ?? jsonObject['user_name'] ?? "",
      userGender: (jsonObject['user']?['is_male'].toString() == '1' ||
              jsonObject['user_gender'].toString() == '1')
          ? 'male'
          : 'female',
      nurseName: jsonObject['nurse_name'] ?? "",
      nurseID: () {
        int nId = int.tryParse((jsonObject['nurse_id'] ?? "0").toString()) ?? 0;
        if (nId != 0) return nId;

        // Fallback to doctor_id
        var dIdVal = jsonObject['doctor_id'];
        if (dIdVal != null && dIdVal.toString().trim().isNotEmpty) {
          return int.tryParse(dIdVal.toString()) ?? 0;
        }
        return 0;
      }(),
      totalPrice:
          double.tryParse((jsonObject['total_price'] ?? "0.0").toString()) ??
              0.0,
      nurseCanEditPatientProfile: true,
      lat: double.tryParse((jsonObject['lat'] ?? '0').toString()) ?? 0.0,
      lng: double.tryParse((jsonObject['lng'] ?? '0').toString()) ?? 0.0,
      heartRate: jsonObject['heart_rate']?.toString() ?? "",
      bloodPressure: jsonObject['blood_pressure']?.toString() ?? "",
      height: jsonObject['height']?.toString() ?? "",
      weight: jsonObject['weight']?.toString() ?? "",
      pulseRate: jsonObject['pulse_rate']?.toString() ?? "",
      mobile: jsonObject['user']?['phone']?.toString() ??
          jsonObject['user_phone']?.toString() ??
          "",
      userImage: getImage(jsonObject['user']?['avatar']?.toString() ??
          jsonObject['user_image']?.toString()),
      patientAllergies: jsonObject['allergies'] != null
          ? List<String>.from(jsonObject['allergies'].map((x) => x.toString()))
          : [],
    );
  }

  static String getImage(String? image) {
    if (image == null || image == "" || image == "uploads/all/") return "";
    if (image.startsWith("http")) return image;
    return ApiUrl.STORAGE_URL + image;
  }

  static getStatus(String val) {
    if (val == "wc-processing" || val == "PENDING") {
      return translate("order.pending");
    } else if (val == "wc-on-hold") {
      return translate("order.on_going_orders");
    } else if (val == "wc-completed" ||
        val == "COMPLETED" ||
        val == "DELIVERED") {
      return translate("order.order_has_done");
    } else if (val.toUpperCase() == "REFUESD" ||
        val.toUpperCase() == "REFUSED" ||
        val.toUpperCase() == "CANCELED") {
      return "تم إلغاء الطلب";
    }
    return val;
  }

  static getStatusViewCheck(String val) {
    if (val == "wc-processing" || val.toUpperCase() == "PENDING") {
      return ORDER_STATUS.PENDING;
    } else if (val == "wc-on-hold" || val.toUpperCase() == "ONGOING") {
      return ORDER_STATUS.ONGOING;
    } else if (val == "wc-completed" ||
        val.toUpperCase() == "COMPLETED" ||
        val == "DELIVERED") {
      return ORDER_STATUS.COMPLETED;
    } else if (val.toUpperCase() == "REFUESD" ||
        val.toUpperCase() == "REFUSED" ||
        val.toUpperCase() == "CANCELED") {
      return ORDER_STATUS.REFUSED;
    }
    return ORDER_STATUS.PENDING;
  }
}
