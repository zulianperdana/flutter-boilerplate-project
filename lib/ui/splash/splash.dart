import 'dart:async';

import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/completer/completer.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(child: AppIconWidget(image: 'assets/icons/ic_appicon.png')),
    );
  }

  Timer startTimer() {
    const _duration = Duration(milliseconds: 5000);
    return Timer(_duration, navigate);
  }

  Future navigate() async {
    if(!appReady.isCompleted){
      appReady.complete(true);
    }
    final bool isLoggedIn = await Provider.of<Repository>(context, listen:false).authRepository.isLoggedIn;
    if (isLoggedIn ?? false) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }
}
