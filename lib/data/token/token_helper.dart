import 'dart:async';

import 'package:boilerplate/data/token/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class TokenHelper {
  // shared pref instance
  final FlutterSecureStorage _secureStorage;

  // constructor
  TokenHelper(this._secureStorage);

  // General Methods: ----------------------------------------------------------
  Future<String> get authToken async {
    return _secureStorage.read(key: TokenPreferences.auth_token);
  }

  Future<void> saveAuthToken(String authToken) async {
    await _secureStorage.write(key: TokenPreferences.auth_token, value: authToken);
  }

  Future<void> removeAuthToken() async {
    await _secureStorage.delete(key: TokenPreferences.auth_token);
  }

  Future<bool> get isLoggedIn async {
    final String token = await authToken;
    return token != null;
  }
}
