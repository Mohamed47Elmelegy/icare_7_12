import 'package:icare/core/error/failure.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/categories/data/models/publications_model.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:icare/features/categories/domain/entities/slider_entity.dart';
import 'package:icare/features/categories/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCategoryUseCase {
  final CategoryRepository categoryRepository;

  GetAllCategoryUseCase({required this.categoryRepository});

  Future<Either<Failure, List<CategoriesEntity>>> call() async {
    return await categoryRepository.getAllCategories();
  }
}

class GetAllAllergiesUseCase {
  final CategoryRepository categoryRepository;

  GetAllAllergiesUseCase({required this.categoryRepository});

  Future<Either<Failure, List<AllergiesModel>>> call() async {
    return await categoryRepository.getAllAllergies();
  }
}

class GetPatientAllergiesUseCase {
  final CategoryRepository categoryRepository;

  GetPatientAllergiesUseCase({required this.categoryRepository});

  Future<Either<Failure, List<String>>> call(String userId) async {
    return await categoryRepository.getPatientAllergies(userId);
  }
}

class GetAllPublicationsUseCase {
  final CategoryRepository categoryRepository;

  GetAllPublicationsUseCase({required this.categoryRepository});

  Future<Either<Failure, List<PublicationsModel>>> call() async {
    return await categoryRepository.getAllPublications();
  }
}

class GetAllSlidersUseCase {
  final CategoryRepository categoryRepository;

  GetAllSlidersUseCase({required this.categoryRepository});

  Future<Either<Failure, List<SliderEntity>>> call() async {
    return await categoryRepository.getAllSliders();
  }
}
