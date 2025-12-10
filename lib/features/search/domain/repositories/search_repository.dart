import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/search/domain/entities/search_filter_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<NurseEntity>>> searchByFilters({
    required SearchFilterEntity filters,
  });
}
