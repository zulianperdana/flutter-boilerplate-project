import 'package:boilerplate/providers/alert_provider.dart';
import 'package:boilerplate/widgets/alert/alert.dart';
import 'package:boilerplate/widgets/route/dialog_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertServiceWrapper extends StatefulWidget {
  const AlertServiceWrapper({this.child, this.navigatorKey});
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  _AlertServiceWrapperState createState() => _AlertServiceWrapperState();
}

class _AlertServiceWrapperState extends State<AlertServiceWrapper> {
  bool haveAlert = false;

  Future<dynamic> showAlert(String text) async {
    if (!haveAlert) {
      try {
        setState(() {
          haveAlert = true;
        });
        return widget.navigatorKey.currentState
            .push<dynamic>(DialogRoute<dynamic>(
          pageBuilder: (_, __, ___) {
            return BasicAlert(
              content: text ?? '',
              title: 'Alert Title',
            );
          },
          barrierDismissible: true,
        ))
            .whenComplete(() {
          setState(() {
            haveAlert = false;
          });
        });
      } finally {
        setState(() {
          haveAlert = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AlertProvider(showAlert: showAlert),
      child: widget.child,
    );
  }
}
