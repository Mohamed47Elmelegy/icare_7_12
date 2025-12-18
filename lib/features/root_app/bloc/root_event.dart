import 'package:flutter/material.dart';
import 'package:icare/features/setting/data/models/city_model.dart';

@immutable
abstract class RootEvent {
  const RootEvent();
}

class ChangeIndex extends RootEvent {
  final int index;
  final String title;
  const ChangeIndex({required this.index, required this.title});
}

class ChangeCurrentCurrency extends RootEvent {
  final String val;
  const ChangeCurrentCurrency({required this.val});
}

class ShowDrawerMenuEvent extends RootEvent {
  const ShowDrawerMenuEvent();
}

class FetchSettingEvent extends RootEvent {
  const FetchSettingEvent();
}

class SearchEvent extends RootEvent {
  final String word;
  const SearchEvent({required this.word});
}

class ChooseCurrentAreaEvent extends RootEvent {
  final CityModel? area;
  const ChooseCurrentAreaEvent({required this.area});
}
