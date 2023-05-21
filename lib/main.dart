import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:simpleworld/screens/SplashScreen.dart';
import 'package:simpleworld/services/UserService.dart';
import 'package:simpleworld/store/AppStore.dart';
import 'package:simpleworld/utils/Colors.dart';
import 'package:simpleworld/utils/Constants.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';

AppStore appStore = AppStore();

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

UserService userService = UserService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  defaultRadius = 6;
  defaultAppButtonRadius = 4;
  defaultAppBarElevation = 2.0;

  defaultAppButtonTextColorGlobal = colorPrimary;
  appButtonBackgroundColorGlobal = Colors.white;

  desktopBreakpointGlobal = 700.0;

  await initialize();

  defaultAppButtonShapeBorder =
      OutlineInputBorder(borderSide: BorderSide(color: colorPrimary));

  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: defaultLanguage));
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  if (appStore.isLoggedIn) {
    appStore.setUserId(getStringAsync(USER_ID));
    appStore.setAdmin(getBoolAsync(IS_ADMIN));
    appStore.setSuperAdmin(getBoolAsync(IS_SUPER_ADMIN));
    appStore.setFullName(getStringAsync(FULL_NAME));
    appStore.setUserEmail(getStringAsync(USER_EMAIL));
    appStore.setUserProfile(getStringAsync(PROFILE_IMAGE));
  }

  if (isMobile || isWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: mAppName,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
