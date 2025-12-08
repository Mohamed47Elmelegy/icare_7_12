


import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/booking/domain/entities/order.dart';

class OrderModel extends Booking {
  const OrderModel({
    super.orderId,
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
    super.nurseCanEditPatientProfile
  });

  static OrderModel fromJson(Map<String, dynamic> jsonObject) {
    return OrderModel(
        orderId: int.parse((jsonObject['id']??"0").toString()),
        code: int.parse((jsonObject['id']??"0").toString()),
        desc: jsonObject['desc'].toString(),
        status: jsonObject['order_status'],
        statusView: getStatus(jsonObject['order_status']),
        date: jsonObject['created_at']??"",
        city: jsonObject['address']??"",
        shippingAddress: jsonObject['address']??"",
        userId: int.tryParse((jsonObject['user_id']??"0").toString())??int.parse("0"),
        userName: jsonObject['user_name'] ?? "",
        userGender: jsonObject['user_gender'].toString() =='1' ? 'male' : 'female',
        nurseName: jsonObject['nurse_name'] ?? "",
        nurseID:  int.parse((jsonObject['nurse_id']??"0").toString()),
        totalPrice:  double.parse((jsonObject['total_price']??"0.0").toString()),
        nurseCanEditPatientProfile: jsonObject['nurse_can_edit_patient'].toString() == '2',
        lat: double.parse((jsonObject['lat']??'0').toString()),
        lng: double.parse((jsonObject['lng']??'0').toString()),
    );
  }


  static getStatus(String val){
    if(val=="wc-processing" || val == "PENDING"){
      return translate("order.pending");
    }else if(val=="wc-on-hold"){
      return translate("order.on_going_orders");
    }else if(val=="wc-completed" || val == "COMPLETED" || val == "DELIVERED"){
      return translate("order.order_has_done");
    }
    return val;
  }

  static getStatusViewCheck(String val){
    if(val=="wc-processing" || val.toUpperCase() == "PENDING" ){
      return ORDER_STATUS.PENDING;
    }else if(val=="wc-on-hold" || val.toUpperCase()=="ONGOING"){
      return ORDER_STATUS.ONGOING;
    }else if(val=="wc-completed" || val.toUpperCase() == "COMPLETED" || val == "DELIVERED"){
      return ORDER_STATUS.COMPLETED;
    }
    return ORDER_STATUS.PENDING;
  }


}
