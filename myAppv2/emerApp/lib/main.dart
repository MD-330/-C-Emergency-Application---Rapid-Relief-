import 'package:Emergency/values/colors.dart';//1.Its purpose is to create a multi-language application
import 'package:flutter/material.dart'; //2.with localization support, user authentication, and state management
import 'package:Emergency/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//package to enable localization in the application
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'api/authController.dart'; //as change notifiers and provides
import 'api/userDataController.dart';
import 'util/demo_localization.dart'; //It provides language files
import 'util/language_constants.dart';//for managing localized strings.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //it is initializes Firebase services using `Firebase.initializeApp()
  runApp(App());
}
var globalUserId;
var globalCurrentUserImageUrl;
class App extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _AppState? state = context.findAncestorStateOfType<_AppState>();
    state!.setLocale(newLocale);
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
    });
  }
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
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
    return MultiProvider(  //using the `MultiProvider` widget.
      providers: [ //This allows for efficient state management and data sharing across the app.
        ChangeNotifierProvider.value(value: AuthenticationController()),
        ChangeNotifierProvider.value(value: UserDataController()),
      ],
      child: MaterialApp( // UI Configuration to configure the app's properties,
        title: 'LostAndFound', //such as the app title, supported locales, localizations
        debugShowCheckedModeBanner: false,
        // theme: kBrandTheme,
        navigatorKey: _navigatorKey, // It also sets the `_navigatorKey` for navigation management.
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

