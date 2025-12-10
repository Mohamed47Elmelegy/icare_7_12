import 'package:icare/features/search/domain/entities/search_filter_entity.dart';

class SearchFilterModel extends SearchFilterEntity {
  const SearchFilterModel({
    super.userType,
    super.serviceIds,
    super.latitude,
    super.longitude,
    super.searchText,
  });

  factory SearchFilterModel.fromEntity(SearchFilterEntity entity) {
    return SearchFilterModel(
      userType: entity.userType,
      serviceIds: entity.serviceIds,
      latitude: entity.latitude,
      longitude: entity.longitude,
      searchText: entity.searchText,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (userType != null && userType!.isNotEmpty) {
      data['user_type'] = userType;
    }

    if (serviceIds != null && serviceIds!.isNotEmpty) {
      data['service_ids'] = serviceIds;
    }

    if (latitude != null) {
      data['lat'] = latitude;
    }

    if (longitude != null) {
      data['long'] = longitude;
    }

    if (searchText != null && searchText!.isNotEmpty) {
      data['search'] = searchText;
    }

    return data;
  }

  factory SearchFilterModel.fromJson(Map<String, dynamic> json) {
    return SearchFilterModel(
      userType: json['user_type'] as String?,
      serviceIds: json['service_ids'] != null
          ? List<int>.from(json['service_ids'])
          : null,
      latitude: json['lat'] as double?,
      longitude: json['long'] as double?,
      searchText: json['search'] as String?,
    );
  }
}
