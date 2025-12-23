import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/search/domain/entities/search_filter_entity.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchableEntity>>> searchByFilters({
    required SearchFilterEntity filters,
  });
}
