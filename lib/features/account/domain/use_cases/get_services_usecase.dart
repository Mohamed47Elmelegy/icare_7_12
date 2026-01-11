import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';

class GetServicesUseCase {
  final UserServiceRepository repository;

  GetServicesUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<ServicesModel>>> call({
    String? userType,
  }) async {
    return await repository.getServices(userType: userType);
  }
}
