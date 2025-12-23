import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/utils/map_utils/progressive_radius_loader.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';
import 'package:icare/core/utils/map_utils/searchable_marker_manager.dart';

/// 🎯 Searchable Entity Progressive Loader
/// Uses generic ProgressiveRadiusLoader with SearchableEntity-specific logic
/// Supports both doctors and nurses
class SearchableProgressiveLoader {
  final SearchableMarkerManager markerManager;
  final ProgressiveRadiusLoader<SearchableEntity> _genericLoader =
      ProgressiveRadiusLoader<SearchableEntity>();

  SearchableProgressiveLoader({required this.markerManager});

  bool get isLoading => _genericLoader.isLoading;

  /// 🔄 Load searchable entities progressively by radius
  Future<void> loadProgressively({
    required List<SearchableEntity> entities,
    required Function(MarkerId, SearchableEntity) onMarkerTap,
    required Function() onUpdate,
  }) async {
    // Determine entity type for logging (use first entity's type or default to "providers")
    final entityType =
        entities.isNotEmpty ? "${entities.first.providerType}s" : "providers";

    await _genericLoader.loadProgressively(
      entities: entities,
      getDistance: (entity) => entity.distanceKM,
      isValidEntity: (entity) => markerManager.isValidEntity(entity),
      createItem: (entity) async {
        await markerManager.createSearchableMarker(
          entity: entity,
          onTap: () => onMarkerTap(
            MarkerId("${entity.providerType}-${entity.id}"),
            entity,
          ),
        );
      },
      onUpdate: onUpdate,
      entityType: entityType,
    );
  }
}
