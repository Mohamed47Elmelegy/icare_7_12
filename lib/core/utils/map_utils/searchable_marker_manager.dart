import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/map_utils/generic_marker_manager.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';

/// 📍 Searchable Entity Marker Manager
/// Extends GenericMarkerManager for SearchableEntity (supports both doctors and nurses)
class SearchableMarkerManager extends GenericMarkerManager<SearchableEntity> {
  /// 🎨 Create marker for any SearchableEntity (Doctor or Nurse)
  Future<Marker?> createSearchableMarker({
    required SearchableEntity entity,
    required VoidCallback onTap,
  }) async {
    try {
      final entityName = entity.userData?.userName ?? "Unknown";
      final imageUrl = entity.userData?.image.toString() ?? "";
      final point = LatLng(entity.userData!.lat!, entity.userData!.long!);

      final marker = await createMarker(
        entity: entity,
        markerId: "${entity.providerType}-${entity.id}",
        position: point,
        imageUrl: imageUrl,
        entityName: entityName,
        infoWindow: InfoWindow(
          title:
              "$entityName ${ReviewModel.calcReviewStar(entity.reviewList!)}",
          snippet:
              LocationUtil.getDistanceView(entity.distanceKM, entity.distanceM),
          onTap: onTap,
        ),
      );

      if (marker != null) {
        addMarker(marker, entity);
      }

      return marker;
    } catch (e) {
      debugPrint("   ❌ Error creating ${entity.providerType} marker: $e");
      return null;
    }
  }

  /// 🔄 Update markers from entity list
  Future<void> updateSearchableMarkers({
    required List<SearchableEntity> entities,
    required Function(MarkerId, SearchableEntity) onMarkerTap,
  }) async {
    for (final entity in entities) {
      await createSearchableMarker(
        entity: entity,
        onTap: () => onMarkerTap(
          MarkerId("${entity.providerType}-${entity.id}"),
          entity,
        ),
      );
    }
  }

  /// 🔍 Filter markers by services
  Map<MarkerId, Marker> filterByServices(Set<int> serviceIds) {
    if (serviceIds.isEmpty) return markers;

    return filterMarkers((entity) {
      if (entity.servicesList == null) return false;
      return entity.servicesList!
          .any((service) => serviceIds.contains(service.id));
    });
  }

  /// ✅ Validate entity data
  bool isValidEntity(SearchableEntity entity) {
    return entity.userData != null &&
        entity.userData!.lat != null &&
        entity.userData!.long != null &&
        entity.userData!.lat != 0.0 &&
        entity.userData!.long != 0.0;
  }
}
