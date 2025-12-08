import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/booking/data/models/order_response.dart';
import 'package:icare/features/booking/domain/repositories/oder_repository.dart';

class AddOrderUseCase {
  final OrderRepository orderRepository;

  const AddOrderUseCase({required this.orderRepository});

  Future<Either<Failure, OrderResponse>> call({required Map<String,dynamic> data}) async {
    return await orderRepository.addOrder(data: data);
  }
}
