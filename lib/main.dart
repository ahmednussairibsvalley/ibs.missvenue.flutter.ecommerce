import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'ui/main_screen.dart';
import 'ui/login_screen.dart';
import 'ui/splash_screen.dart';

void main() async{
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  if (Platform.isIOS){
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
  _firebaseMessaging.getToken().then((value){
    print('The FCM Token: $value');
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );
  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/login' : (BuildContext context) => LoginScreen(),
      '/home' : (BuildContext context) => MainScreen(),
    },
  ));
}