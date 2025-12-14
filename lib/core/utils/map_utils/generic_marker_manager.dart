import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/utils/map_utils/marker_image_cache.dart';

/// 📍 Generic Marker Manager
/// Handles marker creation, updates, and filtering for any entity type
/// Can be extended for different entity types (Nurse, Doctor, Location, etc.)
class GenericMarkerManager<T> {
  final MarkerImageCache imageCache = MarkerImageCache();
  final Map<MarkerId, Marker> _markers = {};
  final Map<MarkerId, T> _markerEntityMap = {};

  Map<MarkerId, Marker> get markers => _markers;
  Map<MarkerId, T> get markerEntityMap => _markerEntityMap;

  /// 🎨 Create single marker with custom image
  Future<Marker?> createMarker({
    required T entity,
    required String markerId,
    required LatLng position,
    required String imageUrl,
    required InfoWindow infoWindow,
    String? entityName,
  }) async {
    try {
      // Load image (cached or new)
      final markerIcon = await imageCache.loadAndCache(
        imageUrl,
        entityName: entityName,
      );
      if (markerIcon == null) return null;

      // Create marker with custom icon
      final marker = Marker(
        markerId: MarkerId(markerId),
        position: position,
        icon: markerIcon,
        infoWindow: infoWindow,
      );

      return marker;
    } catch (e) {
      debugPrint("   ❌ Error creating marker: $e");
      return null;
    }
  }

  /// ➕ Add marker to map
  void addMarker(Marker marker, T entity) {
    _markers[marker.markerId] = marker;
    _markerEntityMap[marker.markerId] = entity;
  }

  /// 🔍 Filter markers by custom predicate
  Map<MarkerId, Marker> filterMarkers(bool Function(T entity) predicate) {
    return Map.fromEntries(
      _markers.entries.where((entry) {
        final entity = _markerEntityMap[entry.key];
        return entity != null && predicate(entity);
      }),
    );
  }

  /// 🗑️ Clear all markers
  void clearMarkers() {
    _markers.clear();
    _markerEntityMap.clear();
  }

  /// 📊 Get statistics
  Map<String, dynamic> getStats() {
    return {
      'totalMarkers': _markers.length,
      'cachedImages': imageCache.cacheSize,
    };
  }
}
