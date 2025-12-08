import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/booking/data/models/order_response.dart';
import 'package:icare/features/booking/domain/repositories/oder_repository.dart';

class UpdateOrderUseCase {
  final OrderRepository orderRepository;

  const UpdateOrderUseCase({required this.orderRepository});

  Future<Either<Failure, OrderResponse>> call({required Map<String,dynamic> data,File? fileR}) async {
    return await orderRepository.updateOrder(data: data,fileR: fileR);
  }
}
