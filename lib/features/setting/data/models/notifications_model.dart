import 'dart:convert';

import 'package:icare/features/booking/domain/entities/request_entity.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';


class NotificationsModel extends NotificationsEntity{
  const NotificationsModel({required super.id, required super.userID, required super.title,
    required super.content,required super.date, required super.type,
    required super.orderID,required super.requestEntity
  });

  static List<NotificationsModel> notificationListFromJson(String str) =>
      List<NotificationsModel>.from(
          json.decode(str).map((x) => NotificationsModel.fromJson(x)));

  static NotificationsModel fromJson(Map<String, dynamic> jsonObject) {
    return NotificationsModel(
      id: jsonObject['id'],
      userID: jsonObject['user_id'],
      title: jsonObject['title'],
      content: jsonObject['content'] ?? "",
      type: jsonObject['type'].toString().replaceAll("null", ""),
      date: jsonObject['created_at'],
      orderID: int.parse((jsonObject['order_id']??"-1").toString()),
      requestEntity: RequestEntity.fromJson(jsonObject['request'])
    );
  }
}