import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/utils/map_utils/progressive_radius_loader.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/core/utils/map_utils/nurse_marker_manager.dart';

/// 🎯 Nurse-Specific Progressive Loader
/// Uses generic ProgressiveRadiusLoader with NurseEntity-specific logic
class NurseProgressiveLoader {
  final NurseMarkerManager markerManager;
  final ProgressiveRadiusLoader<NurseEntity> _genericLoader =
      ProgressiveRadiusLoader<NurseEntity>();

  NurseProgressiveLoader({required this.markerManager});

  bool get isLoading => _genericLoader.isLoading;

  /// 🔄 Load nurses progressively by radius
  Future<void> loadProgressively({
    required List<NurseEntity> nurses,
    required Function(MarkerId, NurseEntity) onMarkerTap,
    required Function() onUpdate,
  }) async {
    await _genericLoader.loadProgressively(
      entities: nurses,
      getDistance: (nurse) => nurse.distanceKM,
      isValidEntity: (nurse) => markerManager.isValidNurse(nurse),
      createItem: (nurse) async {
        await markerManager.createNurseMarker(
          nurse: nurse,
          onTap: () => onMarkerTap(MarkerId("nurse-${nurse.id}"), nurse),
        );
      },
      onUpdate: onUpdate,
      entityType: "nurses",
    );
  }
}
