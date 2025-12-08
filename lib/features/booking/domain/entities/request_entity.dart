import 'dart:convert';

class RequestEntity {
  final int id;
  final int companyID;
  final String status;
  final String userPhone;
  final String userNote;

  final List<RequestOfferEntity> requestOfferList;


  const RequestEntity({
    required this.id,
    required this.companyID,
    required this.status,
    required this.userPhone,
    required this.userNote,
    required this.requestOfferList
  });


  static RequestEntity fromJson(Map<String, dynamic> jsonObject) {
    return RequestEntity(
        id: int.parse((jsonObject['id']??"0").toString()),
        userPhone: jsonObject['user_phone'].toString(),
        companyID: int.parse((jsonObject['company_id']??"0").toString()),
        userNote: jsonObject['user_note'].toString(),
        status: jsonObject['status'],
        requestOfferList: jsonObject['request_offers']==null?[]:RequestOfferEntity.lsitFromJson(jsonEncode(jsonObject['request_offers']))
    );
  }

  static List<RequestEntity> listFromJson(String str) =>
      List<RequestEntity>.from(
          json.decode(str).map((x) => RequestEntity.fromJson(x)));

}


class RequestOfferEntity{
  final int id;
  final int companyID;
  final String companyName;
  final String status;
  final String offerPrice;
  final int requestID;

  const RequestOfferEntity({
    required this.id,
    required this.companyID,
    required this.companyName,
    required this.status,
    required this.offerPrice,
    required this.requestID,
  });


   
   static RequestOfferEntity fromJson(Map<String, dynamic> jsonObject) {
    return RequestOfferEntity(
        id: int.parse((jsonObject['id']??"0").toString()),
        requestID: int.parse((jsonObject['request_id']??"0").toString()),
        companyID: int.parse((jsonObject['company_id']??"0").toString()),
        companyName: jsonObject['company_name'] ?? '',
        offerPrice: jsonObject['offer_price'].toString(),
        status: jsonObject['status'],
    );
  }

  static List<RequestOfferEntity> lsitFromJson(String str) =>
      List<RequestOfferEntity>.from(
          json.decode(str).map((x) => RequestOfferEntity.fromJson(x)));
}