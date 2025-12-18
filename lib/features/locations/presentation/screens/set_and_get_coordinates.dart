// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/strings/constant.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class MapScreen extends StatefulWidget {
  final String title;
  final String? longitude, latitude, userID;
  final bool isSet;
  final String? userImg;
  const MapScreen({
    super.key,
    this.longitude,
    this.latitude,
    this.userID,
    this.userImg,
    required this.isSet,
    required this.title,
  });
  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  TextEditingController searchTextEditingController = TextEditingController();

  LatLng? lastLocation;
  String latitude = '', longitude = '';
  String selectedAddress = "";

  Timer? timer;
  @override
  void initState() {
    super.initState();
    _setUp();
    Timer(const Duration(seconds: 5), () {
      _setUserCurrentLocation();
    });
    timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      updateNurseLocation();
    });
  }

  updateNurseLocation() async {
    if (widget.userID == null) return;
    var trackingNurse = await UserServiceRemoteDataSource.getUserFullData(
        widget.userID.toString());
    _animateToUserLocation(
        trackingNurse.lat.toString(), trackingNurse.long.toString());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: DMUtil.getWC(),
          elevation: 0,
          toolbarHeight: AppStyle.appBarHeight.w - 10,
          iconTheme: IconThemeData(color: DMUtil.getDC(), size: 20.w),
          centerTitle: true,
          title: CustomText(
              text: widget.title,
              fontSize: AppStyle.average.sp,
              color: DMUtil.getDC()),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: lastLocation ?? const LatLng(21.4504394, 38.8815082),
                  zoom: 14),
              onMapCreated: onMapCreated,
              onCameraMove: _onCameraMoved,
              onTap: _handleTap,
              myLocationEnabled: true,
              mapType: MapType.normal,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              markers: Set<Marker>.of(markers.values),
            ),

            if (widget.isSet == false)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(
                      horizontal: AppStyle.paddingFromH.w, vertical: 10),
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: DMUtil.getWC(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: AppStyle.large.w,
                              color: DMUtil.getD2C().withOpacity(0.7),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 275.w,
                              child: CustomText(
                                text: selectedAddress,
                                fontSize: AppStyle.small.sp,
                                fontWeight: FontWeight.w600,
                                color: DMUtil.getD2C().withOpacity(0.7),
                                maxLine: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 3,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),

            // if(widget.isSet==false)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomButton(
                  height: 45.h,
                  width: 250.w,
                  color: DMUtil.getPC(),
                  circular: 6,
                  onPressed: () async {
                    if (lastLocation == null)
                      return SnackBarBuilder.showFeedBackMessage(context,
                          translate("toast.select_location"), Colors.red);
                    final data = await LocationUtil.getAndSaveLocationDetails(
                        lastLocation!);
                    if (mounted) {
                      Navigator.pop(
                          context,
                          LocationMapEntity(
                              lat: lastLocation!.latitude,
                              long: lastLocation!.longitude,
                              city: data.locality.toString(),
                              country: data.country.toString(),
                              address:
                                  "${data.country}-${data.subLocality}-${data.street}-${data.administrativeArea}"
                                      .replaceAll("null", ""),
                              postalCode: data.postalCode.toString(),
                              street: data.street.toString()));
                    }
                  },
                  widget: CustomText(
                    text: translate("map.sure_location"),
                    fontSize: AppStyle.average.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _setUp() {
    try {
      LocationUtil.checkLocationPermission();
      _setUserCurrentLocation();
      _setLocationOnMap();
    } catch (e) {
      debugPrint("_setUp: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
      mapController = controller;
    });
  }

  void _onCameraMoved(CameraPosition position) {
    lastLocation = position.target;
  }

  _setLocationOnMap() async {
    try {
      if (widget.latitude == null) return;
      debugPrint("lat & lon location: ${widget.latitude}${widget.longitude}");
      _animateToUserLocation(widget.latitude!, widget.longitude!);
    } catch (e) {
      debugPrint("_setLocationOnMap: $e");
    }
  }

  _animateToUserLocation(String lat, String long) async {
    var markerIdVal = long.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(double.parse(lat.toString()), double.parse(long.toString())),
      infoWindow: InfoWindow(
        title: widget.title.toString(),
      ),
      icon: BitmapDescriptor.fromBytes(widget.userImg != null
          ? await LocationUtil.markerNetworkIcon(widget.userImg)
          : await LocationUtil.markerIcon()),
    );
    if (mounted) {
      setState(() {
        markers.clear();
        markers[markerId] = marker;
      });
      lastLocation =
          LatLng(double.parse(lat.toString()), double.parse(long.toString()));
      mapController
          .animateCamera(CameraUpdate.newLatLngZoom(lastLocation!, 14));
    }
  }

  _handleTap(LatLng point) async {
    if (widget.isSet == false) return;
    markers.clear();
    try {
      Marker marker = Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: translate("cart.selected"),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      setState(() {
        lastLocation = point;
        markers[MarkerId(point.toString())] = marker;
      });
      LatLng latLng = LatLng(point.latitude, point.longitude);
      if (widget.title == translate("store.use_your_location")) {
        _checkIFUserLocation(
            await LocationUtil.getAndSaveLocationDetails(latLng), latLng);
      } else {
        final data = await LocationUtil.getAndSaveLocationDetails(latLng);
        Navigator.pop(
            context,
            LocationMapEntity(
                lat: point.latitude,
                long: point.longitude,
                country: data.country.toString(),
                city: data.locality.toString(),
                address:
                    "${data.country}-${data.subLocality}-${data.street}-${data.administrativeArea}"
                        .replaceAll("null", ""),
                postalCode: data.postalCode.toString(),
                street: data.street.toString()));
      }
    } catch (e) {
      debugPrint("_handleTap: $e");
    }
  }

  _setUserCurrentLocation() async {
    if (widget.longitude == null) {
      markers.clear();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
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
        mapController
            .animateCamera(CameraUpdate.newLatLngZoom(lastLocation!, 14));
        _checkIFUserLocation(
            await LocationUtil.getAndSaveLocationDetails(lastLocation!),
            lastLocation!);
      });
    }
  }

  _checkIFUserLocation(Placemark data, LatLng latLng) {
    try {
      if (widget.title == translate("store.use_your_location")) {
        SharedPref()
            .setPreferenceDouble(Constants.userLatitude, latLng.latitude);
        SharedPref()
            .setPreferenceDouble(Constants.userLongitude, latLng.longitude);
      }
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

class LocationMapEntity {
  final double lat;
  final double long;
  final String city;
  final String postalCode;
  final String street;
  final String country;
  final String address;
  LocationMapEntity(
      {required this.lat,
      required this.long,
      required this.address,
      required this.city,
      required this.country,
      required this.postalCode,
      required this.street});
}
