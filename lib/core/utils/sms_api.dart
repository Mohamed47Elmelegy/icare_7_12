// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/strings/constant.dart';
import 'package:icare/core/utils/send_gmail.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:icare/features/shared_widgets/snackbars_builder.dart';



class SmsApi{
  static getRandom(){
    var next = math.Random().nextDouble() * 1000;
    while (next < 1000) {
      next *= 10;
    }
    return next.toInt().toString();
  }

  static Future<bool> sendOtp({required String provider,bool isEmail=true,required BuildContext ctx})async{
    if(isEmail){
      var otp = getRandom();
      SharedPref().setPreferencesString(Constants.lastVerificationCode, otp);
      return await SendGmail.sendEmailMessage("This is verification code : $otp  for Icare App", provider, "Verification Otp");
    }else{
      return await sendMobileOtp(phone: provider,ctx: ctx);
    }
  }

  static Future<bool> sendMobileOtp({required String phone,required BuildContext ctx})async{
    try{
      var otp = getRandom();
      var data = {
        "otp":otp,
        "phone":phone
      };
      var response = await http.post(Uri.parse(ApiUrl.SEND_OTP),
        headers: {
          "Content-Type": "application/json",
        },body: jsonEncode(data)
      );
      debugPrint("sendOtp: ${response.body}");
      var decodedData = jsonDecode(response.body);
      if(decodedData.toString().contains("4901")){
        SharedPref().setPreferencesString(Constants.lastVerificationCode, otp);
        return true;
      }else{
        // decodedData['message'].toString()
        debugPrint("sendOtp: ${response.body}");
        SnackBarBuilder.showFeedBackMessage(ctx, translate("toast.oops"), Colors.red);
        return false;
      }
    }catch(e){
      debugPrint('err $e');
      return false;
    }
  }

}