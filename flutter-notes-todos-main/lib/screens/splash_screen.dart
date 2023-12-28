import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Using Future.delayed to navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () => checkUserSession());
  }

  void checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    print("user_id = $userId");

    // Assuming 'user_id' is a valid key and can be used to determine the session status
    if (userId != null) {
      Navigator.pushReplacementNamed(context, RouteNames.mainScreen);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/icons/splash.svg'),
      ),
    );
  }
}
