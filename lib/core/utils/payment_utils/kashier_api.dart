import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/utils/sms_api.dart';



class KashierClass {
  /// this webhook on our backend and has been added
  //https://softifytechs.com/icare_backend/api/v1/kashierWebhook
  //


  // static const String invoiceUrl = "https://api.kashier.io/paymentRequest?currency=EGP";
  // static const String secretKey = '3592a0451638c12608d68af27a277edb\$e0ffc08c97e45bf03bb15f0c605ce10c97a4ea5d146439de088df60cf77da921b2e75317dbf82dee844e38a640a0377f';
  

  static const String invoiceUrl = "https://test-api.kashier.io/paymentRequest/?currency=EGP";
  static const String secretKey = 'c1b7b6b9455e34a707dee4d0864fbcf9\$c3a3cd37b2b9d66ed0d849904a5d3372e7169b81c6b975417a7bab305d94f0362283ae0734934c736ba3dd6db8c3d050';

  static const String merchantId = "MID-22182-619";


  static createNewInvoice()async{
    var data = {
      "paymentType": "professional",
      "merchantId": merchantId,
      "customerName": "test invoice by developer",
      "dueDate":"2024-02-30T10:49:24.831Z",
      "isSuspendedPayment":true,
      "description": "some description",
      "invoiceReferenceId": SmsApi.getRandom().toString(),
      "invoiceItems": [
        {
          "description": "invoice item description",
          "quantity": 5,
          "itemName": "laptop",
          "unitPrice": 10,
          "subTotal": 50
        }
      ],
      "state": "submitted",
      "currency": "EGP"
    };
    var response = await http.post(Uri.parse(invoiceUrl),
        headers: {
          "Content-Type" : "application/json",
          "Authorization": secretKey
        },body: jsonEncode(data)
    );
    debugPrint("createNewInvoice: ${response.body}");
  }

  static generateURL(){
    String invoiceID= "65d0dea7a5026c0013ae732c";
    String paymentRequestID = "INV-2218261907";
    String serverWebhook = "https://softifytechs.com/icare_backend/api/v1/kashierWebhook";
    String url = 'https://checkout.kashier.io/?merchantId=MID-22182-619&orderId=$invoiceID&amount=50&currency=EGP&hash=ORDER-HASH&mode=ORDER-MODE&merchantRedirect=http://icarebackend.softifytechs.com/&serverWebhook=$serverWebhook&metaData=ORDER-META-DATA&paymentRequestId=$paymentRequestID&allowedMethods=ORDER-ALLOWED-METHODS&defaultMethod=ORDER-DEFAULT-METHOD&failureRedirect=ORDER-FAILURE-REDIRECT&redirectMethod=ORDER-REDIRECT-METHOD&connectedAccount=ORDER-CONNECTED-ACCOUNT&brandColor=ORDER-BRAND-COLOR&display=ORDER-DISPLAY&manualCapture=ORDER-AUTH&customer=Customer-data&saveCard=customer-saveCard&interactionSource=Ecommerce&enable3DS=true' ;

    return url;
  }


}