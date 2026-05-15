import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:live_score_app/fcm_utilis.dart';
import 'package:live_score_app/firebase_options.dart';
import 'package:live_score_app/home_screen.dart';
import 'package:live_score_app/sign_up_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//flutter framwork error
// pass all uncought fatal errors from the framework to crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await FcmUtilis.initialize();
  print(await FcmUtilis.getFCMToken());

  // Initialize the Mobile Ads SDK.
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      home: StreamBuilder( //stream listen
        stream: FirebaseAuth.instance.authStateChanges(), //app start
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if(snapshot.hasError){ //error cheak
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }
          if(snapshot.hasData){ //datta ace? then home
            return HomeScreen();
          }else {  // or signup
            return SignUpScreen();
          }
        }
      ),
    );
  }
}
