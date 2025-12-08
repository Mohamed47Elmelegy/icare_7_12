import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/booking/data/data_sources/order_remote_data_source.dart';
import 'package:icare/features/booking/data/models/order_response.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/domain/repositories/oder_repository.dart';

class OrderModelRepository implements OrderRepository {
  final OrderRemoteDataSourceImpl orderRemoteDataSource;
  final NetworkInfo networkInfo;
  OrderModelRepository({required this.orderRemoteDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, List<Booking>>> getAllOrders() async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await orderRemoteDataSource.getAllOrder());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }


  @override
  Future<Either<Failure, OrderResponse>> addOrder({required Map<String,dynamic> data}) async{
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
  Future<Either<Failure, OrderResponse>> updateOrder({required Map<String,dynamic> data,File? fileR}) async{
    if (await networkInfo.isConnected()) {
      try {
        return Right(await orderRemoteDataSource.updateOrder(data: data,fileR: fileR));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> cancelOrder({required int orderID}) async{
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
  Future<Either<Failure, OrderResponse>> sendRequest({required Map<String,dynamic> data}) async{
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
