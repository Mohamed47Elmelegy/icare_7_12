import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

/// Real-time distance tracker widget that updates distance periodically
///
/// Features:
/// - Updates distance every 30 seconds when booking is ONGOING
/// - Shows visual indicator (green/yellow/red) based on distance
/// - Displays last update timestamp
/// - Stops tracking when widget is disposed
class RealTimeDistanceTracker extends StatefulWidget {
  final double patientLat;
  final double patientLng;
  final String? bookingStatus;
  final bool enableAutoUpdate;

  const RealTimeDistanceTracker({
    super.key,
    required this.patientLat,
    required this.patientLng,
    this.bookingStatus,
    this.enableAutoUpdate = true,
  });

  @override
  State<RealTimeDistanceTracker> createState() =>
      _RealTimeDistanceTrackerState();
}

class _RealTimeDistanceTrackerState extends State<RealTimeDistanceTracker> {
  Timer? _locationTimer;
  double? _currentDistance;
  DateTime? _lastUpdate;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // Initial distance calculation
    _updateDistance();

    // Start periodic updates if booking is ONGOING
    if (_shouldEnableTracking()) {
      _startLocationTracking();
    }
  }

  @override
  void didUpdateWidget(RealTimeDistanceTracker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart tracking if status changed to ONGOING
    if (oldWidget.bookingStatus != widget.bookingStatus) {
      if (_shouldEnableTracking()) {
        _startLocationTracking();
      } else {
        _stopLocationTracking();
      }
    }
  }

  @override
  void dispose() {
    _stopLocationTracking();
    super.dispose();
  }

  bool _shouldEnableTracking() {
    return widget.enableAutoUpdate &&
        (widget.bookingStatus?.toUpperCase() == 'ONGOING' ||
            widget.bookingStatus?.toUpperCase() == 'WC-ON-HOLD');
  }

  void _startLocationTracking() {
    // Cancel existing timer if any
    _locationTimer?.cancel();

    // Update every 30 seconds
    _locationTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _updateDistance(),
    );

    debugPrint('📍 Started real-time location tracking');
  }

  void _stopLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
    debugPrint('🛑 Stopped real-time location tracking');
  }

  Future<void> _updateDistance() async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      // Get current nurse location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium, // Battery optimization
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Calculate distance
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        widget.patientLat,
        widget.patientLng,
      );

      if (mounted) {
        setState(() {
          _currentDistance = distance;
          _lastUpdate = DateTime.now();
          _isUpdating = false;
        });
      }

      debugPrint('📏 Distance updated: ${distance.toInt()}m');
    } catch (e) {
      debugPrint('❌ Error updating distance: $e');
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Color _getDistanceColor() {
    if (_currentDistance == null) return DMUtil.getDC();

    // Green: Within 100m
    if (_currentDistance! <= 100) {
      return Colors.green;
    }
    // Yellow: 100m - 500m
    else if (_currentDistance! <= 500) {
      return Colors.orange;
    }
    // Red: > 500m
    else {
      return Colors.red;
    }
  }

  IconData _getDistanceIcon() {
    if (_currentDistance == null) return Icons.location_on_outlined;

    if (_currentDistance! <= 100) {
      return Icons.check_circle_outline;
    } else if (_currentDistance! <= 500) {
      return Icons.warning_amber_outlined;
    } else {
      return Icons.error_outline;
    }
  }

  String _getDistanceText() {
    if (_currentDistance == null) {
      return translate("icare.calculating");
    }

    return LocationUtil.getDistanceView(
      _currentDistance! / 1000, // km
      _currentDistance!, // m
    );
  }

  String _getLastUpdateText() {
    if (_lastUpdate == null) return '';

    final now = DateTime.now();
    final difference = now.difference(_lastUpdate!);

    if (difference.inSeconds < 60) {
      return translate("icare.just_now");
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${translate("icare.minutes_ago")}';
    } else {
      return '${difference.inHours} ${translate("icare.hours_ago")}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _updateDistance, // Manual refresh on tap
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: _getDistanceColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _getDistanceColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Distance icon
            Icon(
              _getDistanceIcon(),
              size: 20.w,
              color: _getDistanceColor(),
            ),
            SizedBox(width: 8.w),

            // Distance text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: translate("icare.distance"),
                        fontSize: AppStyle.small.sp,
                        color: DMUtil.getD2C(),
                        fontWeight: FontWeight.w500,
                      ),
                      if (_isUpdating) ...[
                        SizedBox(width: 6.w),
                        SizedBox(
                          width: 12.w,
                          height: 12.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              _getDistanceColor(),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: _getDistanceText(),
                    fontSize: AppStyle.average.sp,
                    color: _getDistanceColor(),
                    fontWeight: FontWeight.w600,
                  ),
                  if (_lastUpdate != null) ...[
                    SizedBox(height: 2.h),
                    CustomText(
                      text: _getLastUpdateText(),
                      fontSize: (AppStyle.small - 1).sp,
                      color: DMUtil.getD2C().withValues(alpha: 0.6),
                    ),
                  ],
                ],
              ),
            ),

            // Refresh icon
            Icon(
              Icons.refresh,
              size: 18.w,
              color: DMUtil.getD2C().withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
