import 'package:equatable/equatable.dart';

class PublicationsEntity extends Equatable{
  final int id;
  final String title;
  final String imgUrl;
  final String videoUrl;

  const PublicationsEntity({required this.id,required this.title,required this.imgUrl,required this.videoUrl});


  @override
  List<Object?> get props => [id];

}