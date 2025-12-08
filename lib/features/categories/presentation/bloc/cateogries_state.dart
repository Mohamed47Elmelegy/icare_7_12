
import 'package:flutter/material.dart';

@immutable
abstract class CategoriesState{
  const CategoriesState();
}



class CategoriesInitialState extends CategoriesState {}

class CategoriesIndexChangedSuccessState extends CategoriesState{}

class ChangeCurrentBrandSuccessState extends CategoriesState{}

class FetchCategoriesLoadingState extends CategoriesState{
  const FetchCategoriesLoadingState();
}

class FetchCategoriesSuccessfullyState extends CategoriesState{
  const FetchCategoriesSuccessfullyState();
}

class FetchCategoriesFailedState extends CategoriesState{
  const FetchCategoriesFailedState();
}

class FetchSliderSuccessfullyState extends CategoriesState{}

class FetchSliderLoadingState extends CategoriesState{}

class FetchSliderFailedState extends CategoriesState{}


class FetchPublicationsSuccessfullyState extends CategoriesState{}

class FetchPublicationsLoadingState extends CategoriesState{}

class FetchPublicationsFailedState extends CategoriesState{}