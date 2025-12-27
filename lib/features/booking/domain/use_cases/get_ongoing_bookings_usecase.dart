import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/domain/repositories/oder_repository.dart';

/// Use case to get all ongoing bookings for the current user
/// Ongoing bookings are those with status PENDING or ONGOING
class GetOngoingBookingsUseCase {
  final OrderRepository orderRepository;

  const GetOngoingBookingsUseCase({required this.orderRepository});

  Future<Either<Failure, List<Booking>>> call() async {
    return await orderRepository.getOngoingBookings();
  }
}
