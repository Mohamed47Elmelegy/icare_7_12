import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/booking/domain/entities/transaction.dart';

abstract class WalletRepository{
  Future<Either<Failure,List<TransactionEntity>>> getAllTransactions();
}