import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/core/utils/order_completion_validator.dart';
import 'package:icare/features/booking/domain/entities/order.dart';

void main() {
  group('OrderCompletionValidator Tests', () {
    // Test coordinates (Cairo, Egypt area)
    const double patientLat = 30.0444;
    const double patientLng = 31.2357;

    // Helper function to create a test booking
    Booking createTestBooking({
      double? lat = patientLat, // Use named parameter with default
      double? lng = patientLng, // Use named parameter with default
    }) {
      return Booking(
        orderId: 432,
        userId: 822,
        lat: lat,
        lng: lng,
        status: 'ONGOING',
      );
    }

    // Helper function to create a test position
    Position createTestPosition({
      required double latitude,
      required double longitude,
      double accuracy = 10.0,
    }) {
      return Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: accuracy,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }

    group('Strict Range Validation (≤100m)', () {
      test('Should allow completion when nurse is exactly at patient location',
          () async {
        final booking = createTestBooking();
        final nursePosition = createTestPosition(
          latitude: patientLat,
          longitude: patientLng,
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, true);
        expect(result.distance, lessThan(1)); // Almost 0 meters
      });

      test('Should allow completion when nurse is 50m away', () async {
        final booking = createTestBooking();
        // Move ~50m north (approximately 0.00045 degrees)
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.00045,
          longitude: patientLng,
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, true);
        expect(result.distance, lessThanOrEqualTo(100));
      });

      test('Should allow completion when nurse is within 100m', () async {
        final booking = createTestBooking();
        // Move ~90m north to ensure we're safely within 100m
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.0008,
          longitude: patientLng,
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, true);
        expect(result.distance,
            lessThanOrEqualTo(OrderCompletionValidator.STRICT_RANGE_METERS));
      });
    });

    group('Relaxed Range Validation (100m-500m + Time)', () {
      test('Should reject when nurse is 200m away without arrival time',
          () async {
        final booking = createTestBooking();
        // Move ~200m north (approximately 0.0018 degrees)
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.0018,
          longitude: patientLng,
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, false);
        expect(result.reason, ValidationReason.tooFarStrict);
        expect(result.distance, greaterThan(100));
        expect(result.distance, lessThan(500));
      });

      test(
          'Should reject when nurse is 300m away with insufficient time (5 minutes)',
          () async {
        final booking = createTestBooking();
        // Move ~300m north
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.0027,
          longitude: patientLng,
        );
        final arrivedTime = DateTime.now().subtract(const Duration(minutes: 5));

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
          arrivedTime: arrivedTime,
        );

        expect(result.isValid, false);
        expect(result.reason, ValidationReason.insufficientTime);
        expect(result.message, contains('5 more minute'));
      });

      test(
          'Should allow completion when nurse is 400m away with sufficient time (10+ minutes)',
          () async {
        final booking = createTestBooking();
        // Move ~400m north
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.0036,
          longitude: patientLng,
        );
        final arrivedTime =
            DateTime.now().subtract(const Duration(minutes: 10));

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
          arrivedTime: arrivedTime,
        );

        expect(result.isValid, true);
        expect(result.distance, greaterThan(100));
        expect(result.distance, lessThanOrEqualTo(500));
      });

      test(
          'Should allow completion when nurse is 450m away with 15 minutes at location',
          () async {
        final booking = createTestBooking();
        // Move ~450m north
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.00405,
          longitude: patientLng,
        );
        final arrivedTime =
            DateTime.now().subtract(const Duration(minutes: 15));

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
          arrivedTime: arrivedTime,
        );

        expect(result.isValid, true);
      });
    });

    group('Out of Range Validation (>500m)', () {
      test('Should reject when nurse is 600m away', () async {
        final booking = createTestBooking();
        // Move ~600m north
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.0054,
          longitude: patientLng,
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, false);
        expect(result.reason, ValidationReason.tooFarRelaxed);
        expect(result.distance, greaterThan(500));
        expect(result.message, contains('Too far from patient'));
      });

      test('Should reject when nurse is 1km away even with arrival time',
          () async {
        final booking = createTestBooking();
        // Move ~1km north
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.009,
          longitude: patientLng,
        );
        final arrivedTime =
            DateTime.now().subtract(const Duration(minutes: 20));

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
          arrivedTime: arrivedTime,
        );

        expect(result.isValid, false);
        expect(result.reason, ValidationReason.tooFarRelaxed);
        expect(result.distance, greaterThan(900));
      });

      test('Should reject when nurse is 5km away', () async {
        final booking = createTestBooking();
        // Move ~5km north
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.045,
          longitude: patientLng,
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, false);
        expect(result.distance, greaterThan(4500));
      });
    });

    group('GPS Accuracy Validation', () {
      test('Should reject when GPS accuracy is poor (100m)', () async {
        final booking = createTestBooking();
        final nursePosition = createTestPosition(
          latitude: patientLat,
          longitude: patientLng,
          accuracy: 100.0, // Poor accuracy
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, false);
        expect(result.reason, ValidationReason.poorGPSAccuracy);
        expect(result.message, contains('GPS accuracy too low'));
      });

      test('Should allow when GPS accuracy is acceptable (20m)', () async {
        final booking = createTestBooking();
        final nursePosition = createTestPosition(
          latitude: patientLat,
          longitude: patientLng,
          accuracy: 20.0, // Good accuracy
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, true);
      });

      test('Should allow when GPS accuracy is at threshold (50m)', () async {
        final booking = createTestBooking();
        final nursePosition = createTestPosition(
          latitude: patientLat,
          longitude: patientLng,
          accuracy: 50.0, // At threshold
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, true);
      });
    });

    group('Edge Cases', () {
      test('Should reject when patient location is null', () async {
        final booking = createTestBooking(lat: null, lng: null);
        final nursePosition = createTestPosition(
          latitude: patientLat,
          longitude: patientLng,
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, false);
        expect(result.message, contains('Patient location not available'));
      });

      test('Should handle time exactly at threshold (10 minutes)', () async {
        final booking = createTestBooking();
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.0027, // ~300m
          longitude: patientLng,
        );
        final arrivedTime =
            DateTime.now().subtract(const Duration(minutes: 10));

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
          arrivedTime: arrivedTime,
        );

        expect(result.isValid, true);
      });

      test('Should handle distance near strict threshold (95m)', () async {
        final booking = createTestBooking();
        // Use 95m to be safely within threshold
        final nursePosition = createTestPosition(
          latitude: patientLat + 0.00085,
          longitude: patientLng,
        );

        final result = await OrderCompletionValidator.validateCompletion(
          booking: booking,
          nursePosition: nursePosition,
        );

        expect(result.isValid, true);
        expect(result.distance,
            lessThan(OrderCompletionValidator.STRICT_RANGE_METERS));
      });
    });

    group('Distance Calculation Utility', () {
      test('Should calculate distance correctly', () {
        final distance = OrderCompletionValidator.calculateDistance(
          startLat: patientLat,
          startLng: patientLng,
          endLat: patientLat + 0.009, // ~1km north
          endLng: patientLng,
        );

        expect(distance, greaterThan(900));
        expect(distance, lessThan(1100));
      });

      test('Should return 0 for same coordinates', () {
        final distance = OrderCompletionValidator.calculateDistance(
          startLat: patientLat,
          startLng: patientLng,
          endLat: patientLat,
          endLng: patientLng,
        );

        expect(distance, equals(0));
      });
    });

    group('Distance Formatting', () {
      test('Should format meters correctly', () {
        expect(OrderCompletionValidator.formatDistance(50), equals('50m'));
        expect(OrderCompletionValidator.formatDistance(999), equals('999m'));
      });

      test('Should format kilometers correctly', () {
        expect(OrderCompletionValidator.formatDistance(1000), equals('1.0km'));
        expect(OrderCompletionValidator.formatDistance(1500), equals('1.5km'));
        expect(OrderCompletionValidator.formatDistance(2345), equals('2.3km'));
      });
    });
  });
}
