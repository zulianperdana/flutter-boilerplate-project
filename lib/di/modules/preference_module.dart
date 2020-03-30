import 'dart:io';

import 'package:boilerplate/data/device/device.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/data/token/token_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inject/inject.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
class PreferenceModule {
  // DI variables:--------------------------------------------------------------
  Future<SharedPreferences> sharedPref;

  // constructor
  // Note: Do not change the order in which providers are called, it might cause
  // some issues
  PreferenceModule() {
    sharedPref = provideSharedPreferences();
  }

  // DI Providers:--------------------------------------------------------------
  /// A singleton preference provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  @asynchronous
  Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }

  @provide
  @singleton
  @asynchronous
  Future<Device> provideDevice() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return Device(
          deviceId: androidInfo.id + androidInfo.androidId,
          version: packageInfo.version,
          buildNumber: packageInfo.buildNumber);
    } else {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return Device(
          deviceId: iosInfo.identifierForVendor,
          version: packageInfo.version,
          buildNumber: packageInfo.buildNumber);
    }
  }

  @provide
  @singleton
  FlutterSecureStorage provideSecureStorage() {
    return const FlutterSecureStorage();
  }

  /// A singleton preference helper provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  SharedPreferenceHelper provideSharedPreferenceHelper() {
    return SharedPreferenceHelper(sharedPref);
  }

  @provide
  @singleton
  TokenHelper provideTokenHelper(FlutterSecureStorage secureStorage) {
    return TokenHelper(secureStorage);
  }
}
