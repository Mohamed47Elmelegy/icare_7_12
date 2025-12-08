// import 'package:background_locator/background_locator.dart';
// import 'package:background_locator/background_locator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/shared_widgets/error_widget.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'injection_container_import.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // debugPrint = (String? message, {int? wrapWidth}) {};
  await Future.wait([
    Firebase.initializeApp(),
    di.init(),
    SharedPref().instantiatePreferences(),
    LocationUtil.checkLocationPermission()
  ]);
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'ar']);
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;    
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context,widget)  => MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => di.sl<RootBloc>()),
          BlocProvider(create: (ctx) => di.sl<AuthBloc>()),
          BlocProvider(create: (ctx) => di.sl<AccountBloc>()),
          BlocProvider(create: (ctx) => di.sl<NurseBloc>()),
          BlocProvider(create: (ctx) => di.sl<LocationsBloc>()),
          BlocProvider(create: (ctx) => di.sl<CategoriesBloc>()),
          BlocProvider(create: (ctx) => di.sl<BookingBloc>()),
          BlocProvider(create: (ctx) => di.sl<ChatBloc>()),
        ],
        child: LocalizationProvider(
          state: LocalizationProvider.of(context).state,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              localizationDelegate
            ],
            supportedLocales: localizationDelegate.supportedLocales,
            locale: Util.getLang()=="en_US"?localizationDelegate.supportedLocales.first:localizationDelegate.supportedLocales.last,
            builder: (BuildContext? context, Widget? widget) {
              // Ensure orientation lock is maintained
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return CustomError(errorDetails: errorDetails);
              };
              return widget!;
            },
            title: 'Icare',
            home: const SplashScreen(),
          ),
        ),
      )
    );
  }
}




///sign with nures 
// 1123876422
// 1123876422
//email : tesstt@gmail.com



// sign with patient

// 01123876427
// 01123876427
