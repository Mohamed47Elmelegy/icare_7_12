import 'package:flutter/foundation.dart';
import 'package:icare/features/categories/data/models/services.dart';

@immutable
abstract class ServicesEvent {
  const ServicesEvent();
}

class FetchAllServicesEvent extends ServicesEvent {
  final String? userType;
  const FetchAllServicesEvent({this.userType});
}

class FetchAllNotificationsEvent extends ServicesEvent {
  const FetchAllNotificationsEvent();
}

class ChangeCurrentService extends ServicesEvent {
  final ServicesModel item;
  final String? txt;
  const ChangeCurrentService({required this.item, this.txt});
}

class ModifyCurrentService extends ServicesEvent {
  final ServicesModel item;
  final String? txt;
  final bool? isRemove;
  const ModifyCurrentService({required this.item, this.txt, this.isRemove});
}

class EnableModifyCurrentService extends ServicesEvent {
  final int item;
  const EnableModifyCurrentService({
    required this.item,
  });
}
