import 'dart:convert';

import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/setting/data/data_sources/settings_remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SendGmail{

  /// this function use now for verification code only
  static Future<bool> sendEmailMessage(String bodyMsg,String userEmail,String subject) async{
    try{
      final response = await http.post(Uri.parse("https://api.smtp2go.com/v3/email/send"),
          body: jsonEncode({
            "api_key": "api-4D1738CA3F2D11EEA5BDF23C91BBF4A0",
            "to": ["Person <$userEmail>"],
            "sender": "Test <info@sof.com>",
            // 'cc':["icarestarsportal@gmail.com"],
            "subject": subject,
            "text_body": bodyMsg,
            // "html_body":html,
            "custom_headers": [
              {
                "header": "Reply-To",
                "value": "Actual Person <$userEmail>"
              }
            ]
          })
      );
      debugPrint("sendGmailResponseTo $userEmail:  ${response.body}");
      var decodedData = jsonDecode(response.body);
      return decodedData['data']['succeeded'].toString().trim() == "1";
    }catch(e){
      debugPrint("sendEmailMessage: $e");
      return false;
    }
  }

  static Future<bool> sendContactUs(String title,String bodyMsg,String userName,String lastName,String phone,String userEmail,String subject) async{
    try{
     return await SettingsRemoteDataSource.sendContactUs(
          {
            "first_name": userName,
            "last_name": lastName,
            "phone_number": phone,
            "email": userEmail,
            "city": Util.getCity(),
            "subject_type": subject,
            "title": title,
            "message": bodyMsg,
            'lang': Util.getLang()
          }
      );
      // String name = "$userName $lastName";
      // final response = await http.post(Uri.parse("https://api.smtp2go.com/v3/email/send"),
      //     body: jsonEncode({
      //       "api_key": "api-4D1738CA3F2D11EEA5BDF23C91BBF4A0",
      //       "to": ["AwadNahas <info@awdbadinahas.com>"],
      //       "sender": "$name <info@awdbadinahas.com>",
      //       'cc':[userEmail],
      //       "subject": subject,
      //       "text_body": "$title \n $bodyMsg",
      //       // "html_body":html,
      //       "custom_headers": [
      //         {
      //           "header": "Reply-To",
      //           "value": "Actual Person <$userEmail>"
      //         }
      //       ]
      //     })
      // );
      // debugPrint("sendGmailResponseTo $userEmail:  ${response.body}");
      // var decodedData = jsonDecode(response.body);
      // return decodedData['data']['succeeded'].toString().trim() == "1";
    }catch(e){
      debugPrint("sendEmailMessage: $e");
      return false;
    }
  }


}