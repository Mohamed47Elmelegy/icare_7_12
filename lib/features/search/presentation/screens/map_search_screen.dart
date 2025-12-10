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
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:icare/core/utils/location/location_util.dart';

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

    // Initial map setup with filters
    _updateMapWithFilters();

    //update markers every 5 seconds
    nurseBloc.markersTimer = Timer.periodic(const Duration(seconds: 5), (t) {
      _updateMapWithFilters();
    });
    super.didChangeDependencies();
  }

  void _updateMapWithFilters() {
    nurseBloc.add(SetNurseOnMapEvent(
      ctx: context,
      userType: searchBloc.selectedProviderType,
      serviceIds: searchBloc.selectedServices.map((s) => s.id).toList(),
    ));
  }

  @override
  void dispose() {
    nurseBloc.markersTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, searchState) {
          // When search filters change or search is successful, update the map
          if (searchState is ProviderTypeSelectedState ||
              searchState is ServicesSelectedState ||
              searchState is SearchSuccessState) {
            _updateMapWithFilters();
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            var bloc = AuthBloc.get(ctx);
            // Get all markers (filtering is now done in the bloc)
            Map<MarkerId, Marker> currentMarkers = bloc.markers;

            return GoogleMap(
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
              markers: Set<Marker>.of(currentMarkers.values),
            );
          },
        ),
      ),
    );
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
        Position position = await Geolocator.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high));
        if (mounted) {
          setState(() {
            lastLocation = LatLng(position.latitude, position.longitude);
          });
        }
      } else {
        latitude = widget.latitude!;
        longitude = widget.longitude!;
        lastLocation = LatLng(double.parse(latitude.toString()),
            double.parse(longitude.toString()));
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
