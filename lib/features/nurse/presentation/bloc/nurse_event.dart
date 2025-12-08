import 'package:flutter/material.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';


@immutable
abstract class NurseEvent{
  const NurseEvent();
}


class FetchAllNurseEvent extends NurseEvent{
  final int page;
  const FetchAllNurseEvent({this.page=1});
}


class UpdateCurrentNurseEvent extends NurseEvent{
  final NurseEntity nurse;
  const UpdateCurrentNurseEvent({required this.nurse});
}


class RateNurseEvent extends NurseEvent{
  final Map<String,dynamic> data;
  const RateNurseEvent({required this.data});
}



class UpdateRateDataEvent extends NurseEvent{
  final double? rateValue;
  final String? rateTxt;
  const UpdateRateDataEvent({ this.rateValue,this.rateTxt});
}



// class AddNewNearbyNurseEvent extends NurseEvent{
//   final String? distance;
//   final NurseEntity? nurse;
//   const AddNewNearbyNurseEvent({required this.nurse,required this.distance});
// }


class ShowNearbyNursesEvent extends NurseEvent{
  const ShowNearbyNursesEvent();
}

class ShowAllNursesEvent extends NurseEvent{
  const ShowAllNursesEvent();
}


class SetNurseOnMapEvent extends NurseEvent{
  final BuildContext ctx;
  final bool showAllNurses;
  const SetNurseOnMapEvent({required this.ctx,this.showAllNurses = false});
}



class UpdateSearchTxtEvent extends NurseEvent{
  final String txt;
  const UpdateSearchTxtEvent({required this.txt});
}

