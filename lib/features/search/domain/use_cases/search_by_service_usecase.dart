import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/search/domain/entities/search_filter_entity.dart';
import 'package:icare/features/search/domain/repositories/search_repository.dart';

class SearchByServiceUseCase {
  final SearchRepository searchRepository;

  SearchByServiceUseCase({required this.searchRepository});

  Future<Either<Failure, List<NurseEntity>>> call({
    required SearchFilterEntity filters,
  }) async {
    return await searchRepository.searchByFilters(filters: filters);
  }
}
