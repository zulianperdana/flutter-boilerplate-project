import 'package:boilerplate/constants/onesignal.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/utils/completer/completer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class OneSignalServiceWrapper extends StatefulWidget {
  const OneSignalServiceWrapper({this.child, this.navigatorKey});
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  _OneSignalServiceWrapperState createState() =>
      _OneSignalServiceWrapperState();
}

class _OneSignalServiceWrapperState extends State<OneSignalServiceWrapper> {
  PostStore _postStore;

  @override
  void initState() {
    OneSignal.shared.init(oneSignalAppId, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _postStore = Provider.of<PostStore>(context);
  }

  void initOneSignalListener(BuildContext context) {
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) async {
      await appReady.future;
      // will be called whenever a notification is received
    });

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      await appReady.future;
      // will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared
        .setPermissionObserver((OSPermissionStateChanges changes) async {
      await appReady.future;
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
      // will be called whenever the subscription changes
      //(ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) async {
      await appReady.future;
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  @override
  Widget build(BuildContext context) {
    /// use [Observer] to get data from state
    // return Observer(
    //   builder: (context) {
    //     initOneSignalListener(context);
    //     return widget.child;
    //   },
    // );
    return widget.child;
  }
}
