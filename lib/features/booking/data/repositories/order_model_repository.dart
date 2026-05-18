import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/features/booking/data/data_sources/order_remote_data_source.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:icare/features/booking/data/models/order_response.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/domain/repositories/oder_repository.dart';

class OrderModelRepository implements OrderRepository {
  final OrderRemoteDataSourceImpl orderRemoteDataSource;
  final NetworkInfo networkInfo;
  OrderModelRepository(
      {required this.orderRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Booking>>> getAllOrders({String? userId}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await orderRemoteDataSource.getAllOrder(userId: userId));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getOngoingBookings() async {
    if (await networkInfo.isConnected()) {
      try {
        // Get all orders first
        final allOrders = await orderRemoteDataSource.getAllOrder();

        // Filter to only include PENDING and ONGOING bookings
        final ongoingBookings = allOrders.where((booking) {
          final status =
              OrderModel.getStatusViewCheck(booking.status.toString());
          return status == ORDER_STATUS.PENDING ||
              status == ORDER_STATUS.ONGOING;
        }).toList();

        return Right(ongoingBookings);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, OrderResponse>> addOrder(
      {required Map<String, dynamic> data}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await orderRemoteDataSource.addOrder(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, OrderResponse>> updateOrder(
      {required Map<String, dynamic> data, File? fileR}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(
            await orderRemoteDataSource.updateOrder(data: data, fileR: fileR));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> cancelOrder({required int orderID}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await orderRemoteDataSource.cancelOrder(orderId: orderID));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  /// send request
  @override
  Future<Either<Failure, OrderResponse>> sendRequest(
      {required Map<String, dynamic> data}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await orderRemoteDataSource.sendRequest(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
