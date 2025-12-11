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
            // Create markers from search results when state changes
            final markers =
                await _createMarkersFromResults(searchState.results);
            if (mounted) {
              setState(() {
                _currentMarkers = markers;
                authBloc.markers = markers;
              });
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

  // Helper method to create markers from search results
  Future<Map<MarkerId, Marker>> _createMarkersFromResults(
      List<NurseEntity> results) async {
    Map<MarkerId, Marker> markers = {};

    debugPrint("🗺️ Creating ${results.length} markers from search results");

    for (var nurse in results) {
      if (nurse.userData != null &&
          nurse.userData!.lat != null &&
          nurse.userData!.long != null &&
          nurse.userData!.lat != 0.0 &&
          nurse.userData!.long != 0.0) {
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
          icon: await LocationUtil.convertImageFileToCustomBitmapDescriptor(
              nurse.userData!.image.toString()),
        );

        markers[markerId] = marker;
      }
    }

    debugPrint("✅ Created ${markers.length} markers");
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
