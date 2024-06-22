import 'package:flutter/material.dart';
import 'package:MidRemider/homePage.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:MidRemider/onboard.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 255, 255, 255), Colors.white])),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/m.gif',
                width: 200,
                height: 200,
              ),
              Text(
                'MedMinder',
                style: TextStyle(
                    fontSize: 50,
                    color: const Color.fromARGB(179, 63, 60, 60),
                    fontWeight: FontWeight.w900),
              )
            ],
          ),
        ),
      ),
      nextScreen: HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: Duration(seconds: 2),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      splashIconSize: double.infinity,
    );
  }
}
