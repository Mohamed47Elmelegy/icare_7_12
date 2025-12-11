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
  Map<MarkerId, NurseEntity> _markerNurseMap =
      {}; // Store nurse data with marker
  Map<String, BitmapDescriptor> _imageCache = {}; // Cache loaded images
  Timer? _updateTimer;
  bool _isUpdating = false;

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

    // 🔄 Update markers every 5 seconds with progressive loading
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isUpdating && mounted && searchBloc.state is SearchSuccessState) {
        _refreshMarkersProgressively();
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
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
          markers: Set<Marker>.of(_getFilteredMarkers().values),
        ),
      ),
    );
  }

  // 🔍 Filter markers based on selected services
  Map<MarkerId, Marker> _getFilteredMarkers() {
    // If no service filter is applied, show all markers
    if (searchBloc.selectedServices.isEmpty) {
      return _currentMarkers;
    }

    // Get selected service IDs
    final selectedServiceIds =
        searchBloc.selectedServices.map((s) => s.id).toSet();

    // Filter markers based on nurse services
    return Map.fromEntries(
      _currentMarkers.entries.where((entry) {
        final nurse = _markerNurseMap[entry.key];
        if (nurse == null || nurse.servicesList == null) return false;

        // Check if nurse has any of the selected services
        return nurse.servicesList!
            .any((service) => selectedServiceIds.contains(service.id));
      }),
    );
  }

  // 🔄 Refresh markers progressively (called by timer)
  Future<void> _refreshMarkersProgressively() async {
    if (!mounted) return;

    _isUpdating = true;
    final currentState = searchBloc.state;

    if (currentState is SearchSuccessState) {
      debugPrint(
          "🔄 Periodic refresh: Updating ${currentState.results.length} nurses...");
      await _createMarkersFromResults(currentState.results);
    }

    _isUpdating = false;
  }

  // 🎯 Progressive Radius Loading Algorithm
  // Shows nearest nurses first (5km → 10km → 15km)
  // Each batch loads images and updates map progressively
  Future<Map<MarkerId, Marker>> _createMarkersFromResults(
      List<NurseEntity> results) async {
    debugPrint(
        "🗺️ Starting Progressive Radius Loading for ${results.length} nurses...");
    final stopwatch = Stopwatch()..start();

    // Filter and validate nurses (only check location data, not distance)
    final validNurses = results
        .where((nurse) =>
            nurse.userData != null &&
            nurse.userData!.lat != null &&
            nurse.userData!.long != null &&
            nurse.userData!.lat != 0.0 &&
            nurse.userData!.long != 0.0)
        .toList();

    debugPrint("   └─ ${validNurses.length} valid nurses found");

    if (validNurses.isEmpty) {
      debugPrint("   ⚠️ No nurses with valid location data!");
      // Debug: Show what's wrong with the data
      for (var nurse in results.take(3)) {
        debugPrint("      Sample nurse: ${nurse.userData?.userName}");
        debugPrint(
            "         lat: ${nurse.userData?.lat}, long: ${nurse.userData?.long}");
        debugPrint("         distanceKM: ${nurse.distanceKM}");
      }
      return {};
    }

    // Sort by distance (nearest first) - handle null and -1 values
    validNurses.sort((a, b) {
      final distA = (a.distanceKM != null && a.distanceKM! > 0)
          ? a.distanceKM!
          : 999999.0;
      final distB = (b.distanceKM != null && b.distanceKM! > 0)
          ? b.distanceKM!
          : 999999.0;
      return distA.compareTo(distB);
    });

    // Progressive radius bands: 5km, 10km, 15km, 30km, rest
    final radiusBands = [5.0, 10.0, 15.0, 30.0, double.infinity];
    int totalLoaded = 0;

    for (int bandIndex = 0; bandIndex < radiusBands.length; bandIndex++) {
      final maxRadius = radiusBands[bandIndex];
      final minRadius = bandIndex > 0 ? radiusBands[bandIndex - 1] : 0.0;

      // Get nurses in this radius band
      final nursesInBand = validNurses.where((nurse) {
        final distance = (nurse.distanceKM != null && nurse.distanceKM! > 0)
            ? nurse.distanceKM!
            : double.infinity; // Put unknown distances in last band
        return distance > minRadius && distance <= maxRadius;
      }).toList();

      debugPrint(
          "      🔍 Band ${minRadius}km → ${maxRadius == double.infinity ? '∞' : '${maxRadius}km'}: ${nursesInBand.length} nurses");

      if (nursesInBand.isEmpty) continue;

      debugPrint(
          "📍 Radius ${minRadius}km → ${maxRadius == double.infinity ? '∞' : '${maxRadius}km'}: ${nursesInBand.length} nurses");

      // Load this batch progressively
      await _loadMarkerBatch(nursesInBand, bandIndex);

      totalLoaded += nursesInBand.length;

      // Small delay between batches for smooth UI
      if (bandIndex < radiusBands.length - 1 && nursesInBand.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    stopwatch.stop();
    debugPrint(
        "✅ Progressive loading completed in ${stopwatch.elapsedMilliseconds}ms");
    debugPrint("   └─ Total markers loaded: $totalLoaded");

    return _currentMarkers;
  }

  // 🔄 Load batch of markers with images
  Future<void> _loadMarkerBatch(
      List<NurseEntity> nurses, int batchIndex) async {
    final batchStopwatch = Stopwatch()..start();

    debugPrint("      📦 Loading batch with ${nurses.length} nurses...");

    // Batch size for parallel loading (optimize based on performance)
    const int parallelBatchSize = 5;
    int successCount = 0;
    int failedCount = 0;

    for (int i = 0; i < nurses.length; i += parallelBatchSize) {
      final end = (i + parallelBatchSize < nurses.length)
          ? i + parallelBatchSize
          : nurses.length;
      final batch = nurses.sublist(i, end);

      debugPrint("         Loading images for ${batch.length} nurses...");

      // Load images in small parallel batches
      final markerFutures = batch.map((nurse) => _createSingleMarker(nurse));
      final markers = await Future.wait(markerFutures, eagerError: false);

      // Update map with new markers
      if (mounted) {
        setState(() {
          for (int j = 0; j < markers.length; j++) {
            final marker = markers[j];
            if (marker != null && j < batch.length) {
              _currentMarkers[marker.markerId] = marker;
              _markerNurseMap[marker.markerId] = batch[j]; // Store nurse data
              successCount++;
            } else if (marker == null) {
              failedCount++;
              debugPrint(
                  "         ❌ Failed to create marker for: ${batch[j].userData?.userName}");
            }
          }
        });
      }

      // Update auth bloc markers reference
      authBloc.markers = Map.from(_currentMarkers);
    }

    batchStopwatch.stop();
    debugPrint(
        "      ✅ Batch ${batchIndex + 1}: $successCount markers, $failedCount failed in ${batchStopwatch.elapsedMilliseconds}ms");
  }

  // 🎨 Create single marker with custom image
  Future<Marker?> _createSingleMarker(NurseEntity nurse) async {
    try {
      final nurseName = nurse.userData?.userName ?? "Unknown";
      final imageUrl = nurse.userData?.image.toString() ?? "";

      debugPrint("            🖼️ Loading image for: $nurseName");
      debugPrint("               URL: $imageUrl");

      // Check cache first (avoid re-downloading same image)
      BitmapDescriptor markerIcon;
      if (_imageCache.containsKey(imageUrl)) {
        markerIcon = _imageCache[imageUrl]!;
        debugPrint("               💾 Using cached image for $nurseName");
      } else {
        // Load custom image icon (with increased timeout)
        try {
          markerIcon =
              await LocationUtil.convertImageFileToCustomBitmapDescriptor(
            imageUrl,
          ).timeout(
            const Duration(seconds: 5), // Increased from 2 to 5 seconds
            onTimeout: () {
              debugPrint(
                  "               ⏱️ Timeout (5s) loading image for $nurseName");
              throw TimeoutException('Image load timeout');
            },
          );
          // Cache the loaded image
          _imageCache[imageUrl] = markerIcon;
          debugPrint("               ✅ Image loaded & cached for $nurseName");
        } catch (e) {
          // Skip colored default markers - only show custom images
          debugPrint(
              "               ❌ Failed to load image for $nurseName: $e");
          return null;
        }
      }

      // Create marker with custom icon only
      final point = LatLng(nurse.userData!.lat!, nurse.userData!.long!);
      final markerId = MarkerId("nurse-${nurse.id}");

      return Marker(
        markerId: markerId,
        position: point,
        icon: markerIcon,
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
      );
    } catch (e) {
      debugPrint("   ❌ Error creating marker: $e");
      return null;
    }
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
