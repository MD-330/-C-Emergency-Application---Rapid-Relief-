import 'package:Emergency/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:Emergency/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'api/authController.dart';
import 'api/userDataController.dart';
import 'util/demo_localization.dart';
import 'util/language_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
var globalUserId;
var globalCurrentUserImageUrl;
var languageCode;

class App extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _AppState? state = context.findAncestorStateOfType<_AppState>();
    state!.setLocale(newLocale);
    languageCode = newLocale.languageCode;

  }
  @override
  _AppState createState() => _AppState();
}
class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      languageCode = _locale!.languageCode;

    });
  }
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
        languageCode = locale.languageCode;

      });
    });

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
        ),
      );
    }
    else
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthenticationController()),
        ChangeNotifierProvider.value(value: UserDataController()),
      ],
      child: MaterialApp(
        title: 'll',
        debugShowCheckedModeBanner: false,
        // theme: kBrandTheme,
        navigatorKey: _navigatorKey,
        locale: _locale,
        supportedLocales: [
          Locale("en", "US"),
          Locale("ar", "SA"),
        ],
        localizationsDelegates: const [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        initialRoute: Router1.initialRoute,
        onGenerateRoute: Router1.generateRoute,
      ),
    );
  }
}

