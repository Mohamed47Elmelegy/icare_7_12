import 'package:flutter/foundation.dart';

@immutable
abstract class ServicesState {
  const ServicesState();
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesSuccess extends ServicesState {}

class NotificationsLoading extends ServicesState {}

class NotificationsSuccess extends ServicesState {}

class ServicesError extends ServicesState {
  final String message;
  const ServicesError(this.message);
}
