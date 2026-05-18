import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/domain/repositories/oder_repository.dart';

class GetAllOrderUseCase {
  final OrderRepository orderRepository;

  const GetAllOrderUseCase({required this.orderRepository});

  Future<Either<Failure, List<Booking>>> call({String? userId}) async {
    return await orderRepository.getAllOrders(userId: userId);
  }
}
