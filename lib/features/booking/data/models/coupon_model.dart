class CouponModel {
  String? code;
  bool?  isPercent;
  int?  amount;
  String? sessionKey;
  int? sessionID;
  double? total;

  CouponModel({this.code, this.isPercent,this.amount,this.sessionKey,this.sessionID,this.total});

  // static CouponModel fromJson(Map<String, dynamic> jsonObject) {
  //   return CouponModel(
  //     sessionKey: jsonObject['session_key'],
  //     sessionID: jsonObject['session_id'],
  //     code: jsonObject['session_value']['applied_coupons'][0],
  //     isPercent: jsonObject['post_date']??"",
  //     amount: jsonObject['session_value']['coupon_discount_totals']['test-coupon'],
  //   );
  // }
}