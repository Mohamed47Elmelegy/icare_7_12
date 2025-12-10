// import 'package:background_locator/location_dto.dart';

// class LocationServiceRepository {
//   static final LocationServiceRepository _instance = LocationServiceRepository._();

//   LocationServiceRepository._();

//   factory LocationServiceRepository() {
//     return _instance;
//   }

//   static const String isolateName = 'LocatorIsolate';

//   int _count = -1;

//   Future<void> init(Map<dynamic, dynamic> params) async {
//     debugPrint("***********Init callback handler");
//     if (params.containsKey('countInit')) {
//       dynamic tmpCount = params['countInit'];
//       if (tmpCount is double) {
//         _count = tmpCount.toInt();
//       } else if (tmpCount is String) {
//         _count = int.parse(tmpCount);
//       } else if (tmpCount is int) {
//         _count = tmpCount;
//       } else {
//         _count = -2;
//       }
//     } else {
//       _count = 0;
//     }
//     debugPrint("$_count");
//     await setLogLabel("start");
//     final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
//     send?.send(null);
//   }

//   Future<void> dispose() async {
//     debugPrint("***********Dispose callback handler");
//     debugPrint("$_count");
//     await setLogLabel("end");
//     final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
//     send?.send(null);
//   }

//   Future<void> callback(LocationDto locationDto) async {
//     debugPrint('$_count location in dart: ${locationDto.toString()}');
//     await setLogPosition(_count, locationDto);
//     var body = {
//       'latitude': locationDto.latitude.toString(),
//       'longitude':  locationDto.longitude.toString(),
//     };
//     var shardPref = await SharedPreferences.getInstance() ;
//     if(shardPref.containsKey(Constants.userId)){
//       var userID = shardPref.get(Constants.userId);

//       //send check if nurse location equeal patient location
//       var checkRes = await http.post(Uri.parse(ApiUrl.PATIENT_ACCESS),
//         body: json.encode(body),
//         headers: {
//           'Content-Type': 'application/json',
//           'ID': userID.toString(),
//           'latitude':locationDto.latitude.toString(),
//           'longitude':  locationDto.longitude.toString(),
//         });

//       debugPrint("***********send nurse for check equal with patient and get patient access: ${checkRes.body}");

//       await Future.delayed(const Duration(seconds: 2));
//       var response = await http.post(Uri.parse("${ApiUrl.UPDATE_USER_PROFILE}/$userID"),
//           body: json.encode(body),
//           headers: {
//             'Content-Type': 'application/json',
//             'ID': userID.toString(),
//           });
//       debugPrint("***********updateProviderCoordinateOnTracking: ${response.body} ${userID.toString()}");
//       final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
//       send?.send(locationDto);
//       _count++;
//     }
//   }

//   static Future<void> setLogLabel(String label) async {
//     final date = DateTime.now();
//     await FileManager.writeToLogFile(
//         '------------\n$label: ${formatDateLog(date)}\n------------\n');
//   }

//   static Future<void> setLogPosition(int count, LocationDto data) async {
//     final date = DateTime.now();
//     await FileManager.writeToLogFile(
//         '$count : ${formatDateLog(date)} --> ${formatLog(data)} --- isMocked: ${data.isMocked}\n');
//   }

//   static double dp(double val, int places) {
//     num mod = pow(10.0, places);
//     return ((val * mod).round().toDouble() / mod);
//   }

//   static String formatDateLog(DateTime date) {
//     return "${date.hour}:${date.minute}:${date.second}";
//   }

//   static String formatLog(LocationDto locationDto) {
//     return "${dp(locationDto.latitude, 4)} ${dp(locationDto.longitude, 4)}";
//   }
// }
