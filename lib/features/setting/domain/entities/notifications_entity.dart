import 'package:equatable/equatable.dart';
import 'package:icare/features/booking/domain/entities/request_entity.dart';

class NotificationsEntity extends Equatable {
  final int id;
  final int userID;
  final String title;
  final String content;
  final String type;
  final String date;
  final int orderID;

  final RequestEntity requestEntity;

  const NotificationsEntity(
      {required this.id,
      required this.userID,
      required this.title,
      required this.content,
      required this.type,
      required this.orderID,
      required this.date,
      required this.requestEntity});

  @override
  List<Object?> get props => [id, userID];
}
