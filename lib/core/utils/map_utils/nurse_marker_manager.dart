import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/map_utils/generic_marker_manager.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';

/// 📍 Nurse-Specific Marker Manager
/// Extends GenericMarkerManager for NurseEntity-specific operations
class NurseMarkerManager extends GenericMarkerManager<NurseEntity> {
  /// 🎨 Create marker specifically for NurseEntity
  Future<Marker?> createNurseMarker({
    required NurseEntity nurse,
    required VoidCallback onTap,
  }) async {
    try {
      final nurseName = nurse.userData?.userName ?? "Unknown";
      final imageUrl = nurse.userData?.image.toString() ?? "";
      final point = LatLng(nurse.userData!.lat!, nurse.userData!.long!);

      final marker = await createMarker(
        entity: nurse,
        markerId: "nurse-${nurse.id}",
        position: point,
        imageUrl: imageUrl,
        entityName: nurseName,
        infoWindow: InfoWindow(
          title: "$nurseName ${ReviewModel.calcReviewStar(nurse.reviewList!)}",
          snippet:
              LocationUtil.getDistanceView(nurse.distanceKM, nurse.distanceM),
          onTap: onTap,
        ),
      );

      if (marker != null) {
        addMarker(marker, nurse);
      }

      return marker;
    } catch (e) {
      debugPrint("   ❌ Error creating nurse marker: $e");
      return null;
    }
  }

  /// 🔄 Update markers from nurse list
  Future<void> updateNurseMarkers({
    required List<NurseEntity> nurses,
    required Function(MarkerId, NurseEntity) onMarkerTap,
  }) async {
    for (final nurse in nurses) {
      await createNurseMarker(
        nurse: nurse,
        onTap: () => onMarkerTap(MarkerId("nurse-${nurse.id}"), nurse),
      );
    }
  }

  /// 🔍 Filter markers by services
  Map<MarkerId, Marker> filterByServices(Set<int> serviceIds) {
    if (serviceIds.isEmpty) return markers;

    return filterMarkers((nurse) {
      if (nurse.servicesList == null) return false;
      return nurse.servicesList!
          .any((service) => serviceIds.contains(service.id));
    });
  }

  /// ✅ Validate nurse data
  bool isValidNurse(NurseEntity nurse) {
    return nurse.userData != null &&
        nurse.userData!.lat != null &&
        nurse.userData!.long != null &&
        nurse.userData!.lat != 0.0 &&
        nurse.userData!.long != 0.0;
  }
}
