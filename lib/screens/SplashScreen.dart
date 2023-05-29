import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:simpleworld/utils/Colors.dart';
import 'package:simpleworld/utils/Constants.dart';

import '../main.dart';
import 'AdminDashboardScreen.dart';
import 'AdminLoginScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await 2.seconds.delay;

    if (appStore.isLoggedIn) {
      AdminDashboardScreen().launch(context, isNewTask: true);
    } else {
      AdminLoginScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/splash_app_logo.png', height: 120),
              16.height,
              Text(mAppName, style: boldTextStyle(size: 22)),
            ],
          ),
        ],
      ).center(),
    );
  }
}
