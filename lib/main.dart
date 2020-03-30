import 'dart:async';

import 'package:boilerplate/utils/report_mode/custom_dialog_report_mode.dart';
import 'package:catcher/catcher_plugin.dart';
import 'package:boilerplate/constants/app_theme.dart';
import 'package:boilerplate/utils/completer/completer.dart';
import 'package:boilerplate/constants/strings.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/di/components/app_component.dart';
import 'package:boilerplate/di/modules/local_module.dart';
import 'package:boilerplate/di/modules/netwok_module.dart';
import 'package:boilerplate/di/modules/preference_module.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/service_wrapper/alert_service.dart';
import 'package:boilerplate/widgets/service_wrapper/onesignal_service.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:inject/inject.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

// global instance for app component
AppComponent appComponent;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final explicitReportModesMap = {'FormatException': SilentReportMode()};
  final explicitMap = {'FormatException': ConsoleHandler()};
  final CatcherOptions debugOptions = CatcherOptions(
    CustomDialogReportMode(),
    [ConsoleHandler()],
    explicitExceptionHandlersMap: explicitMap,
    explicitExceptionReportModesMap: explicitReportModesMap,
  );
  final CatcherOptions releaseOptions = CatcherOptions(
    DialogReportMode(),
    [
      EmailManualHandler(
        ['recipient@email.com'],
      )
    ],
    explicitExceptionHandlersMap: explicitMap,
    explicitExceptionReportModesMap: explicitReportModesMap,
  );
  appReady = Completer<bool>();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    appComponent = await AppComponent.create(
      NetworkModule(),
      LocalModule(),
      PreferenceModule(),
    );
    Catcher(appComponent.app,
        debugConfig: debugOptions, releaseConfig: releaseOptions);
  });
}

@provide
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  static Repository repository = appComponent.getRepository();
  final ThemeStore _themeStore = ThemeStore(repository);
  final PostStore _postStore = PostStore(repository)..initStore();
  final LanguageStore _languageStore = LanguageStore(repository);

  final Router router = Routes.initRoutes();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = Catcher.navigatorKey;
    return MultiProvider(
      providers: [
        Provider<ThemeStore>.value(value: _themeStore),
        Provider<PostStore>.value(value: _postStore),
        Provider<LanguageStore>.value(value: _languageStore),
        Provider<Repository>.value(value: repository),
      ],
      child: Observer(
        builder: (context) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: _themeStore.darkMode ? themeDataDark : themeData,
            onGenerateRoute: router.generator,
            locale: Locale(_languageStore.locale),
            supportedLocales: _languageStore.supportedLanguages
                .map((language) => Locale(language.locale, language.code))
                .toList(),
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              // Built-in localization of basic text for Cupertino widgets
              GlobalCupertinoLocalizations.delegate,
            ],
            // Returns a locale which will be used by the app
            localeResolutionCallback: (locale, supportedLocales) =>
                // Check if the current device locale is supported
                supportedLocales.firstWhere(
                    (supportedLocale) =>
                        supportedLocale.languageCode == locale.languageCode,
                    orElse: () => supportedLocales.first),
            builder: (_, widget) {
              return OneSignalServiceWrapper(
                navigatorKey: navigatorKey,
                child: AlertServiceWrapper(
                    navigatorKey: navigatorKey, child: widget),
              );
            },
            initialRoute: Routes.splash,
          );
        },
      ),
    );
  }
}
