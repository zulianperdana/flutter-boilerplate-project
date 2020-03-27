import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/login/login.dart';
import 'package:boilerplate/ui/splash/splash.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  ///define app routing with fluro return a `Route`
  static Router initRoutes() {
    final Router router = Router();

    router.define(splash, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SplashScreen();
    }), transitionType: TransitionType.native);

    router.define(login, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return LoginScreen();
    }), transitionType: TransitionType.native);

    router.define(home, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return HomeScreen();
    }), transitionType: TransitionType.native);

    return router;
  }
}
