import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationUtil {
  static String getDistanceView(double? km, double? m) {
    // Handle invalid or null values
    if ((km == null || km == -1) && (m == null || m == -1)) {
      return '';
    }

    // If we have kilometers value
    if (km != null && km != -1 && km > 0) {
      // If less than 1 km, show in meters
      if (km < 1) {
        int meters = (km * 1000).round();
        return '${meters}m';
      }

      // If exactly a whole number (e.g., 2.0 km), show without decimals
      if (km == km.roundToDouble()) {
        return '${km.toInt()}km';
      }

      // Otherwise show with one decimal place (e.g., 1.2km, 5.3km)
      return '${km.toStringAsFixed(1)}km';
    }

    // Fallback: if only meters value is available
    if (m != null && m != -1) {
      int meters = m.round();
      // If more than 1000m, convert to km
      if (meters >= 1000) {
        double kilometers = meters / 1000;
        if (kilometers == kilometers.roundToDouble()) {
          return '${kilometers.toInt()}km';
        }
        return '${kilometers.toStringAsFixed(1)}km';
      }
      return '${meters}m';
    }

    return '';
  }

  static String calcDistance(
      {required double startLatitude,
      required double startLongitude,
      required double endLatitude,
      required double endLongitude}) {
    return formatDistance(Geolocator.distanceBetween(
            startLatitude, startLongitude, endLatitude, endLongitude)
        .toDouble());
  }

  static String formatDistance(double distanceInMeters) {
    double kilometers = distanceInMeters / 1000;
    int remainingMeters = (distanceInMeters % 1000).toInt();

    if (kilometers >= 1) {
      return '${kilometers.toInt()} km $remainingMeters m';
    } else {
      return '${distanceInMeters.toInt()} m';
    }
  }

  //location util
  static Future<Placemark> getAndSaveLocationDetails(LatLng latLng) async {
    try {
      await setLocaleIdentifier(Util.getLang() == "ar" ? "ar" : "en_US");
      List<Placemark> places =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      Placemark place = places[0];
      return place;
    } catch (e) {
      // getAndSaveLocationDetails error
      return const Placemark();
    }
  }

  static Future<bool> checkLocationPermission() async {
    try {
      await Permission.location.request();
      // await Permission.locationAlways.request();
      // await Permission.locationWhenInUse.request();
      if (!await Permission.location.serviceStatus.isEnabled) return false;
      Position position = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high));
      SharedPref()
          .setPreferenceDouble(Constants.userLatitude, position.latitude);
      SharedPref()
          .setPreferenceDouble(Constants.userLongitude, position.longitude);
      // checkLocationPermission status check

      return true;
    } catch (e) {
      // checkLocationPermission error
      return false;
    }
  }

  static Future<BitmapDescriptor> convertImageFileToCustomBitmapDescriptor(
      String imgUrl,
      {int size = 150,
      bool addBorder = false,
      Color borderColor = Colors.white,
      double borderSize = 10,
      String? title,
      Color titleColor = Colors.white,
      Color titleBackgroundColor = Colors.black}) async {
    try {
      final http.Response responseData = await http.get(Uri.parse(imgUrl));
      var uin8list = responseData.bodyBytes;
      var buffer = uin8list.buffer;
      ByteData byteData = ByteData.view(buffer);
      var tempDir = await getTemporaryDirectory();
      File imageFile = await File('${tempDir.path}/img').writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint()..color;
      final TextPainter textPainter = TextPainter();
      final double radius = size / 2;

      final Path clipPath = Path();
      clipPath.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          const Radius.circular(200)));
      clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size * 2, size.toDouble(), size * 1),
        const Radius.circular(200),
      ));

      canvas.clipPath(clipPath);

      //paintImage
      final Uint8List imageUint8List = await imageFile.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
      final ui.FrameInfo imageFI = await codec.getNextFrame();
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          image: imageFI.image);

      if (addBorder) {
        //draw Border
        paint.color = borderColor;
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = borderSize;
        canvas.drawCircle(Offset(radius, radius), radius, paint);
      }

      if (title != null) {
        if (title.length > 9) {
          title = title.substring(0, 9);
        }
        //draw Title background
        paint.color = titleBackgroundColor;
        paint.style = PaintingStyle.fill;
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10),
                const Radius.circular(100)),
            paint);

        //draw Title
        textPainter.text = TextSpan(
            text: title,
            style: TextStyle(
              fontSize: radius / 2.5,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ));
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(radius - textPainter.width / 2,
                size * 9.5 / 10 - textPainter.height / 2));
      }
      //convert canvas as PNG bytes
      final image = await pictureRecorder
          .endRecording()
          .toImage(size, (size * 1.1).toInt());
      final data = await image.toByteData(format: ui.ImageByteFormat.png);

      //convert PNG bytes as BitmapDescriptor
      return BitmapDescriptor.bytes(data!.buffer.asUint8List());
    } catch (e) {
      // convertImageFileToCustomBitmapDescriptor error
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<BitmapDescriptor> circleMarkerNetworkIcon(
      String? imgUrl) async {
    if (imgUrl == null || imgUrl.toString() == "") return markerIcon();
    final Uint8List iconBytes =
        (await NetworkAssetBundle(Uri.parse(imgUrl)).load(imgUrl))
            .buffer
            .asUint8List();
    final BitmapDescriptor bitmapDescriptor =
        BitmapDescriptor.bytes(await _addCircleMask(iconBytes, 90));

    return bitmapDescriptor;
  }

  static Future<Uint8List> _addCircleMask(Uint8List iconBytes, int size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
    final Radius radius = Radius.circular(size / 2);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.toDouble(), size.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint,
    );

    final ui.Image image = await _loadImage(iconBytes);
    canvas.drawImage(image, const Offset(0, 0), Paint());

    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image img = await picture.toImage(size, size);
    final ByteData? byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<ui.Image> _loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static markerNetworkIcon(String? imgUrl) async {
    if (imgUrl == null || imgUrl.toString() == "") return markerIcon();
    final Uint8List iconBytes =
        (await NetworkAssetBundle(Uri.parse(imgUrl)).load(imgUrl))
            .buffer
            .asUint8List();
    return await getBytesNetwork(iconBytes, 90);
  }

  static Future<Uint8List> getBytesNetwork(
      Uint8List iconBytes, int width) async {
    ui.Codec codec =
        await ui.instantiateImageCodec(iconBytes, targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static markerIcon() async {
    final Uint8List markerIcon =
        await getBytesFromAsset(AppImages.nurseMap, 90);
    return markerIcon;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
