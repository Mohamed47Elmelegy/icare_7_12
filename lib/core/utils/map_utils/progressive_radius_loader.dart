import 'dart:async';
import 'package:flutter/material.dart';

/// 🎯 Generic Progressive Radius Loader
/// Loads entities progressively by distance radius bands
/// Generic utility - can be used for any entity type with distance data
class ProgressiveRadiusLoader<T> {
  final List<double> radiusBands = [5.0, 10.0, 15.0, 30.0, double.infinity];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// 🔄 Load entities progressively by radius
  Future<void> loadProgressively({
    required List<T> entities,
    required double? Function(T entity) getDistance,
    required bool Function(T entity) isValidEntity,
    required Future<void> Function(T entity) createItem,
    required Function() onUpdate,
    String entityType = "items",
  }) async {
    if (_isLoading) {
      debugPrint("⚠️ Progressive loading already in progress");
      return;
    }

    _isLoading = true;
    debugPrint(
        "🗺️ Starting Progressive Radius Loading for ${entities.length} $entityType...");
    final stopwatch = Stopwatch()..start();

    // Filter and validate entities
    final validEntities =
        entities.where((entity) => isValidEntity(entity)).toList();

    debugPrint("   └─ ${validEntities.length} valid $entityType found");

    if (validEntities.isEmpty) {
      debugPrint("   ⚠️ No $entityType with valid location data!");
      _isLoading = false;
      return;
    }

    // Sort by distance (nearest first)
    _sortEntitiesByDistance(validEntities, getDistance);

    int totalLoaded = 0;

    // Load by radius bands
    for (int bandIndex = 0; bandIndex < radiusBands.length; bandIndex++) {
      final maxRadius = radiusBands[bandIndex];
      final minRadius = bandIndex > 0 ? radiusBands[bandIndex - 1] : 0.0;

      final entitiesInBand =
          _getEntitiesInBand(validEntities, getDistance, minRadius, maxRadius);

      if (entitiesInBand.isEmpty) continue;

      debugPrint(
          "📍 Radius ${minRadius}km → ${maxRadius == double.infinity ? '∞' : '${maxRadius}km'}: ${entitiesInBand.length} $entityType");

      // Load this batch
      await _loadBatch(
        entities: entitiesInBand,
        bandIndex: bandIndex,
        createItem: createItem,
        onUpdate: onUpdate,
        entityType: entityType,
      );

      totalLoaded += entitiesInBand.length;

      // Small delay between batches for smooth UI
      if (bandIndex < radiusBands.length - 1 && entitiesInBand.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    stopwatch.stop();
    debugPrint(
        "✅ Progressive loading completed in ${stopwatch.elapsedMilliseconds}ms");
    debugPrint("   └─ Total $entityType loaded: $totalLoaded");

    _isLoading = false;
  }

  /// 🔄 Load single batch
  Future<void> _loadBatch({
    required List<T> entities,
    required int bandIndex,
    required Future<void> Function(T entity) createItem,
    required Function() onUpdate,
    required String entityType,
  }) async {
    final batchStopwatch = Stopwatch()..start();
    debugPrint("      📦 Loading batch with ${entities.length} $entityType...");

    const int parallelBatchSize = 5;
    int successCount = 0;
    int failedCount = 0;

    for (int i = 0; i < entities.length; i += parallelBatchSize) {
      final end = (i + parallelBatchSize < entities.length)
          ? i + parallelBatchSize
          : entities.length;
      final batch = entities.sublist(i, end);

      debugPrint("         Loading ${batch.length} $entityType...");

      // Load items in parallel
      final futures = batch.map((entity) => createItem(entity));
      final results = await Future.wait(
        futures.map((f) => f.then((_) => true).catchError((_) => false)),
        eagerError: false,
      );

      for (var success in results) {
        if (success) {
          successCount++;
        } else {
          failedCount++;
        }
      }

      // Trigger UI update
      onUpdate();
    }

    batchStopwatch.stop();
    debugPrint(
        "      ✅ Batch ${bandIndex + 1}: $successCount loaded, $failedCount failed in ${batchStopwatch.elapsedMilliseconds}ms");
  }

  /// 📏 Get entities in specific radius band
  List<T> _getEntitiesInBand(
    List<T> entities,
    double? Function(T entity) getDistance,
    double minRadius,
    double maxRadius,
  ) {
    return entities.where((entity) {
      final distance = getDistance(entity);
      final dist =
          (distance != null && distance > 0) ? distance : double.infinity;
      return dist > minRadius && dist <= maxRadius;
    }).toList();
  }

  /// 🔢 Sort entities by distance
  void _sortEntitiesByDistance(
    List<T> entities,
    double? Function(T entity) getDistance,
  ) {
    entities.sort((a, b) {
      final distA = getDistance(a);
      final distB = getDistance(b);
      final da = (distA != null && distA > 0) ? distA : 999999.0;
      final db = (distB != null && distB > 0) ? distB : 999999.0;
      return da.compareTo(db);
    });
  }
}
