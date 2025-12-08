import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/categories/data/models/publications_model.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:icare/features/categories/domain/entities/slider_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoriesEntity>>> getAllCategories();
  Future<Either<Failure, List<AllergiesModel>>> getAllAllergies();
  Future<Either<Failure, List<PublicationsModel>>> getAllPublications();
  Future<Either<Failure, List<SliderEntity>>> getAllSliders();
}
