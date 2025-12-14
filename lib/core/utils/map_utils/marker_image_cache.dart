import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/utils/location/location_util.dart';

/// 🖼️ Marker Image Cache Manager
/// Manages caching and loading of custom marker images
/// Generic utility - can be used across the app for any map markers
class MarkerImageCache {
  final Map<String, BitmapDescriptor> _cache = {};

  /// Check if image is cached
  bool isCached(String imageUrl) => _cache.containsKey(imageUrl);

  /// Get cached image
  BitmapDescriptor? getCached(String imageUrl) => _cache[imageUrl];

  /// Load and cache image
  Future<BitmapDescriptor?> loadAndCache(
    String imageUrl, {
    String? entityName,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    // Check cache first
    if (_cache.containsKey(imageUrl)) {
      if (entityName != null) {
        debugPrint("               💾 Using cached image for $entityName");
      }
      return _cache[imageUrl];
    }

    try {
      if (entityName != null) {
        debugPrint("            🖼️ Loading image for: $entityName");
        debugPrint("               URL: $imageUrl");
      }

      final markerIcon =
          await LocationUtil.convertImageFileToCustomBitmapDescriptor(
        imageUrl,
      ).timeout(
        timeout,
        onTimeout: () {
          if (entityName != null) {
            debugPrint(
                "               ⏱️ Timeout (${timeout.inSeconds}s) loading image for $entityName");
          }
          throw TimeoutException('Image load timeout');
        },
      );

      // Cache the loaded image
      _cache[imageUrl] = markerIcon;
      if (entityName != null) {
        debugPrint("               ✅ Image loaded & cached for $entityName");
      }
      return markerIcon;
    } catch (e) {
      if (entityName != null) {
        debugPrint("               ❌ Failed to load image for $entityName: $e");
      }
      return null;
    }
  }

  /// Clear cache
  void clearCache() {
    _cache.clear();
    debugPrint("🗑️ Marker image cache cleared");
  }

  /// Get cache size
  int get cacheSize => _cache.length;
}
