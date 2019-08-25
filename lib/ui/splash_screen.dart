import 'dart:async';

import 'package:flutter/material.dart';

import '../controller.dart';
import '../globals.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  startApp() async{
    Globals.controller = Controller();


    return Timer(Duration(seconds: 1), (){
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        startApp();
      }
    });
    super.initState();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        backgroundColor: Color(0xff471fa4),
        body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: child,
            );
          },
          child: Image.asset('assets/splash.jpg'),
        ),
      )),
    );
  }
}
