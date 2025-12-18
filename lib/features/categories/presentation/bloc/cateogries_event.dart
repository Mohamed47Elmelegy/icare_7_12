import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

@immutable
abstract class CategoriesEvent {
  const CategoriesEvent();
}

class ChangeCategoriesEvent extends CategoriesEvent {
  final CategoriesEntity categoriesModel;
  const ChangeCategoriesEvent({required this.categoriesModel});
}

class ChangeSubCategoriesEvent extends CategoriesEvent {
  final CategoriesEntity categoriesModel;
  const ChangeSubCategoriesEvent({required this.categoriesModel});
}

class ChangeCurrentAllergies extends CategoriesEvent {
  final AllergiesModel item;
  const ChangeCurrentAllergies({required this.item});
}

class ChangeBrandIndexEvent extends CategoriesEvent {
  final int index;
  const ChangeBrandIndexEvent({required this.index});
}

class FetchAllAllergiesEvent extends CategoriesEvent {
  const FetchAllAllergiesEvent();
}

class SetProductsToCategoryEvent extends CategoriesEvent {
  final List list;
  final int catID;
  const SetProductsToCategoryEvent({required this.list, required this.catID});
}

class FetchMainSlidersEvent extends CategoriesEvent {
  const FetchMainSlidersEvent();
}

class ChangeSliderIndexEvent extends CategoriesEvent {
  final int val;
  const ChangeSliderIndexEvent({required this.val});
}

class FetchAllPublicationsEvent extends CategoriesEvent {
  const FetchAllPublicationsEvent();
}

class UpdateVideoControllerEvent extends CategoriesEvent {
  final YoutubePlayerController videoPlayerController;
  const UpdateVideoControllerEvent({required this.videoPlayerController});
}
