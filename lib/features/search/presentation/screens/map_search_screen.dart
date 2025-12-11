// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/strings/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/nurse/presentation/screens/nurse_details_screen.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';

class MapSearchScreen extends StatefulWidget {
  final String? longitude, latitude;
  final bool isSet;
  const MapSearchScreen({
    super.key,
    this.longitude,
    this.latitude,
    required this.isSet,
  });
  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapSearchScreen> {
  // final Completer<GoogleMapController> _controller = Completer();
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng? lastLocation;
  String latitude = '', longitude = '';
  String selectedAddress = "";
  Map<MarkerId, Marker> _currentMarkers = {};

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  late NurseBloc nurseBloc;
  late RootBloc rootBloc;
  late AuthBloc authBloc;
  late SearchBloc searchBloc;

  @override
  void didChangeDependencies() {
    nurseBloc = NurseBloc.get(context);
    rootBloc = RootBloc.get(context);
    authBloc = AuthBloc.get(context);
    searchBloc = SearchBloc.get(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, searchState) async {
          if (searchState is SearchSuccessState) {
            debugPrint(
                "🔄 Map received ${searchState.results.length} results, creating markers...");
            // Create markers from search results when state changes
            final markers =
                await _createMarkersFromResults(searchState.results);
            if (mounted) {
              setState(() {
                _currentMarkers = markers;
                authBloc.markers = markers;
              });
              debugPrint("🗺️ Map updated with ${markers.length} markers");

              // Move camera to show first result if available
              if (markers.isNotEmpty) {
                try {
                  final firstMarker = markers.values.first;
                  rootBloc.mapController.animateCamera(
                    CameraUpdate.newLatLngZoom(firstMarker.position, 13),
                  );
                  debugPrint(
                      "📍 Camera moved to first result: ${firstMarker.position}");
                } catch (e) {
                  debugPrint("⚠️ Could not move camera: $e");
                }
              }
            }
          }
        },
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: lastLocation ?? const LatLng(30.059482, 31.2172649),
              zoom: 12),
          onMapCreated: onMapCreated,
          onCameraMove: _onCameraMoved,
          myLocationEnabled: true,
          mapType: MapType.normal,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          markers: Set<Marker>.of(_currentMarkers.values),
        ),
      ),
    );
  }

  // 🚀 Optimized: Parallel image loading for better performance
  // Time Complexity: O(n/k) where k = concurrent operations
  // Instead of sequential O(n × t), we load all images in parallel O(t)
  Future<Map<MarkerId, Marker>> _createMarkersFromResults(
      List<NurseEntity> results) async {
    Map<MarkerId, Marker> markers = {};

    debugPrint("🗺️ Creating ${results.length} markers (parallel loading)...");
    final stopwatch = Stopwatch()..start();

    // Filter valid nurses first
    final validNurses = results
        .where((nurse) =>
            nurse.userData != null &&
            nurse.userData!.lat != null &&
            nurse.userData!.long != null &&
            nurse.userData!.lat != 0.0 &&
            nurse.userData!.long != 0.0)
        .toList();

    debugPrint("   └─ ${validNurses.length} valid locations found");

    // Load all icons in parallel (much faster!)
    final iconFutures = validNurses.map((nurse) async {
      try {
        return await LocationUtil.convertImageFileToCustomBitmapDescriptor(
                nurse.userData!.image.toString())
            .timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            // Return default icon on timeout
            return BitmapDescriptor.defaultMarkerWithHue(
                nurse.userData!.isWomen == true
                    ? BitmapDescriptor.hueRose
                    : BitmapDescriptor.hueBlue);
          },
        );
      } catch (e) {
        // Use default marker if image loading fails
        return BitmapDescriptor.defaultMarkerWithHue(
            nurse.userData!.isWomen == true
                ? BitmapDescriptor.hueRose
                : BitmapDescriptor.hueBlue);
      }
    }).toList();

    // Wait for all icons to load in parallel
    final icons = await Future.wait(iconFutures, eagerError: false);

    debugPrint(
        "   └─ Loaded ${icons.length} icons in ${stopwatch.elapsedMilliseconds}ms");

    // Create markers with pre-loaded icons (fast!)
    int iconErrors = 0;
    for (int i = 0; i < validNurses.length; i++) {
      final nurse = validNurses[i];
      final markerIcon = icons[i];

      // Count default icons as errors
      if (markerIcon == BitmapDescriptor.defaultMarker) {
        iconErrors++;
      }

      try {
        var point = LatLng(nurse.userData!.lat!, nurse.userData!.long!);
        MarkerId markerId = MarkerId(
            "${nurse.userData!.isWomen == true ? "isWomen" : "isMan"}-${nurse.id}");

        Marker marker = Marker(
          markerId: markerId,
          position: point,
          onTap: () {},
          infoWindow: InfoWindow(
            title:
                "${nurse.userData!.userName} ${ReviewModel.calcReviewStar(nurse.reviewList!)}",
            snippet:
                LocationUtil.getDistanceView(nurse.distanceKM, nurse.distanceM),
            onTap: () {
              nurseBloc.add(UpdateCurrentNurseEvent(nurse: nurse));
              if (context.mounted) {
                Util.pushPage(const NurseDetails(), context);
              }
            },
          ),
          icon: markerIcon,
        );

        markers[markerId] = marker;
      } catch (e) {
        debugPrint("   ❌ Error creating marker: $e");
      }
    }

    stopwatch.stop();
    final skipped = results.length - validNurses.length;

    debugPrint(
        "✅ Created ${markers.length} markers in ${stopwatch.elapsedMilliseconds}ms");
    if (skipped > 0) {
      debugPrint("   ⚠️ Skipped $skipped nurses (invalid location)");
    }
    if (iconErrors > 0) {
      debugPrint("   ℹ️ $iconErrors markers using default icons");
    }

    return markers;
  }

  _setUp() {
    try {
      LocationUtil.checkLocationPermission();
      _setUserCurrentLocation();
    } catch (e) {
      debugPrint("_setUp: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        // _controller.complete(controller);
        rootBloc.mapController = controller;
      });
    }
  }

  void _onCameraMoved(CameraPosition position) {
    lastLocation = position.target;
  }

  _setUserCurrentLocation() async {
    try {
      if (widget.longitude == null) {
        if (await Permission.location.isGranted == false)
          await Permission.location.request();

        try {
          // Try to get current position
          Position position = await Geolocator.getCurrentPosition(
              locationSettings:
                  const LocationSettings(accuracy: LocationAccuracy.high));

          if (mounted) {
            setState(() {
              lastLocation = LatLng(position.latitude, position.longitude);
            });

            // Update location in SearchBloc
            final searchBloc = context.read<SearchBloc>();
            searchBloc.add(UpdateLocationEvent(
              latitude: position.latitude,
              longitude: position.longitude,
            ));

            debugPrint("📍 User Location Set (GPS):");
            debugPrint("   └─ Latitude: ${position.latitude}");
            debugPrint("   └─ Longitude: ${position.longitude}");
          }
        } catch (e) {
          debugPrint("⚠️ Failed to get GPS location: $e");
          // Fallback to SharedPreferences
          final savedLat =
              SharedPref().getPreferenceDouble(Constants.userLatitude);
          final savedLong =
              SharedPref().getPreferenceDouble(Constants.userLongitude);

          if (savedLat != 0.0 && savedLong != 0.0 && mounted) {
            setState(() {
              lastLocation = LatLng(savedLat, savedLong);
            });

            // Update location in SearchBloc
            final searchBloc = context.read<SearchBloc>();
            searchBloc.add(UpdateLocationEvent(
              latitude: savedLat,
              longitude: savedLong,
            ));

            debugPrint("📍 User Location Set (Saved):");
            debugPrint("   └─ Latitude: $savedLat");
            debugPrint("   └─ Longitude: $savedLong");
          } else {
            debugPrint("❌ No location available");
          }
        }
      } else {
        latitude = widget.latitude!;
        longitude = widget.longitude!;
        lastLocation = LatLng(double.parse(latitude.toString()),
            double.parse(longitude.toString()));

        // Update location in SearchBloc
        if (mounted) {
          final searchBloc = context.read<SearchBloc>();
          searchBloc.add(UpdateLocationEvent(
            latitude: double.parse(latitude),
            longitude: double.parse(longitude),
          ));
        }
      }
      if (mounted) {
        Timer(const Duration(milliseconds: 100), () async {
          rootBloc.mapController
              .animateCamera(CameraUpdate.newLatLngZoom(lastLocation!, 14));
          _checkIFUserLocation(
              await LocationUtil.getAndSaveLocationDetails(lastLocation!),
              lastLocation!);
        });
      }
    } catch (e) {
      debugPrint("_setUserCurrentLocation: $e");
    }
  }

  _checkIFUserLocation(Placemark data, LatLng latLng) {
    try {
      if (mounted) {
        setState(() {
          selectedAddress =
              "${data.country}-${data.subLocality}-${data.street}-${data.administrativeArea}"
                  .replaceAll("null", "");
        });
      }
      SharedPref()
          .setPreferencesString(Constants.userLocationDetails, selectedAddress);
    } catch (e) {
      debugPrint("_checkIFUserLocation $e");
    }
  }
}
