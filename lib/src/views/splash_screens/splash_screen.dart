import 'dart:async';
import 'package:bloc_implementation/src/views/home_screen/home_screens.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE_ID = "SplashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String authToken = '';

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    _controller.forward();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
      () {
        Navigator.pushReplacementNamed(context, HomeScreens.ROUTE_ID);
      },
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xffC0F1A1),
              Color(0xff007D3D),
            ],
          )),
          child: Stack(
            children: [
              Container(
                child: Center(
                  child: ScaleTransition(
                    scale: _animation,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/logo_e_repository.png',
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.height / 3.5,
                    ),
                    // Text(
                    //   "SplashScreen",
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 40.0,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: Stack(
      //   children: [
      //     Container(
      //       child: Center(
      //         child: ScaleTransition(
      //           scale: _animation,
      //           alignment: Alignment.center,
      //           child:
      //           // Image.asset(
      //           //   'assets/logo',
      //           //   fit: BoxFit.fitWidth,
      //           //   width: MediaQuery.of(context).size.height / 3.5,
      //           // ),
      //           Text(
      //             "SplashScreen",
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontSize: 40.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
