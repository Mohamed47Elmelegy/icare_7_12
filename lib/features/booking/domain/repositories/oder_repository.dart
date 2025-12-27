import 'dart:io';

import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/booking/data/models/order_response.dart';
import 'package:icare/features/booking/domain/entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Booking>>> getAllOrders();

  /// Get all ongoing bookings (PENDING or ONGOING status) for current user
  Future<Either<Failure, List<Booking>>> getOngoingBookings();

  Future<Either<Failure, OrderResponse>> addOrder(
      {required Map<String, dynamic> data});
  Future<Either<Failure, OrderResponse>> updateOrder(
      {required Map<String, dynamic> data, File? fileR});
  Future<Either<Failure, bool>> cancelOrder({required int orderID});

  Future<Either<Failure, OrderResponse>> sendRequest(
      {required Map<String, dynamic> data});
}
