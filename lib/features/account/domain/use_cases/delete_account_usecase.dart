import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';

class DeleteAccountUseCase {
  final UserServiceRepository repository;

  DeleteAccountUseCase({required this.repository});

  Future<Either<Failure, String>> call(String userId) async {
    return await repository.deleteAccount(userId);
  }
}
