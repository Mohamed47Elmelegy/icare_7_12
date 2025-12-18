import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/core/strings/enum/payment_enum.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/categories/data/models/services.dart';

@immutable
abstract class BookingEvent {
  const BookingEvent();
}

class FetchAllOrderEvent extends BookingEvent {
  const FetchAllOrderEvent();
}

class UpdateBookingServiceListEvent extends BookingEvent {
  final ServicesModel service;
  const UpdateBookingServiceListEvent({
    required this.service,
  });
}

class AddOrderEvent extends BookingEvent {
  final Map<String, dynamic> orderData;
  final BuildContext context;
  final PaymentOption payment;
  const AddOrderEvent(
      {required this.context, required this.payment, required this.orderData});
}

class PaymentOption {
  final PaymentEnum paymentEnum;
  final bool? isApplePay;
  const PaymentOption({required this.paymentEnum, this.isApplePay});
}

class SetCurrentOrderEvent extends BookingEvent {
  final Booking? order;
  const SetCurrentOrderEvent({required this.order});
}

class CancelOrderEvent extends BookingEvent {
  final int id;
  const CancelOrderEvent({required this.id});
}

class ChangeCurrentOrdersEvent extends BookingEvent {
  final ORDER_STATUS type;
  final int index;
  final bool updateState;
  const ChangeCurrentOrdersEvent(
      {required this.type, required this.index, this.updateState = false});
}

class UpdateOrderEvent extends BookingEvent {
  final Map<String, dynamic> data;
  const UpdateOrderEvent({
    required this.data,
  });
}

class FilterOrderByDate extends BookingEvent {
  final DateTime? dateTime;
  const FilterOrderByDate({
    required this.dateTime,
  });
}

class CollectNewBookingDataOrder extends BookingEvent {
  final Map<String, dynamic> bookingData;
  const CollectNewBookingDataOrder({required this.bookingData});
}

class UpdateRequestFormDataEvent extends BookingEvent {
  final Map<String, String> data;
  const UpdateRequestFormDataEvent({required this.data});
}

class SendRequestDataEvent extends BookingEvent {
  const SendRequestDataEvent();
}
