
import 'package:flutter/material.dart';

@immutable
abstract class NurseState{
  const NurseState();
}



class NurseInitialState extends NurseState {}


class FetchAllNursesSuccessfullyState extends NurseState{}

class FetchAllNursesLoadingState extends NurseState{}

class FetchAllNursesFailedState extends NurseState{}

class RateDataLoadingState extends NurseState{}

class UpdateRateDataState extends NurseState{}

class AddNurseRateSuccessfullyState extends NurseState{}