import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/firebase_options.dart';
import 'package:live_score_app/home_screen.dart';
import 'package:live_score_app/sign_up_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
