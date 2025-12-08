import 'package:equatable/equatable.dart';

class SliderEntity extends Equatable{
  final int id;
  final String title;
  final String img;
  final String kind;
  final String type;
  final String typeID;
  const SliderEntity({required this.title,
    required this.img,
    required this.kind,
    required this.type,
    required this.typeID,
    required this.id});

  @override
  List<Object?> get props => [id];
}