import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/booking/domain/entities/transaction.dart';
import 'package:icare/features/booking/domain/repositories/wallet_repository.dart';

class GetAllTransactionsUseCase {
  final WalletRepository walletRepository;
  GetAllTransactionsUseCase({required this.walletRepository});

  Future<Either<Failure, List<TransactionEntity>>> call() async {
    return await walletRepository.getAllTransactions();
  }
}
