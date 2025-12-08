
import 'package:flutter/material.dart';

@immutable
abstract class BookingState{
  const BookingState();
}


class OrderInitialState extends BookingState {}

class OrderLoadingState extends BookingState {}
class SendNewBookingRequestLoadingState extends BookingState {}
class OrderSuccessfullyState extends BookingState {}

class OrderTapSuccessfullyState extends BookingState {}

class OrderErrorState extends BookingState {
  final String errors;

  const OrderErrorState({required this.errors});
}


class ConfirmOrderSuccessfullyState extends BookingState {}
class UpdateOrderSuccessfullyState extends BookingState {}

class RefuesdOrderSuccessfullyState extends BookingState {}

class AssignOrderSuccessfullyState extends BookingState {}





//form request to companies

class UpdateBookingRequestFormInitialState extends BookingState {
  const UpdateBookingRequestFormInitialState();
}


class UpdateBookingRequestFormSuccessfullyState extends BookingState {
  const UpdateBookingRequestFormSuccessfullyState();
}




class SendBookingRequestFormSuccessfullyState extends BookingState {
  const SendBookingRequestFormSuccessfullyState();
}


class SendBookingRequestLoadingState extends BookingState {
  const SendBookingRequestLoadingState();
}


class SendBookingRequestFialedState extends BookingState {
  final String msg;
  const SendBookingRequestFialedState({required this.msg});
}