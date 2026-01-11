import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/setting/data/data_sources/settings_remote_data_source.dart';
import 'package:icare/features/setting/domain/entities/about_us.dart';
import 'package:icare/features/setting/domain/entities/city_entity.dart';
import 'package:icare/features/setting/domain/entities/governorate_entity.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/setting/domain/entities/privacy.dart';
import 'package:icare/features/setting/domain/entities/refund_policy.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';
import 'package:icare/features/setting/domain/entities/terms.dart';
import 'package:icare/features/setting/domain/repositories/settings_repository.dart';
import 'package:icare/features/setting/data/models/specialty_model.dart';
import 'package:icare/features/setting/data/models/city_model.dart';

class SettingsModelRepository extends SettingsRepository {
  final NetworkInfo networkInfo;
  final SettingsRemoteDataSourceImpl settingsRemoteDataSourceImpl;
  SettingsModelRepository(
      {required this.settingsRemoteDataSourceImpl, required this.networkInfo});

  @override
  Future<Either<Failure, List<AboutUs>>> getAboutUsData() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<NotificationsEntity>>>
      getAllNotifications() async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await settingsRemoteDataSourceImpl.getAllNotifications());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Privacy>>> getPrivacyData() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<RefundPolicy>>> getRefundPolicyData() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Terms>>> getTermsData() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SpecialtyEntity>>> getSpecialties() async {
    if (await networkInfo.isConnected()) {
      try {
        final specialties =
            await SettingsRemoteDataSource.fetchAllSpecialties();
        // Map Models to Entities
        final entities = specialties.map((model) => model.toEntity()).toList();
        return Right(entities);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async {
    if (await networkInfo.isConnected()) {
      try {
        final governorates =
            await SettingsRemoteDataSource.fetchAllGovernorates();
        // Map Models to Entities
        final entities =
            governorates.map((model) => model.toGovernorateEntity()).toList();
        return Right(entities);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> getCities() async {
    if (await networkInfo.isConnected()) {
      try {
        final cities = await SettingsRemoteDataSource.fetchAllCities();
        // Map Models to Entities
        final entities = cities.map((model) => model.toCityEntity()).toList();
        return Right(entities);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
