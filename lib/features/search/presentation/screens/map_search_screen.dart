// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:icare/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_event.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/features/nurse/presentation/screens/nurse_details_screen.dart';
import 'package:icare/features/doctor/presentation/screens/doctor_details_screen.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/core/utils/map_utils/searchable_marker_manager.dart';
import 'package:icare/core/utils/map_utils/searchable_progressive_loader.dart';

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
  LatLng? lastLocation;
  String latitude = '', longitude = '';
  String selectedAddress = "";

  // 🎯 Clean Architecture: Utils handle business logic
  late final SearchableMarkerManager _markerManager;
  late final SearchableProgressiveLoader _progressiveLoader;

  Timer? _updateTimer;
  bool _isUpdating = false;

  late NurseBloc nurseBloc;
  late DoctorBloc doctorBloc;
  late RootBloc rootBloc;
  late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    _markerManager = SearchableMarkerManager();
    _progressiveLoader =
        SearchableProgressiveLoader(markerManager: _markerManager);
    _setUp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    nurseBloc = NurseBloc.get(context);
    doctorBloc = DoctorBloc.get(context);
    rootBloc = RootBloc.get(context);
    searchBloc = SearchBloc.get(context);

    // 🔄 Update markers every 5 seconds with progressive loading
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isUpdating && mounted && searchBloc.state is SearchSuccessState) {
        _refreshMarkersProgressively();
      }
    });
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
            final entityType = searchState.results.isNotEmpty
                ? "${searchState.results.first.providerType}s"
                : "providers";
            AppLogger.d(
                "🔍 Search results received: ${searchState.results.length} $entityType");

            // Clear old markers before loading new ones
            _markerManager.clearMarkers();

            // Use Progressive Loader to create markers
            await _progressiveLoader.loadProgressively(
              entities: searchState.results,
              onMarkerTap: _onMarkerTap,
              onUpdate: () {
                if (mounted) {
                  setState(() {});
                }
              },
            );

            AppLogger.d(
                "🗺️ Map updated with ${_markerManager.markers.length} markers");

            // Move camera to show results (Zoomed out)
            if (_markerManager.markers.isNotEmpty && mounted) {
              try {
                final firstMarker = _markerManager.markers.values.first;
                rootBloc.mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(firstMarker.position,
                      10.0), // 10.0 is a wider/zoomed out level
                );
                AppLogger.d("📍 Camera zoomed out to show results");
              } catch (e) {
                AppLogger.e("⚠️ Could not move camera: $e");
              }
            }
          }
        },
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: lastLocation ?? const LatLng(30.059482, 31.2172649),
            zoom: 12,
          ),
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

  // 🎯 Handle marker tap - Navigate to correct details screen based on provider type
  void _onMarkerTap(MarkerId markerId, SearchableEntity entity) {
    if (entity is NurseEntity) {
      nurseBloc.add(UpdateCurrentNurseEvent(nurse: entity));
      if (mounted) {
        Util.pushPage(const NurseDetails(), context);
      }
    } else if (entity is DoctorEntity) {
      doctorBloc.add(UpdateCurrentDoctorEvent(doctor: entity));
      if (mounted) {
        Util.pushPage(const DoctorDetails(), context);
      }
    }
  }

  // 🔍 Filter markers based on selected services
  Map<MarkerId, Marker> _getFilteredMarkers() {
    final selectedServiceIds =
        searchBloc.selectedServices.map((s) => s.id).toSet();

    if (selectedServiceIds.isEmpty) {
      return _markerManager.markers;
    }

    return _markerManager.filterByServices(selectedServiceIds);
  }

  // 🔄 Refresh markers progressively (called by timer)
  Future<void> _refreshMarkersProgressively() async {
    if (!mounted || _isUpdating) return;

    _isUpdating = true;
    final currentState = searchBloc.state;

    if (currentState is SearchSuccessState) {
      final entityType = currentState.results.isNotEmpty
          ? "${currentState.results.first.providerType}s"
          : "providers";
      AppLogger.d(
          "🔄 Periodic refresh: Updating ${currentState.results.length} $entityType...");

      await _progressiveLoader.loadProgressively(
        entities: currentState.results,
        onMarkerTap: _onMarkerTap,
        onUpdate: () {
          if (mounted) {
            setState(() {});
          }
        },
      );

      AppLogger.d("✅ Periodic refresh completed");
    }

    _isUpdating = false;
  }

  // 🛠️ Setup
  void _setUp() {
    try {
      LocationUtil.checkLocationPermission();
      _setUserCurrentLocation();
    } catch (e) {
      AppLogger.e("_setUp: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        rootBloc.mapController = controller;
      });
    }
  }

  void _onCameraMoved(CameraPosition position) {
    lastLocation = position.target;
  }

  Future<void> _setUserCurrentLocation() async {
    try {
      if (widget.longitude == null) {
        // Check and request location permission
        if (await Permission.location.isGranted == false) {
          await Permission.location.request();
        }

        try {
          // Try to get current position
          Position position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          );

          if (mounted) {
            setState(() {
              lastLocation = LatLng(position.latitude, position.longitude);
            });

            // Update location in SearchBloc
            searchBloc.add(UpdateLocationEvent(
              latitude: position.latitude,
              longitude: position.longitude,
            ));

            AppLogger.d("📍 User Location Set (GPS):");
            AppLogger.d("   └─ Latitude: ${position.latitude}");
            AppLogger.d("   └─ Longitude: ${position.longitude}");
          }
        } catch (e) {
          AppLogger.w("⚠️ Failed to get GPS location: $e");

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
            searchBloc.add(UpdateLocationEvent(
              latitude: savedLat,
              longitude: savedLong,
            ));

            AppLogger.d("📍 User Location Set (Saved):");
            AppLogger.d("   └─ Latitude: $savedLat");
            AppLogger.d("   └─ Longitude: $savedLong");
          } else {
            AppLogger.w("❌ No location available");
          }
        }
      } else {
        // Use provided coordinates
        latitude = widget.latitude!;
        longitude = widget.longitude!;
        lastLocation = LatLng(
          double.parse(latitude),
          double.parse(longitude),
        );

        // Update location in SearchBloc
        if (mounted) {
          searchBloc.add(UpdateLocationEvent(
            latitude: double.parse(latitude),
            longitude: double.parse(longitude),
          ));
        }
      }

      // Animate camera and get location details
      if (mounted && lastLocation != null) {
        Timer(const Duration(milliseconds: 100), () async {
          rootBloc.mapController.animateCamera(
            CameraUpdate.newLatLngZoom(lastLocation!, 14),
          );

          final placemark =
              await LocationUtil.getAndSaveLocationDetails(lastLocation!);
          _checkIFUserLocation(placemark, lastLocation!);
        });
      }
    } catch (e) {
      AppLogger.e("_setUserCurrentLocation: $e");
    }
  }

  void _checkIFUserLocation(Placemark data, LatLng latLng) {
    try {
      if (mounted) {
        setState(() {
          selectedAddress =
              "${data.country}-${data.subLocality}-${data.street}-${data.administrativeArea}"
                  .replaceAll("null", "");
        });
      }

      SharedPref().setPreferencesString(
        Constants.userLocationDetails,
        selectedAddress,
      );
    } catch (e) {
      AppLogger.e("_checkIFUserLocation $e");
    }
  }
}
