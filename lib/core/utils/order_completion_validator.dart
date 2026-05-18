import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/features/booking/domain/entities/order.dart';

/// Validation result for order completion
class ValidationResult {
  final bool isValid;
  final double? distance;
  final String? message;
  final ValidationReason? reason;

  const ValidationResult({
    required this.isValid,
    this.distance,
    this.message,
    this.reason,
  });
}

/// Reasons for validation failure
enum ValidationReason {
  tooFarStrict, // Beyond 100m
  tooFarRelaxed, // Beyond 500m
  insufficientTime, // Within 500m but not enough time
  poorGPSAccuracy, // GPS accuracy too low
}

/// Validator for order completion based on geofencing
///
/// This class prevents nurses from completing orders unless they are
/// physically within acceptable range of the patient's location.
///
/// Validation Strategy:
/// - Strict Range: ≤100m - Allows immediate completion
/// - Relaxed Range: ≤500m + minimum 10 minutes at location
/// - GPS Accuracy: Must be ≤50m for reliable positioning
class OrderCompletionValidator {
  // Validation constants
  static const double strictRangeMeters = 100.0;
  static const double relaxedRangeMeters = 500.0;
  static const int minimumTimeAtLocationMinutes = 10;
  static const double maximumGpsAccuracyMeters = 50.0;

  /// Validates if nurse can complete the order based on location
  ///
  /// [booking] - The booking containing patient location (lat, lng)
  /// [nursePosition] - Current GPS position of the nurse
  /// [arrivedTime] - Optional timestamp when nurse marked arrival (for future use)
  ///
  /// Returns [ValidationResult] with validation status and details
  static Future<ValidationResult> validateCompletion({
    required Booking booking,
    required Position nursePosition,
    DateTime? arrivedTime,
  }) async {
    // Validate that patient location exists
    if (booking.lat == null || booking.lng == null) {
      return ValidationResult(
        isValid: false,
        message: translate('icare.patient_location_not_available'),
      );
    }

    // Check GPS accuracy first
    if (nursePosition.accuracy > maximumGpsAccuracyMeters) {
      return ValidationResult(
        isValid: false,
        message: translate('icare.gps_accuracy_too_low').replaceAll(
            '{accuracy}', nursePosition.accuracy.toInt().toString()),
        reason: ValidationReason.poorGPSAccuracy,
      );
    }



    // Calculate distance between nurse and patient
    double distanceInMeters = Geolocator.distanceBetween(
      nursePosition.latitude,
      nursePosition.longitude,
      booking.lat!,
      booking.lng!,
    );



    // Strict validation: Within 100m allows immediate completion
    if (distanceInMeters <= strictRangeMeters) {
      return ValidationResult(
        isValid: true,
        distance: distanceInMeters,
      );
    }

    // Relaxed validation: Within 500m + minimum time requirement
    if (distanceInMeters <= relaxedRangeMeters) {
      // If no arrival time provided, require strict range
      if (arrivedTime == null) {
        return ValidationResult(
          isValid: false,
          distance: distanceInMeters,
          message: translate('icare.move_closer_to_patient')
              .replaceAll('{distance}', distanceInMeters.toInt().toString())
              .replaceAll('{required}', strictRangeMeters.toInt().toString()),
          reason: ValidationReason.tooFarStrict,
        );
      }

      // Check if nurse has been at location for minimum required time
      int minutesAtLocation = DateTime.now().difference(arrivedTime).inMinutes;

      if (minutesAtLocation >= minimumTimeAtLocationMinutes) {
        return ValidationResult(
          isValid: true,
          distance: distanceInMeters,
        );
      }

      // Not enough time at location
      int remainingMinutes = minimumTimeAtLocationMinutes - minutesAtLocation;
      return ValidationResult(
        isValid: false,
        distance: distanceInMeters,
        message: translate('icare.wait_at_location')
            .replaceAll('{minutes}', remainingMinutes.toString()),
        reason: ValidationReason.insufficientTime,
      );
    }

    // Too far from patient location
    return ValidationResult(
      isValid: false,
      distance: distanceInMeters,
      message: translate('icare.too_far_from_patient')
          .replaceAll('{distance}', distanceInMeters.toInt().toString())
          .replaceAll('{required}', strictRangeMeters.toInt().toString()),
      reason: ValidationReason.tooFarRelaxed,
    );
  }

  /// Calculates distance between two coordinates in meters
  ///
  /// Utility method for testing and debugging
  static double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Formats distance for display
  ///
  /// Returns human-readable distance string
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()}m';
    }
    double km = meters / 1000;
    return '${km.toStringAsFixed(1)}km';
  }
}
