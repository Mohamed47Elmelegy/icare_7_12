import 'package:equatable/equatable.dart';

class SearchFilterEntity extends Equatable {
  final String? userType; // 'nurse', 'assistant', 'doctor'
  final List<int>? serviceIds;
  final double? latitude;
  final double? longitude;
  final String? searchText;

  const SearchFilterEntity({
    this.userType,
    this.serviceIds,
    this.latitude,
    this.longitude,
    this.searchText,
  });

  SearchFilterEntity copyWith({
    String? userType,
    List<int>? serviceIds,
    double? latitude,
    double? longitude,
    String? searchText,
  }) {
    return SearchFilterEntity(
      userType: userType ?? this.userType,
      serviceIds: serviceIds ?? this.serviceIds,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props =>
      [userType, serviceIds, latitude, longitude, searchText];
}
