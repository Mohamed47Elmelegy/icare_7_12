import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/booking/domain/repositories/oder_repository.dart';

class CancelOrderUseCase {
  final OrderRepository orderRepository;

  const CancelOrderUseCase({required this.orderRepository});

  Future<Either<Failure, bool>> call({required int orderId}) async {
     return await orderRepository.cancelOrder(orderID: orderId);
  }
}
