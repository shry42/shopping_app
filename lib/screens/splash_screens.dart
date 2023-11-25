import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:techsevin/screens/product_screen.dart';



class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'shopping',
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Image(image: AssetImage("assets/shop.png")),
            nextScreen: ProductScreen(),
            splashTransition: SplashTransition.scaleTransition,
            pageTransitionType: PageTransitionType.rightToLeft,
            backgroundColor:  const Color.fromARGB(255, 248, 226, 226)));
  }
}