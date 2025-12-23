import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/categories/data/data_sources/category_remote_data_source.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/categories/data/models/publications_model.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:icare/features/categories/domain/entities/slider_entity.dart';
import 'package:icare/features/categories/domain/repositories/category_repository.dart';

class CategoryModelRepository implements CategoryRepository {
  final CategoryRemoteDataSourceImpl categoryRemoteDataSource;
  final NetworkInfo networkInfo;
  CategoryModelRepository(
      {required this.categoryRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<CategoriesEntity>>> getAllCategories() async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await categoryRemoteDataSource.getAllCategory());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<AllergiesModel>>> getAllAllergies() async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await categoryRemoteDataSource.getAllAllergies());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPatientAllergies(
      String userId) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(
            await categoryRemoteDataSource.getPatientAllergies(userId));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<SliderEntity>>> getAllSliders() async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await categoryRemoteDataSource.getAllSliders());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<PublicationsModel>>> getAllPublications() async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await categoryRemoteDataSource.getAllPublications());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
