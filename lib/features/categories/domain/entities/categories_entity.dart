import 'package:equatable/equatable.dart';

class CategoriesEntity extends Equatable{
  final int id;
  final String slug;
  final String iconPath;
  final String? darkIcon;
  final String? lightIcon;
  final String imgPath;
  final String title;
  final String desc;
  final bool isArabic;
  final String parentID;
  final int productsCount;
  final bool? enableHomeScreen;



  const CategoriesEntity({required this.title,required this.desc,
    required this.id,
    required this.slug,
    required this.imgPath,
    required this.iconPath,
    this.darkIcon,
    this.lightIcon,
    this.enableHomeScreen,
    required this.isArabic,required this.parentID,required this.productsCount});

  @override
  List<Object?> get props => [id,title];


}