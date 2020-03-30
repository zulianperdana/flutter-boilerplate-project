import 'dart:convert';
import 'package:boilerplate/data/device/device.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/exceptions/network_exceptions.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/data/token/constants.dart';
import 'package:boilerplate/di/modules/preference_module.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:catcher/core/catcher.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as ss;
import 'package:inject/inject.dart';

@module
class NetworkModule extends PreferenceModule {
  // ignore: non_constant_identifier_names
  final String TAG = 'NetworkModule';

  // DI Providers:--------------------------------------------------------------
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  Dio provideDio(SharedPreferenceHelper sharedPrefHelper, Device device) {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      ..interceptors.add(
        InterceptorsWrapper(onRequest: (Options options) async {
          final List<int> key = utf8.encode('METhTQngTE69sYsw');
          final Hmac hmacSha256 = Hmac(sha256, key);
          final List<int> bytes = utf8.encode(device.deviceId);
          final Digest digest = hmacSha256.convert(bytes);
          // getting shared pref instance
          const prefs = ss.FlutterSecureStorage();

          // getting token
          final token = await prefs.read(key: TokenPreferences.auth_token);
          options.headers['x_time'] =
              DateTime.now().toLocal().toIso8601String();
          options.headers['signature'] = device.deviceId;
          options.headers['x_signature'] = digest.toString();
          options.headers['x_version'] = device.version;
          options.headers['x_build_number'] = device.buildNumber;
          if (token != null) {
            options.headers.putIfAbsent('Authorization', () => token);
          } else {
            print('Auth token is null');
          }
        }, onError: (DioError e) {
          if (e.response != null && e.response.statusCode == 403) {
            Catcher.reportCheckedError(AuthException(), []);
          } else {
            Catcher.reportCheckedError(
                NetworkException(
                  message: DioErrorUtil.handleError(e),
                  statusCode: e.response?.statusCode,
                ),
                []);
          }
          return e;
        }, onResponse: (Response r) {
          return r;
        }),
      );

    return dio;
  }

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  DioClient provideDioClient(Dio dio) => DioClient(dio);

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  RestClient provideRestClient() => RestClient();

  // Api Providers:-------------------------------------------------------------
  // Define all your api providers here
  /// A singleton post_api provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  PostApi providePostApi(DioClient dioClient, RestClient restClient) =>
      PostApi(dioClient, restClient);
// Api Providers End:---------------------------------------------------------

}
