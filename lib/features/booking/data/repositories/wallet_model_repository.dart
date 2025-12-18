import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/booking/data/data_sources/wallet_remote_data_source.dart';
import 'package:icare/features/booking/domain/entities/transaction.dart';
import 'package:icare/features/booking/domain/repositories/wallet_repository.dart';

class WalletModelRepository extends WalletRepository {
  final NetworkInfo networkInfo;
  final WalletRemoteDataSourceImpl walletRemoteDataSourceImpl;
  WalletModelRepository(
      {required this.walletRemoteDataSourceImpl, required this.networkInfo});

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await walletRemoteDataSourceImpl.getAllTransactions());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
