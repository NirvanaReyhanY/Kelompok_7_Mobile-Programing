import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../routes/route_names.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  navigateToMain(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacementNamed(context, RouteNames.mainScreen);
  }

  @override
  Widget build(BuildContext context) {
    navigateToMain(context);

    return Scaffold(
      body: Center(
        child: SvgPicture.asset('assets/icons/splash.svg'),
      ),
    );
  }
}
